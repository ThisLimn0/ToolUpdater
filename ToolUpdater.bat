@ECHO OFF & SETLOCAL EnableDelayedExpansion & TITLE ToolUpdater
IF EXIST "%temp%\count" DEL /F /Q "%temp%\count"

SET "TOOL=yt-dlp.exe" ::: Binary to look for; must support --version and -U
SET "UPDATE=true" ::: When true, update every binary.

ECHO.Updating !TOOL! system-wide.
FOR %%I in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
   IF EXIST "%%I:\" (
       ECHO.
       <NUL SET /p "=Scanning [%%I:\] please wait."
       SETLOCAL
       ::: Change to the correct directory
       CD /d %%I:\
       ::: Count the files
       <NUL SET /p "=."
       DIR /b !TOOL! /s 2>nul | find "" /v /c > !temp!\count
       SET /p _CNT=<!temp!\count
       ::: Cleanup
       DEL /F /Q "!temp!\count"
       <NUL SET /p "=."
       IF !_CNT! GTR 0 (
          ::: Output the number of files
          ECHO. Files found: !_CNT!
          ::: List the files
          FOR /F "usebackq tokens=*" %%F IN (`DIR /b !TOOL! /s`) DO (
             SET "VERO="
             FOR /F "usebackq tokens=*" %%G IN (`CALL "%%F" --version`) DO (
                SET "VERO=%%G"
             )
             ECHO.   --^> %%F [!VERO!]
             IF /I "!UPDATE!"=="true" (
                CALL "%%F" -U >NUL
                FOR /F "usebackq tokens=*" %%G IN (`CALL "%%F" --version`) DO (
                   SET "VER=%%G"
                )
                IF NOT "!VERO!" == "!VER!" (
                   ECHO.     X Updated to [!VER!]
                ) ELSE (
                   ECHO.       No Update available.
                )
             )
          )
       ) ELSE (
          ECHO. No files found.
       )
       ENDLOCAL
   )
)
ECHO.
ECHO.Press [Any Key] to exit.
PAUSE >NUL
EXIT