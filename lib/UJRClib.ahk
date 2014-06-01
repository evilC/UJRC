/*
UJRC - Universal Joystick Remapper Companion library
By evilc@evilc.com

ToDo:
* Duplicate bindings do not work
  binding the same key twice in a hat does not work for the 2nd item
* Output to vJoy
* Support mouse wheel input
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
		this.version := 2.0.2
		this.started_up := 0

		this.hat_directions := ["Up", "Right", "Down", "Left"]	; for debugging etc

		this.input_array := []
		this.output_array := {}
		this.output_array.stick := []
		this.output_array.keymouse := {}

		this.shift_array := []
		this.shift_states := {}
		this.shift_state_index := []

		this.limit_app := parms.limit_app
		this.custom := {}		; space for data for extended classes

		global UJRC_wheel_obj
		UJRC_wheel_obj := this
		return this
	}

	SayHi(){
		msgbox I am the (fat) controller
	}

	AddButton(parms){
		parms.controller := this
		parms.shiftmode := StrLower(parms.shiftmode)

		; Register input(s) with input_array and output_array so they can be iterated
		if (parms.pov){
			; POV being added
			str := parms.stick "JOYPOV"
			arr := {type: 1, shiftmode: parms.shiftmode, string: str, allow_diagonals: parms.allow_diagonals, buttons: []}
			Loop 4 {
				if (parms.key_array[A_Index]){
					p := parms
					p.key := parms.key_array[A_Index]

					
					obj := this.DoAddButton(parms)
					obj.string := str
					obj.controller := this
					arr.buttons.insert(obj)
				}
			}
			; register POV for reading
			this.input_array.insert(arr)
		} else {
			; Regular button being added
			if (parms.stick){
				str := parms.stick "JOY" parms.button
			} else {
				str := parms.button
				limit_app := this.limit_app
				key := "*" parms.button
				if (limit_app){
					Hotkey, IfWinActive, ahk_class %limit_app%
					if (parms.button == "wheelup" || parms.button == "wheeldown"){

					} else {
						Hotkey, %key%, donothing
					}
				} else {
					if (parms.button == "wheelup"){
						key := "~" key
						Hotkey, IfWinActive
						Hotkey, %key%, UJRC_wheel_up
					}
					if (parms.button == "wheeldown"){
						key := "~" key
						Hotkey, IfWinActive
						Hotkey, %key%, UJRC_wheel_down
					}
				}

			}
			arr := {type: 0, string: str, shiftmode: parms.shiftmode, buttons: []}
			obj := this.DoAddButton(parms)
			obj.string := str
			obj.controller := this
			arr.buttons.insert(obj)
			this.input_array.insert(arr)
		}
	}

	DoAddButton(parms){
		; Create control object
		tmp := parms.type
		obj := New %tmp%(parms)

		; Add key entry to output_array
		if (!this.output_array.keymouse[obj.key]){
			this.output_array.keymouse[obj.key] := {curr: 0, last: 0}
		}
		return obj
	}

	AddShift(parms){
		parms.controller := this
		parms.shiftmode := StrLower(parms.shiftmode)

		if (parms.stick){
			if (parms.pov){
				; POV direction as shift button
			} else {
				; Stick button as shift button
				return this.DoAddShift(parms)
			}
		} else {
			; keyboard / mouse key as shift button
		}
	}

	DoAddShift(parms){
		tmp := parms.type
		obj := New %tmp%(parms)

		if (parms.stick){
			if (parms.pov){
				msgbox Not Supported
				ExitApp
			} else {
				str := parms.stick "JOY" parms.button
				obj.string := str
			}
		} else {
			obj.string := parms.button
		}
		this.shift_array.insert(obj)
		this.shift_state_index.insert(obj.shiftmode)

		return obj
	}

	Heartbeat(){
		if (!this.started_up){
			; Order input_array to have all shiftmode==default items at the end
			tmp := this.input_array
			this.input_array := []
			Loop % tmp.MaxIndex(){
				input_idx := A_Index
				if (tmp[input_idx].buttons[1].shiftmode == "default"){
					; Give input objects a boolean check to see if they are for default shiftmode
					tmp[input_idx].buttons[1].is_default := 1
					tmp[input_idx].is_default := 1
					; Do not add button(s) back in this pass
				} else {
					this.input_array.insert(tmp[input_idx])
					tmp[input_idx].buttons[1].is_default := 0
					tmp[input_idx].is_default := 0
				}
				Loop % tmp[input_idx].buttons.MaxIndex(){
					; Duplicate is_default value to all button objects in the array
					tmp[input_idx].buttons[A_Index].is_default := tmp[input_idx].buttons[1].is_default
				}
			}
			Loop % tmp.MaxIndex(){
				; Patch default button(s) in at end
				if (tmp[input_idx].buttons[1].shiftmode == "default"){
					this.input_array.insert(tmp[input_idx])
				}
			}
			this.input_array := tmp

			; Find variants (same input button, different shiftmode) of each control
			Loop % this.input_array.MaxIndex(){
				input_idx := A_Index

				Loop % this.input_array[input_idx].buttons.MaxIndex(){
					button_idx := A_Index
					; default invalid_mode for each shiftmode on the object to 0
					this.input_array[input_idx].buttons[button_idx].invalid_modes := {}
					this.input_array[input_idx].buttons[button_idx].invalid_modes.default := !this.input_array[input_idx].is_default
				}
				; Loop through each other input
				Loop % this.input_array.MaxIndex(){
					search_idx := A_Index
					; Do not compare the same item with itself
					if (search_idx != input_idx){
						if (this.input_array[input_idx].string == this.input_array[search_idx].string){
							; Found input match, cycle through object(s)
							Loop % this.input_array[input_idx].buttons.MaxIndex(){
								; Set found mode to not valid on each object
								this.input_array[input_idx].buttons[A_Index].invalid_modes[this.input_array[search_idx].shiftmode] := 1
							}
						}
					}
				}
			}
			this.started_up := 1
		}
		Loop {
			; Endless loop
			; Set output_array states to 0
			enum := this.output_array.keymouse._NewEnum()
			while enum[key, value] {
				this.output_array.keymouse[key].curr := 0
			}
			; Read status of input controls
			this.GetInputStates()

			this.GetShiftStates()

			; Loop through inputs and let them set output_array to desired state
			Loop % this.input_array.MaxIndex(){
				input_idx := A_Index
				Loop % this.input_array[input_idx].buttons.MaxIndex(){
					this.DecideDesiredState(this.input_array[input_idx].buttons[A_Index])
				}
			}
			;tooltip % json_fromobj(this.output_array)
			
			; Loop through outputs and set final state
			enum := this.output_array.keymouse._NewEnum()
			while enum[key, value] {
				;this.output_array.keymouse[key].curr := 
				if (value.curr != value.last){
					if (value.curr){
						; Down event
						;Send {%key% down}
						this.Send(key " down")
					} else {
						; Up event
						this.Send(key " up")
						;Send {%key% up}
					}
					this.output_array.keymouse[key].last := value.curr
				}
			}
			this.wheel_rolls := []
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

	; obj is a button class object
	DecideDesiredState(obj){
		if (!this.output_array.keymouse[obj.key].curr){
			; If desired state is currently up, down overrides 
			if (obj.input_state){
				; Button is currently down (though not determined if correct shiftmode yet)
				if (this.shift_states[obj.shiftmode]){
					; shiftmode for this button object is current
					this.output_array.keymouse[obj.key].curr := 1
					return 1
				}
				; Check shift_states against object's invalid_modes list
				Loop % this.shift_state_index.MaxIndex(){
					if (this.shift_states[this.shift_state_index[A_Index]]){
						if (obj.invalid_modes[this.shift_state_index[A_Index]] != 1){
							this.output_array.keymouse[obj.key].curr := 1
							return 1
						}
					}
				}
			}
		}
		; implicit deny
		this.output_array.keymouse[obj.key].curr := 0
		return 0
	}

	; Gets state of all the inputs
	GetInputStates(){
		;this.input_states := []
		Loop % this.input_array.MaxIndex() {
			input_idx := A_Index
			st := GetKeyState(this.input_array[A_Index].string, "P")
			if (this.input_array[A_Index].type){
				; POV hat
				st := (this.PovToAngle(st))


				; If not centered || (allow_diagonals is off && direction is non-even)
				if (!st || (!this.input_array[input_idx].allow_diagonals && !Mod(st, 2))){
					hat_off := 1
				} else {
					hat_off := 0
				}
				ang := 1
				; Find individual states for U/D/L/R
				Loop 4 {
					this.input_array[input_idx].buttons[A_Index].input_state := !(hat_off || !this.PovMatchesAngle(st, ang))
					ang += 2
				}
			} else {
				; Key / Mouse / Stick button
				this.input_array[input_idx].buttons[1].input_state := st
			}

		}
	}

	; Get state of all the shift buttons
	GetShiftStates(){
		this.shift_states := {}
		ctr := 0

		Loop % this.shift_array.MaxIndex() {
			st := GetKeyState(this.shift_array[A_Index].string,"P")
			this.shift_states[this.shift_array[A_Index].shiftmode] := st
			if (st){
				ctr++
			}
		}
		if (ctr){
			this.shift_states.default := 0
		} else {
			this.shift_states.default := 1
		}
	}

	; Shorthand way of querying POV
	GetPovDir(pov_button){
		return this.PovToAngle(GetKeyState(pov_button,"P"))
	}

	; Converts an AHK POV (degrees style) value to 1-8 (0 being up, going clockwise), or 0 for no angle
	PovToAngle(pov){
		if (pov == -1){
			return 0
		} else {
			return round(pov/4500) + 1
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

	OnWheel(dir){
		this.wheel_rolls.Insert(dir)
		;msgbox % "wheel: " dir
	}
}

; ======================================================== BUTTON =========================================================
; A Regular Button. Can have multiple shifted states
Class UJRC_Button {
	__New(parms){
		this.input_state := 0
		this.key := parms.key
		this.shiftmode := parms.shiftmode
		return this 
	}

	SayHi(){
		msgbox I am a button
	}

	Process(){
		; Does this control match the current shift mode?

		btn_state := GetKeyState(this.buttonstring,"P")
		correct_mode := this.controller.shift_states[this.shiftmode]
		if (this.is_default){
			; variant being processed is default mode
			if (this.controller.shift_states.default){
				correct_mode := 1
			} else if (this.controller.button_counts[this.buttonstring] == 1){
				; this button only has a setting for default - enable button in all modes
				correct_mode := 1
			} else {
				; if none of the active shift states apply to this button
				enum := this.controller.shift_states._NewEnum()
				correct_mode := 1
				while enum[key, value] {
					if (key != "default" && this.controller.shift_states[key] && this.controller.button_modes[this.buttonstring][key]){
						correct_mode := 0
						break
					}
    			}
			}
		} else {
			correct_mode := this.controller.shift_states[this.shiftmode]
		}
		if (btn_state && correct_mode ){
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
					this.controller.Send(this.key " up")
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

; ======================================================== SHIFT =========================================================
; A Shift state. Can put Buttons / POVs in other states
Class UJRC_Shift {
	__New(parms){
		this.shiftmode := parms.shiftmode
		return this
	}

	SayHi(){
		msgbox I am a shift state
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

StrLower(in){
	out := ""
	StringLower, out, in
	return out
}

; Copyright © 2013 VxE. All rights reserved.

; Serialize an object as JSON-like text OR format a string for inclusion therein.
; NOTE: scientific notation is treated as a string and hexadecimal as a number.
; NOTE: UTF-8 sequences are encoded as-is, NOT as their intended codepoint.
json_fromobj( obj ) {

	If IsObject( obj )
	{
		isarray := 0 ; an empty object could be an array... but it ain't, says I
		for key in obj
			if ( key != ++isarray )
			{
				isarray := 0
				Break
			}

		for key, val in obj
			str .= ( A_Index = 1 ? "" : "," ) ( isarray ? "" : json_fromObj( key ) ":" ) json_fromObj( val )

		return isarray ? "[" str "]" : "{" str "}"
	}
	else if obj IS NUMBER
		return obj
;	else if obj IN null,true,false ; AutoHotkey does not natively distinguish these
;		return obj

	; Encode control characters, starting with backslash.
	StringReplace, obj, obj, \, \\, A
	StringReplace, obj, obj, % Chr(08), \b, A
	StringReplace, obj, obj, % A_Tab, \t, A
	StringReplace, obj, obj, `n, \n, A
	StringReplace, obj, obj, % Chr(12), \f, A
	StringReplace, obj, obj, `r, \r, A
	StringReplace, obj, obj, ", \", A
	StringReplace, obj, obj, /, \/, A
	While RegexMatch( obj, "[^\x20-\x7e]", key )
	{
		str := Asc( key )
		val := "\u" . Chr( ( ( str >> 12 ) & 15 ) + ( ( ( str >> 12 ) & 15 ) < 10 ? 48 : 55 ) )
				. Chr( ( ( str >> 8 ) & 15 ) + ( ( ( str >> 8 ) & 15 ) < 10 ? 48 : 55 ) )
				. Chr( ( ( str >> 4 ) & 15 ) + ( ( ( str >> 4 ) & 15 ) < 10 ? 48 : 55 ) )
				. Chr( ( str & 15 ) + ( ( str & 15 ) < 10 ? 48 : 55 ) )
		StringReplace, obj, obj, % key, % val, A
	}
	return """" obj """"
} ; json_fromobj( obj )

; Used to hide keys from the game
donothing:
	return

UJRC_wheel_up:
	UJRC_wheel_obj.OnWheel(1)
	return

UJRC_wheel_down:
	UJRC_wheel_obj.OnWheel(-1)
	return