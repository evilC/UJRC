/*
Thrustmaster T-Flight HOTAS (X) / Top Gun Afterburner II Configuration Script for EDTWeak / UJRC

Usage:
1) Unbind ALL joystick controls in Elite: Dangerous (ED) by clicking on them and tapping Escape
2) Set your ED controls to match those in the ED BINDINGS section. You should only need to add the ones marked "Non Default"
3) If you wish to have EDTweak disable Occulus Rift / TrackIR, set the key that toggles your head tracker in HEADTRACKER_KEY

*/

SetKeyDelay,0,100

; ========================================================================================================
; User configuration

limit_app := 0					; Remappings work in any app
;limit_app := "fWin32Utils"		; Limit remappings to only work in Elite
;limit_app := "Notepad"			; Limit remappings to only work in Notepad

; ED BINDINGS
; Set which keys do what in ED here
FIRE_1 := "Space"
FIRE_2 := "RButton"
INCREASE_SENSOR_RANGE := "PgUp"
DECREASE_SENSOR_RANGE := "PgDn"
NEXT_FIRE_GROUP := "n"
DEPLOY_HARD_POINTS := "Enter"
FLIGHT_ASSIST := "z"
ENGINE_BOOST := "Tab"
SILENT_RUNNING := "Delete"
DEPLOY_HEAT_SINK := "v"
POWER_ENGINES := "Up"
POWER_SYSTEMS := "Left"
POWER_WEAPONS := "Right"
POWER_BALANCE := "Down"
TARGET_AHEAD := "t"
TARGET_SUBSYS_NEXT := "y"
TARGET_SUBSYS_PREV := "u"		; Non Default
TARGET_HOSTILE_NEAREST := "h"
TARGET_HOSTILE_NEXT := "k"		; Non Default
TARGET_HOSTILE_PREV := "j"		; Non Default
TARGET_NEXT := "g"
TARGET_PREV := "b"				; Non Default
REVERSE_THROTTLE := ""

HEADTRACKER_KEY := "F9"			; Default for TrackIR
;HEADTRACKER_KEY := 0			; Disable head tracking toggle

; Declare a new controller
;elite := New UJRC_Controller({limit_app: "fWin32Utils"})	; limit keys to elite dangerous
;elite := New UJRC_Controller({limit_app: "Notepad"})		; limit keys to Notepad (testing mode)
elite := New UJRC_Controller({limit_app: limit_app})				; remapping works in any application. Keys are not hidden in this mode

; Configure setup of your Joystick here

; Add standard UJRC POV and Button controls
; One entry per "Shift Mode". Use a shiftmode of "default" for the unshifted state
; Each defined Shift Mode (apart from default) also needs a corresponding entry in the Shift Controls below

; Thrustmaster T-Flight HOTAS / Top Gun Afterburner config -------------------------------------------------------------------------------------------------------------------------------
elite.Add({type: "UJRC_POV", button: "1JoyPOV", shiftmode: "default", key_array: ["w","d","s","a"], allow_diagonals: 1 })
elite.Add({type: "UJRC_POV", button: "1JoyPOV", shiftmode: "power", key_array: [POWER_ENGINES,POWER_WEAPONS,POWER_BALANCE,POWER_SYSTEMS], allow_diagonals: 0 })
; Targetting 1 - Up: Ahead, Down: Nearest Enemy, L/R: subsys.
elite.Add({type: "UJRC_POV", button: "1JoyPOV", shiftmode: "targ1", key_array: [TARGET_AHEAD,TARGET_SUBSYS_NEXT,TARGET_HOSTILE_NEAREST,TARGET_SUBSYS_PREV], allow_diagonals: 0 })
; Targetting 2 - Up/Down: Next/Prev Hostile, L/R: Next / Prev Ship.
elite.Add({type: "UJRC_POV", button: "1JoyPOV", shiftmode: "targ2", key_array: [TARGET_NEXT,TARGET_HOSTILE_PREV,TARGET_PREV,TARGET_HOSTILE_PREV], allow_diagonals: 0 })
; Set keys while UI is active
; Same as normal, but with allow_diagonals off
elite.Add({type: "UJRC_POV", button: "1JoyPOV", shiftmode: "elitenav", key_array: ["w","d","s","a"], allow_diagonals: 0 })

; Trigger - default: Fire 1, targ1 mode: Next Fire group, power mode: increase sensor range
elite.Add({type: "UJRC_Button", stick: 1, button: "1", shiftmode: "default", key: FIRE_1})
elite.Add({type: "UJRC_Button", stick: 1, button: "1", shiftmode: "targ1", key: NEXT_FIRE_GROUP})
elite.Add({type: "UJRC_Button", stick: 1, button: "1", shiftmode: "power", key: INCREASE_SENSOR_RANGE})
; Secondary Fire 2 (Yellow Stripes) button - default: fire 2, targ1 mode: Deploy Hard Points
elite.Add({type: "UJRC_Button", stick: 1, button: "2", shiftmode: "default", key: FIRE_2})
elite.Add({type: "UJRC_Button", stick: 1, button: "2", shiftmode: "targ1", key: DEPLOY_HARD_POINTS})
elite.Add({type: "UJRC_Button", stick: 1, button: "2", shiftmode: "power", key: DECREASE_SENSOR_RANGE})

; Side Button by Trigger - Flight Assist in ALL MODES
elite.Add({type: "UJRC_Button", stick: 1, button: "3", shiftmode: "default", key: FLIGHT_ASSIST})
elite.Add({type: "UJRC_Button", stick: 1, button: "3", shiftmode: "power", key: FLIGHT_ASSIST})
elite.Add({type: "UJRC_Button", stick: 1, button: "3", shiftmode: "targ1", key: FLIGHT_ASSIST})
elite.Add({type: "UJRC_Button", stick: 1, button: "3", shiftmode: "targ2", key: FLIGHT_ASSIST})

; Side Button by Secondary Fire - default: Engine Boost, power mode: Silent Running, targ2 mode: Deploy Heat Sink
elite.Add({type: "UJRC_Button", stick: 1, button: "4", shiftmode: "default", key: ENGINE_BOOST})
elite.Add({type: "UJRC_Button", stick: 1, button: "4", shiftmode: "power", key: SILENT_RUNNING})
elite.Add({type: "UJRC_Button", stick: 1, button: "4", shiftmode: "targ2", key: DEPLOY_HEAT_SINK})

; Add Standard UJRC Shift Controls
elite.Add({type: "UJRC_Shift", button: "1Joy5", shiftmode: "power"})
elite.Add({type: "UJRC_Shift", button: "1Joy7", shiftmode: "targ1"})
elite.Add({type: "UJRC_Shift", button: "1Joy6", shiftmode: "targ2"})

; Add Custom Elite controls
elite.Add({type: "UJRC_Elite_UI_Shift", button: "1Joy8", shiftmode: "eliteui", exit_key: "Lshift", headtracker_toggle: HEADTRACKER_KEY})
elite.Add({type: "UJRC_Elite_POV", button: "1JoyPOV", shiftmode: "eliteui", key_array: ["e","3","q","1"], state_mask: [0,2,0,1], allow_diagonals: 0 })
elite.Add({type: "UJRC_Elite_UI_NavMode", button: "", shiftmode: "elitenav"})
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
elite.Heartbeat()

; ===================================================================================================
; FOOTER SECTION

; KEEP THIS AT THE END!!
#Include lib\UJRClib.ahk		; If you have the library in the same folder as your macro, use this
#Include lib\EDTweak.ahk

