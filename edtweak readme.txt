EDTWeak Instructions.

INSTALLATION:
1) Install AutoHotKey from http://ahkscript.org
2) Unzip the UJRC zip file to your hard disk.
3) It should contain a lib folder - you MUST NOT move the lib folder!
4) ahk files in the main folder (eg "EDTweak T-Flight HOTAS.ahk") are Configuration Scripts.
	Configuration Scripts configure EDTWeak to set your desired button configuration
	Configuration Scripts are text files that you can edit with Notepad.
	These are probably the only files you want to mess with.
	Do not mess with stuff in the lib folder if you do not know what you are doing!
5) In ahk files, lines STARTING with a SEMICOLON (";") are "Commented Out" and do not take effect.
	Sometimes multiple options are in the Configuration Script and you need to comment out the lines that you do not want.

You can make your own Configuration Scripts by duplicating one and naming it something new
eg "EDTweak MyJoystick.ahk"
You MUST keep the .ahk extension

You can also obtain Configuration Scripts from other people who have a layout you wish to use.


USAGE:
1) Unbind ALL joystick controls in Elite: Dangerous (ED) by clicking on them and tapping Escape
2) Set your ED controls to match those in the ED BINDINGS section. You should only need to add the ones marked "Non Default"
3) If you wish to have EDTweak disable Occulus Rift / TrackIR, set the key that toggles your head tracker in HEADTRACKER_KEY
4) Run EDTweak by running the Configuration Script.

Double click your Configuration Script .ahk file and a little green icon will appear in your System Tray near the clock.
You can right-click the icon and select "Exit" to quit the script.


NOTES:
DO NOT run more than one Configuration Script at a time, strange things may happen!
