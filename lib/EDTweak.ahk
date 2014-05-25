/*
Elite Dangerous Tweak v2.0.0
for the UJRC library
By evilc@evilc.com
*/

; ========================================================================================================
; Custom Elite Dangerous code
; Feel free to edit this if you know what you are doing

; Custom Elite variant of a UJRC Shift state.
; Disables Head Tracker on exit of UI mode
; Tracks which panel you are in
; Handles exit UI by tap of shift button
; Custom parameters:
; 	exit_key: the key to use to quit the UI (Default: LShift)
Class UJRC_Elite_UI_Shift extends UJRC_Shift {
	__New(parms){
		base.__New(parms)

		this.exit_key := parms.exit_key

		this.controller.custom.elite_ui := {}				; add a data store on the controller's custom object
		this.controller.custom.elite_ui.actions_taken := 0
		this.controller.custom.elite_ui.panel := 0
		this.controller.custom.elite_ui.headtracker_toggle:= parms.headtracker_toggle

		return this
	}

	OnDown(){
		this.controller.custom.elite_ui.actions_taken := 0
	}

	OnUp(){
		if (this.controller.custom.elite_ui.panel && !this.controller.custom.elite_ui.actions_taken){
			; Exit UI
			if (this.controller.custom.elite_ui.headtracker_toggle){
				key := this.controller.custom.elite_ui.headtracker_toggle
				Send {%key%}
			}
			key := this.exit_key
			Send {%key%}
			this.controller.custom.elite_ui.panel := 0
		}
	}
}

; Custom Elite variant of a UJRC Shift state
; Sets ShiftMode of "elitenav" when in UI mode
; This is so we can exclude diagonals while in UI mode
Class UJRC_Elite_UI_NavMode extends UJRC_Shift {
	__New(parms){
		base.__New(parms)
		return this
	}

	SetState(){
		if (this.controller.custom.elite_ui.panel && !this.controller.shift_states.eliteui){
			this.controller.shift_states[this.shiftmode] := 1
			return 1
		} else {
			this.controller.shift_states[this.shiftmode] := 0
			return 0
		}
	}

}

; Custom Elite variant of a UJRC POV Hat for UI control
; Handles UI Panel changes and tab changes
; Enables Head Tracker on enter UI
; Custom parameters:
; state_mask: A mask indicating which panel (0=none, 1=left, 2=right) each direction is.
; 	tab change directions should be set to 0
; 	In order u, r, d, l
; 	example: [0,2,0,1] for left=1, right=2, up/down=0 (tab change)
; 	This MUST correspond with the keys in key_array
; 	ie the key_array ["e","3","q","1"] matches the state_mask [0,2,0,1] for the default keys
Class UJRC_Elite_POV extends UJRC_POV {
	__New(parms){
		base.__New(parms)
		this.state_mask := parms.state_mask
		return this
	}

	BeforeDown(dir){
		; Is the direction a panel select or a tab select?
		if (this.state_mask[dir]){
			; panel select
			; same panel or new panel?
			if (this.controller.custom.elite_ui.panel != this.state_mask[dir]){
				; new panel
				if (!this.controller.custom.elite_ui.panel){
					; Enter UI Mode
					if (this.controller.custom.elite_ui.headtracker_toggle){
						key := this.controller.custom.elite_ui.headtracker_toggle
						Send {%key%}
					}
				}
				this.controller.custom.elite_ui.actions_taken++
				this.controller.custom.elite_ui.panel := this.state_mask[dir]
				; Allow keypress
				return 1
			}
		} else {
			; tab select
			if (this.controller.custom.elite_ui.panel){
				; Allow keypress
				return 1
			}
		}
		; Deny keypress
		return 0
	}

	BeforeUp(){
		return 1
	}
}
