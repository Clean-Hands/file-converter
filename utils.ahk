#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

;disables all GUI elements
disableAll() {
    GuiControl, Disable, aif
    GuiControl, Disable, flac
    GuiControl, Disable, m4a
    GuiControl, Disable, mp3
    GuiControl, Disable, ogg
    GuiControl, Disable, wav
    GuiControl, Disable, Awebm
    GuiControl, Disable, Vwebm
    GuiControl, Disable, avi
    GuiControl, Disable, flv
    GuiControl, Disable, mkv
    GuiControl, Disable, mov
    GuiControl, Disable, mp4
    GuiControl, Disable, gif
    GuiControl, Disable, ico
    GuiControl, Disable, jpg
    GuiControl, Disable, png
    GuiControl, Disable, Convert
    GuiControl, Disable, KeepOriginal
    GuiControl, Disable, LocateFile
    GuiControl, Disable, LocateFolder
    GuiControl, Disable, RawFileLocation
}

;enables all GUI elements
enableAll() {
    GuiControl, Enable, aif
    GuiControl, Enable, flac
    GuiControl, Enable, m4a
    GuiControl, Enable, mp3
    GuiControl, Enable, ogg
    GuiControl, Enable, wav
    GuiControl, Enable, Awebm
    GuiControl, Enable, Vwebm
    GuiControl, Enable, avi
    GuiControl, Enable, flv
    GuiControl, Enable, mkv
    GuiControl, Enable, mov
    GuiControl, Enable, mp4
    GuiControl, Enable, gif
    GuiControl, Enable, ico
    GuiControl, Enable, jpg
    GuiControl, Enable, png
    GuiControl, Enable, Convert
    GuiControl, Enable, KeepOriginal
    GuiControl, Enable, LocateFile
    GuiControl, Enable, LocateFolder
    GuiControl, Enable, RawFileLocation
}