# file-converter
A file converter made with AutoHotkey and [ffmpeg](https://ffmpeg.org).

File types supported (input and output):
| Audio | Video | Image |
|-------|-------|-------|
| .aif  | .avi  | .gif  |
| .flac | .flv  | .ico  |
| .m4a  | .mkv  | .jpg  |
| .mp3  | .mov  | .png  |
| .ogg  | .mp4  |
| .wav  | .webm |
| .webm |

## Installation

Since `ffmpeg.exe` is greater than 100 MB, it has to be uploaded to GitHub using [LFS](https://git-lfs.github.com), and therefore has to be downloaded separately. To download it, simply click on the `ffmpeg.exe` file in the file tree, and then click `Download`. Finally, replace the placeholder file (called `ffmpeg.exe` but is only one kilobyte large) that was downloaded with the rest of the code with the file you just downloaded.

Alternatively, the `ffmpeg.exe` file can be downloaded directly from [ffmpeg.org](https://ffmpeg.org).

If you are using `File Converter.exe`, `ffmpeg.exe` has to be in the same directory as `File Converter.exe` for the program to work properly.

## Usage

![image of UI](https://imgur.com/RT2foT2.png)

This program gives you the ability to convert a single file or a multiple files at once.

### Single File
To choose the file to convert, click `File...` and then locate and select the file in the browser that pops up.

After that, choose the extension you want the converted file to have. You are also able to decide whether you would like to keep the original file or have it deleted after the conversion is done.

In this example, I am converting a `.jpg`into a `.png` and deleting the original file.

![image of UI](https://imgur.com/3X7417Z.png)

To convert the file, press `Convert`. The converted file will be found in the same location as the original file.
### Multiple Files
To convert multiple files, place them all in a folder, and select that folder after pressing `Folder...`. The program will search through subfolders for more files, so make sure all the files within the selected folder are files you want to convert.

After selecting an extension, the program will attempt to convert ALL files within the selected folder into that file type.

In this example, I am converting a folder of videos into `.mp4`s and not deleting the original files.

![image of UI](https://imgur.com/VBKssVH.png)

To convert the files, press `Convert` and wait for the conversions to complete. The converted files will be found in the same location as the original files.
