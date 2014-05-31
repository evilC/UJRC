/*
UJRC Configuration Script for Elite Dangerous
*/

SetKeyDelay,0,100

; ========================================================================================================
; User configuration

limit_app := 0					; Remappings work in any app
;limit_app := "fWin32Utils"		; Limit remappings to only work in Elite
;limit_app := "Notepad"			; Limit remappings to only work in Notepad

; Misc settings
STICK_ID := 1 ; the ID of your joystick.
; It is possible to take input from multiple places, but this provides a convenient way of switching stick ID for a one-stick setup

; ED BINDINGS
; Set which keys do what in ED here - in same order as in Elite menu, and named same thing
; Make sure WSAD is bound in game to ui navigation plus whatever you want it to do outside UI mode.

;FLIGHT
REVERSE_THROTTLE := "r"		; Non Default

; FLIGHT MISCELLANEOUS
DISABLE_FLIGHT_ASSIST := "z"
ENGINE_BOOST := "Tab"
ENABLE_SUPERCRUISE := "c"
ENABLE_HYPERDRIVE := "j"
TOGGLE_ROTATIONAL_CORRECTION := ""

; TARGETING
SELECT_TARGET_AHEAD := "t"
CYCLE_NEXT_SHIP := "g"
CYCLE_PREVIOUS_SHIP := "b"				; Non Default
SELECT_HIGHEST_THREAT := "h"
CYCLE_NEXT_HOSTILE_SHIP := "k"
CYCLE_PREVIOUS_HOSTILE_SHIP := "j"		; Non Default
CYCLE_NEXT_SUBSYSTEM := "y"
CYCLE_PREVIOUS_SUBSYSTEM := "u"		; Non Default

; WEAPONS
PRIMARY_FIRE := "Space"					; Non Defailt
SECONDARY_FIRE := "RButton"
CYCLE_NEXT_FIRE_GROUP := "n"
CYCLE_PREVIOUS_FIRE_GROUP := ""
DEPLOY_HARD_POINTS := "Enter"

; COOLING
TOGGLE_SILENT_RUNNING := "Delete"
DEPLOY_HEAT_SINK := "v"

;MISCELLANEOUS
TOGGLE_SHIP_LIGHTS := "l"
INCREASE_SENSOR_RANGE := "PgUp"
DECREASE_SENSOR_RANGE := "PgDn"
DIVERT_POWER_TO_ENGINES := "Up"
DIVERT_POWER_TO_WEAPONS := "Right"
DIVERT_POWER_TO_SYSTEMS := "Left"
BALANCE_POWER_DISTRIBUTION := "Down"
RESET_OCCULUS_ORIENTATION := "F12"
TOGGLE_CARGO_SCOOP := "Home"
JETTISON_ALL_CARGO := "End"
TOGGLE_LANDING_GEAR := "Insert"

; MODE SWITCHES
UI_PANEL_FOCUS := "LShift"
PAUSE_KEY := "p"
TOGGLE_HEAD_LOOK := "MButton"
TARGET_PANEL := "1"
SYSTEMS_PANEL := "2"
SENSORS_PANEL := "3"

; INTERFACE MODE
UI_PANEL_UP := "w"
UI_PANEL_RIGHT := "d"
UI_PANEL_LEFT := "a"
UI_PANEL_DOWN := "s"
NEXT_PANEL_TAB := "e"
PREVIOUS_PANEL_TAB := "q"

; HEADLOOK MODE
RESET_HEAD_LOOK := ""

; MISC
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

; Button 1 - default: Fire 1, targ1 mode: Next Fire group, power mode: increase sensor range
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "1", shiftmode: "default", key: PRIMARY_FIRE})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "1", shiftmode: "targ1", key: CYCLE_NEXT_FIRE_GROUP})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "1", shiftmode: "targ2", key: INCREASE_SENSOR_RANGE})

; Button 2 - Yellow Stripes button - default: fire 2, targ1 mode: Deploy Hard Points
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "2", shiftmode: "default", key: SECONDARY_FIRE})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "2", shiftmode: "power", key: DEPLOY_HARD_POINTS})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "2", shiftmode: "targ2", key: DECREASE_SENSOR_RANGE})

; Button 3 - Side Button by Trigger - Flight Assist / Reverse
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "3", shiftmode: "default", key: DISABLE_FLIGHT_ASSIST})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "3", shiftmode: "power", key: REVERSE_THROTTLE})

; Button 4 - Side Button by Secondary Fire - default: Engine Boost, power mode: Silent Running, targ2 mode: Deploy Heat Sink
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "4", shiftmode: "default", key: ENGINE_BOOST})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "4", shiftmode: "power", key: TOGGLE_SILENT_RUNNING})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "4", shiftmode: "targ2", key: DEPLOY_HEAT_SINK})
elite.AddShift({type: "UJRC_Shift", stick: STICK_ID, pov: 0,  button: "8", shiftmode: "ui_mode"})	; UJRC UI access method - like ED's but UI shift + up/down does tabs
;elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 0, button: "8", shiftmode: "default", key: UI_PANEL_FOCUS})	; Default UI access method.

; Add Standard UJRC Shift Controls
elite.AddShift({type: "UJRC_Shift", stick: STICK_ID, pov: 0,  button: "5", shiftmode: "power"})
elite.AddShift({type: "UJRC_Shift", stick: STICK_ID, pov: 0,  button: "7", shiftmode: "targ1"})
elite.AddShift({type: "UJRC_Shift", stick: STICK_ID, pov: 0,  button: "6", shiftmode: "targ2"})

; POVs / Dpads
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 1, shiftmode: "default", key_array: ["w","d","s","a"], allow_diagonals: 1})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 1, shiftmode: "power", key_array: [DIVERT_POWER_TO_ENGINES,DIVERT_POWER_TO_WEAPONS,BALANCE_POWER_DISTRIBUTION,DIVERT_POWER_TO_SYSTEMS], allow_diagonals: 0})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 1, shiftmode: "targ1", key_array: [SELECT_TARGET_AHEAD,CYCLE_NEXT_SUBSYSTEM,SELECT_HIGHEST_THREAT,CYCLE_PREVIOUS_SUBSYSTEM], allow_diagonals: 0})
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 1, shiftmode: "targ2", key_array: [CYCLE_NEXT_SHIP,CYCLE_PREVIOUS_HOSTILE_SHIP,CYCLE_PREVIOUS_SHIP,CYCLE_PREVIOUS_HOSTILE_SHIP], allow_diagonals: 0})
; UI mode POV / DPad
elite.AddButton({type: "UJRC_Button", stick: STICK_ID, pov: 1, shiftmode: "ui_mode", key_array: [NEXT_PANEL_TAB,SENSORS_PANEL,PREVIOUS_PANEL_TAB,TARGET_PANEL], allow_diagonals: 0})

elite.Heartbeat()

; ===================================================================================================
; FOOTER SECTION

; KEEP THIS AT THE END!!
#Include lib\UJRClib.ahk		; If you have the library in the same folder as your macro, use this
