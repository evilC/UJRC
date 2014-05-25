/*
UJRC - Universal Joystick Remapper Companion library v 1.0.0
By evilc@evilc.com

*/

SetKeyDelay,0,100

; UJR Companion Library
; Not intended to be user editable.
; If you need to change something in here, ask for a UJRC update

; Controller Class
; Declare one of these, then add controls using .Add()
; Start it running using Heartbeat()
Class UJRC_Controller {
	__New(parms){
		this.version := 1.0.0
		this.limit_app := parms.limit_app
		this.shift_states := {}
		this.shift_buttons := []
		this.normal_buttons := []
		this.pov_switches := []

		this.custom := {}		; space for data for extended classes

		return this
	}

	Add(parms){
		parms.controller := this

		tmp := parms.type
		obj := New %tmp%(parms)

	}

	Heartbeat(){
		Loop {
			; Detect which states are active
			sc := 0
			Loop % this.shift_buttons.MaxIndex() {
				res := this.shift_buttons[A_Index].SetState()
				if (res){
					;tooltip % this.shift_buttons[A_Index].shiftmode
				}
				sc += res

			}
			if (sc){
				this.shift_states.default := 0
			} else {
				; No shift states active - set default state
				this.shift_states.default := 1
				;tooltip % "default"
			}
			; ToDo: Process ups then downs, so order is not important.
			Loop % this.pov_switches.MaxIndex(){
				this.pov_switches[A_Index].Process()
			}
			Loop % this.normal_buttons.MaxIndex(){
				this.normal_buttons[A_Index].Process()
			}
			Sleep 5
		}
	}

	Send(keystring){
		limit_app := this.limit_app
		if (limit_app){
			if (WinActive("ahk_class " limit_app)){
				Send {%keystring%} 
			}
		} else {
			Send {%keystring%}
		}
	}

	; Shorthand way of querying POV
	GetPovDir(pov_button){
		return this.PovToAngle(GetKeyState(pov_button,"P"))
	}

	; Converts an AHK POV (degrees style) value to 0-7 (0 being up, going clockwise)
	PovToAngle(pov){
		if (pov == -1){
			return -1
		} else {
			return round(pov/4500)
		}
	}

	; Calculates whether a u/d/l/r value matches a pov (1-8) value
	; eg Up is pov angle 1, but pov 8 (up left) and 2 (up right) also mean "up" is held
	PovMatchesAngle(pov,angle){
		; pov = 1-8 or 0 (no angle)
		; angle = 1,3,5 or 7
		if (!pov){
			return 0
		}
		if (angle == 1){
			; up
			if (pov == 8 || pov == 1 || pov == 2){
				return 1
			}
		} else if (angle == 5){
			; down
			if (pov >= 4 && pov <= 6){
				return 1
			}	
		} else if (angle == 7){
			; left
			if (pov >= 6 && pov <= 8){
				return 1
			}
		} else if (angle == 3){
			; right
			if (pov >= 2 && pov <= 4){
				return 1
			}
		}
		return 0
	}


}

; A Regular Button. Can have multiple shifted states
Class UJRC_Button {
	__New(parms){
		this.controller := parms.controller
		this.controller.normal_buttons.Insert(this)

		this.state := 0

		this.stick := parms.stick
		if (this.stick){
			this.buttonstring := parms.stick "Joy" parms.button
		} else {
			this.buttonstring := parms.button
			limit_app := this.controller.limit_app
			if (limit_app){
				key := "*" this.buttonstring
				Hotkey, IfWinActive, ahk_class %limit_app%
				Hotkey, %key%, donothing
			}
		}
		this.shiftmode := parms.shiftmode
		this.key := parms.key

		return this
	}

	Process(){
		if (GetKeyState(this.buttonstring,"P") && this.controller.shift_states[this.shiftmode] ){
			; key is down
			if (!this.state){
				; previous state is up
				if (this.BeforeDown(A_Index)){
					;key := this.key " down"
					;Send {%key%}
					this.controller.Send(this.key " down")
					this.state := 1
				}
			}
		} else {
			;key is up
			if (this.state){
				; previous state is down
				if (this.BeforeUp()){
					;key := this.key " up"
					;Send {%key%}
					controller.Send(this.key " up")
					this.state := 0
				}
			}
		}
	}

	; Methods intended to be extended
	; Called before down
	; return 1 to allow keypress, 0 to deny
	BeforeDown(){
		return 1
	}

	BeforeUp(){
		return 1
	}
}

; A POV Hat / D-Pad. Can have multiple shifted states
; Parameters:
; key_array: what keys to hit for each of the 4 directions (up,right,down,left)
; eg: ["e","3","q","1"] for l/r = left/right panel and u/d = next/prev tab
Class UJRC_POV {
	__New(parms){
		this.controller := parms.controller
		this.controller.pov_switches.Insert(this)

		this.state := 0	; Overall state - 0 = nothing, 1 = a direction is pressed
		this.buttonstring := parms.button
		this.state_array := [0,0,0,0] ; state of each of the 4 directions
		this.key_array := parms.key_array
		this.shiftmode := parms.shiftmode

		this.allow_diagonals := parms.allow_diagonals
		this.diagonal_mask := [1,0,1,0,1,0,1,0]

		return this
	}

	Process(){
		dir := this.controller.GetPovDir(this.buttonstring)
		if (dir == -1){
			this.state := 0
		} else {
			this.state := 1
		}
		dir += 1
		ang := 1

		Loop 4 {
			diagonal_check := this.allow_diagonals || this.diagonal_mask[dir]
			; Check the four cardinal directions to see if current direction matches
			if (this.controller.shift_states[this.shiftmode] && dir && this.controller.PovMatchesAngle(dir, ang) && diagonal_check){
				; The button is "held"
				if (!this.state_array[A_Index]){
					; key is currently up
					if (this.BeforeDown(A_Index)){
						;tooltip % key
						;key := this.key_array[A_Index] " down"
						;Send {%key%}
						this.controller.Send(this.key_array[A_Index] " down")
						this.state_array[A_Index] := 1
					}
				}
			} else {
				; The button is not held
				if (this.state_array[A_Index]){
					; key is currently down
					if (this.BeforeUp(A_Index)){
						;key := this.key_array[A_Index] " up"
						;Send {%key%}
						this.controller.Send(this.key_array[A_Index] " up")
						this.state_array[A_Index] := 0
					}
				}
			}
			; Jump to next cardinal direction
			ang += 2
		}
	}

	; Methods intended to be extended
	; Called before down
	; return 1 to allow keypress, 0 to deny
	BeforeDown(dir){
		return 1
	}

	BeforeUp(dir){
		return 1
	}
}

; A Shift state. Can put Buttons / POVs in other states
Class UJRC_Shift {
	__New(parms){
		this.controller := parms.controller
		this.controller.shift_buttons.Insert(this)

		this.state := 0
		this.buttonstring := parms.button
		this.shiftmode := parms.shiftmode

		this.controller.shift_states[this.shiftmode] := 0
		return this
	}

	; Sets the state of the controller's shift_states array to reflect status of this Shift button
	SetState(){
		st := GetKeyState(this.buttonstring,"P")
		if (st){
			; button is pressed
			if (!this.controller.shift_states[this.shiftmode]){
				; down
				this.OnDown()
			}
		} else {
			; button is not pressed
			if (this.controller.shift_states[this.shiftmode]){
				; up
				this.OnUp()
			}
		}
		this.controller.shift_states[this.shiftmode] := st
		return st
	}

	; Methods intended to be extended
	; Called before down event
	OnDown(){

	}

	;Called before up event
	OnUp(){

	}
}

; Used to hide keys from the game
donothing:
	return