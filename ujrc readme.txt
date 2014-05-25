UJRC Readme

Usage:
1) Decide which buttons you wish to have shifted / unshifted modes for and which buttons you wish to use for shift.
2) Unbind ALL these buttons in your game by clicking on them and tapping Escape
3) Start with an example configuration script and rename it to something else ending in .ahk
	eg Rename "EDTweak T-Flight HOTAS.ahk" to "MyGame - MyJoystick.ahk"
4) Edit the configuration script to configure your joystick as required.

Notes:
1) the "button" parameter for a UJRC_Button type can be a joystick button or keyboard/mouse key.
	keyboard / mouse keys are only hidden from the game if you pass a limit_app parameter to UJRC_Controller
	like so: elite := New UJRC_Controller({limit_app: "fWin32Utils"})
2) AHK only supports ONE POV hat per joystick :(
	A solution for mapping more hats may well be found in the future
3) A Joypad D-Pad counts as a POV Hat.
4) All Keyboard Key / Mouse Button names are AHk key names.
	Use lower case as "A" also holds shift as well as pressing the "a" key
	A list can be found here: http://www.autohotkey.com/docs/KeyList.htm
5) As of yet, you cannot "Send" joystick buttons
