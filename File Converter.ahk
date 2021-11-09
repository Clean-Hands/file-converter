#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, force

Gui, Color, Aqua
Gui, Font, s18 Bold Underline
Gui, Add, Text, x0 y10 w300 +Center, File Converter 
Gui, Font, s10 Norm Bold
Gui, Font, s8 Norm
Gui, Add, Edit, x5 y55 h20 w200 +Left +ReadOnly vRawFileLocation , %RawFileLocation%
Gui, Add, Button, x+1 y54 h22 w40 gLocateFile vLocateFile, File...
Gui, Add, Button, x+1 y54 h22 w50 gLocateFolder vLocateFolder, Folder...

Gui, Font, s12 Bold Underline
Gui, Add, Text, x30 y90, Audio:
Gui, Add, Text, x122 y90, Video:
Gui, Add, Text, x213 y90, Image:

Gui, Font, s10 Norm
;audio
Gui, Add, Radio, x30 y115 vaif, .aif
Gui, Add, Radio, x30 y135 vflac, .flac
Gui, Add, Radio, x30 y155 vm4a, .m4a
Gui, Add, Radio, x30 y175 vmp3, .mp3
Gui, Add, Radio, x30 y195 vogg, .ogg
Gui, Add, Radio, x30 y215 vwav, .wav
Gui, Add, Radio, x30 y235 vAwebm, .webm
;video
Gui, Add, Radio, x122 y115 vavi, .avi
Gui, Add, Radio, x122 y135 vflv, .flv
Gui, Add, Radio, x122 y155 vmkv, .mkv
Gui, Add, Radio, x122 y175 vmov, .mov
Gui, Add, Radio, x122 y195 vmp4, .mp4
Gui, Add, Radio, x122 y215 vVwebm, .webm
; Gui, Add, Radio, x122 y235 , .
; Gui, Add, Radio, x122 y255 , .
;image
Gui, Add, Radio, x213 y115 vgif, .gif
Gui, Add, Radio, x213 y135 vico, .ico
Gui, Add, Radio, x213 y155 vjpg, .jpg
Gui, Add, Radio, x213 y175 vpng, .png
; Gui, Add, Radio, x213 y195 , .
; Gui, Add, Radio, x213 y215 , .
; Gui, Add, Radio, x213 y235 , .
; Gui, Add, Radio, x213 y255 , .
Gui, Add, Checkbox, x6 y265 Checked vKeepOriginal, Keep original file(s)?
Gui, Font, Bold s15
Gui, Add, Button, x5 y285 h50 w290 gConvert vConvert, Convert
Gui, Show, w300 h340, File Converter
Return

LocateFile:
    FileSelectFile, RawFileLocation, *, 0, Select the file you would like to convert.
    GuiControl,, RawFileLocation, %RawFileLocation%
    IsFolder := false
    Return

LocateFolder:
    FileSelectFolder, RawFileLocation, *, 0, Select the folder you would like to convert.
    GuiControl,, RawFileLocation, %RawFileLocation%
    IsFolder := true
    Return

Convert:
    Gui, Submit, NoHide

    ;checks if user input a path for the file or folder
    if !(RawFileLocation) {
        MsgBox, No path provided.
        Return
    }

    disableAll()

    ;checks if user chose a folder or single file
    if (IsFolder){

        ;checks if folder the user chose exists
        if !(FileExist(RawFileLocation)) {
            MsgBox, Folder does not exist.
            enableAll()
            Return
        }

        ;resets booleans
        success := false
        failure := false

        ;loops through all files within the selected folder and attempts to convert them to the specified extension
        Loop, Files, %RawFileLocation%\*, R 
		{

            ;splits the file location by spaces, replaces them with "`` " to have ahk turn it into "` ", then PowerShell recognize it as a real space
            FileLocationSplit := StrSplit(A_LoopFilePath, " ", " ")
            for index, element in FileLocationSplit {
                if !(index = 1) {
                    FileLocation := FileLocation . "`` " . element
                } else {
                    FileLocation := element
                }
            }

            ;cuts off the old extension
            SubStrStartingPos := InStr(FileLocation, ".", false, -1)
            ConvertedFileLocation := SubStr(FileLocation, 1, SubStrStartingPos)

            ;assigns new extension
            if (wav = 1)
                ext := "wav"
            else if (mp3 = 1)
                ext := "mp3"
            else if (ogg = 1)
                ext := "ogg"
            else if (flac = 1)
                ext := "flac"
            else if (aif = 1)
                ext := "aif"
            else if (m4a = 1)
                ext := "m4a"
            else if (Awebm = 1 || Vwebm = 1)
                ext := "webm"
            else if (mp4 = 1)
                ext := "mp4"
            else if (mkv = 1)
                ext := "mkv"
            else if (avi = 1)
                ext := "avi"
            else if (mov = 1)
                ext := "mov"
            else if (flv = 1)
                ext := "flv"
            else if (png = 1)
                ext := "png"
            else if (jpg = 1)
                ext := "jpg"
            else if (gif = 1)
                ext := "gif"
            else if (ico = 1)
                ext := "ico"
            else {
                MsgBox, No extension selected.
                enableAll()
                Return
            }

            ;concatenates converted file locations and the new extensions
            ConvertedFileLocation := ConvertedFileLocation . ext
            SubStrStartingPos := InStr(A_LoopFilePath, ".", false, -1)
            RawConvertedFileLocation := SubStr(A_LoopFilePath, 1, SubStrStartingPos)
            RawConvertedFileLocation := RawConvertedFileLocation . ext

            ;splits A_WorkingDir by spaces, replaces them with "`` " to have ahk turn it into "` ", then PowerShell recognize it as a real space
            WorkingDir := A_WorkingDir
            FileLocationSplit := StrSplit(WorkingDir, " ", " ")
            for index, element in FileLocationSplit {
                if !(index = 1) {
                    WorkingDir := WorkingDir . "`` " . element
                } else {
                    WorkingDir := element
                }
            }

            ;runs final conversion command only if extensions are different
            if (FileLocation != ConvertedFileLocation) {
                Run, PowerShell -Command %WorkingDir%\ffmpeg.exe -n -i %FileLocation% %ConvertedFileLocation%
            } else {
                failure = true
            }

            ;deletes old file once powershell closes if KeepOriginal is unchecked and the new file exists
            if (FileLocation != ConvertedFileLocation) {
                Sleep, 500
                WinWaitClose, Windows PowerShell
                if FileExist(RawConvertedFileLocation) {
                    if (KeepOriginal = 0) {
                        FileDelete, %A_LoopFilePath%
                    }
                    success = true
                } else {
                    failure = true
                }
            }
        }

        ;prints correct outcome statements
        if (success && failure) {
            MsgBox, Conversion partially succeeded, some files may be unconverted.
        } else if (success) {
            MsgBox, Conversion succeeded.
        } else if (failure) {
            MsgBox, Conversion failed.
        } else {
            MsgBox, How did this happen
        }

    ;if a single file, not a folder
    } else {

        ;checks if file the user chose exists
        if !(FileExist(RawFileLocation)) {
            MsgBox, File does not exist.
            enableAll()
            Return
        }

        ;splits the file location by spaces, replaces them with "`` " to have ahk turn it into "` ", then PowerShell recognize it as a real space
        FileLocationSplit := StrSplit(RawFileLocation, " ", " ")
        for index, element in FileLocationSplit {
            if !(index = 1) {
                FileLocation := FileLocation . "`` " . element
            } else {
                FileLocation := element
            }
        }

        ;cuts off the old extension
        SubStrStartingPos := InStr(FileLocation, ".", false, -1)
        ConvertedFileLocation := SubStr(FileLocation, 1, SubStrStartingPos)

        ;assigns new extension
        if (wav = 1)
            ext := "wav"
        else if (mp3 = 1)
            ext := "mp3"
        else if (ogg = 1)
            ext := "ogg"
        else if (flac = 1)
            ext := "flac"
        else if (aif = 1)
            ext := "aif"
        else if (m4a = 1)
            ext := "m4a"
        else if (Awebm = 1 || Vwebm = 1)
            ext := "webm"
        else if (mp4 = 1)
            ext := "mp4"
        else if (mkv = 1)
            ext := "mkv"
        else if (avi = 1)
            ext := "avi"
        else if (mov = 1)
            ext := "mov"
        else if (flv = 1)
            ext := "flv"
        else if (png = 1)
            ext := "png"
        else if (jpg = 1)
            ext := "jpg"
        else if (gif = 1)
            ext := "gif"
        else if (ico = 1)
            ext := "ico"
        else {
            MsgBox, No extension selected.
            enableAll()
            Return
        }

        ;concatenates converted file location and the new extension
        ConvertedFileLocation := ConvertedFileLocation . ext
        SubStrStartingPos := InStr(RawFileLocation, ".", false, -1)
        RawConvertedFileLocation := SubStr(RawFileLocation, 1, SubStrStartingPos)
        RawConvertedFileLocation := RawConvertedFileLocation . ext

        ;splits A_WorkingDir by spaces, replaces them with "`` " to have ahk turn it into "` ", then PowerShell recognize it as a real space
        WorkingDir := A_WorkingDir
        FileLocationSplit := StrSplit(WorkingDir, " ", " ")
        for index, element in FileLocationSplit {
            if !(index = 1) {
                WorkingDir := WorkingDir . "`` " . element
            } else {
                WorkingDir := element
            }
        }

        ;runs final conversion command only if extensions are different
        if (FileLocation != ConvertedFileLocation) {
            Run, PowerShell -Command %WorkingDir%\ffmpeg.exe -n -i %FileLocation% %ConvertedFileLocation%
        } else {
            MsgBox, Input and output extensions are identical.
            enableAll()
            Return
        }

        ;deletes old file once powershell closes if KeepOriginal is unchecked and the new file exists
        Sleep, 500
        WinWaitClose, Windows PowerShell
        if FileExist(RawConvertedFileLocation) {
            if (KeepOriginal = 0) {
                FileDelete, %RawFileLocation%
            }
            MsgBox, Conversion succeeded.
        } else {
            MsgBox, Conversion failed.
        }
    }
    enableAll()

Return

;makes the red "x" actually quit the script
GuiClose:
	ExitApp
Return

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