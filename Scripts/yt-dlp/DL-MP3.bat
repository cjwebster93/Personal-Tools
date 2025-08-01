@echo off
set DL_PARAMS=--no-check-certificates -x --audio-format mp3 -P ./audio
set /p YT_URL=Paste the YT link (right-click):

.\yt-dlp.exe %YT_URL% %DL_PARAMS%

explorer.exe .\audio