@ECHO OFF
:: Store common environment variables to make sure that homemaker works

SET "BATCHDIR=%~dp0"

:: Windows NT added this command yet somehow messed up quoting. If DOTFILESDIR ends with a slash
:: (which it always does) then the environment variable will contain a double quote at the end.
::SETX HOME "%USERPROFILE%"
::SETX DOTFILESPATH "%BATCHDIR%"

:: REG ADD has similar problems with quoting, so let Powershell translate our needs
powershell -NoProfile -Command Set-ItemProperty -Path HKCU:\Environment -Name HOME         -Value '%USERPROFILE%' -Force
powershell -NoProfile -Command Set-ItemProperty -Path HKCU:\Environment -Name DOTFILESPATH -Value '%BATCHDIR%' -Force

:: Now set the environment variables in the current context so next powershell invocation can see them
SET "HOME=%USERPROFILE%"
set "DOTFILESPATH=%BATCHDIR%"

:: Initialize bin folder, check if homedir exists. If not, on Windows 10 we try to download it.
IF NOT EXIST "%USERPROFILE%\bin\" MKDIR "%USERPROFILE%\bin"
IF NOT EXIST "%USERPROFILE%\bin\homemaker.exe" CALL :downloadhomemaker

:: Install chocolatey
powershell -NoProfile -ExecutionPolicy Bypass -File "%BATCHDIR%\win-choco-install.ps1"

:: Make sure chocolatey is added to PATH in current environment
SET "PATH=%PATH%;C:\ProgramData\chocolatey\bin"

:: Now run the homemaker invocation
powershell -ExecutionPolicy RemoteSigned -File "%BATCHDIR%\win-homemaker.ps1"

GOTO :end


:downloadhomemaker
SET "STARTDIR=%CD%"
CD "%USERPROFILE%\bin\" 

ECHO Downloading homemaker to %CD%

:: Assumes we are on Windows 10, as these commands have been added to the System32 folder in 2017
curl --tlsv1.2 https://foosoft.net/projects/homemaker/dl/homemaker_windows_amd64.tar.gz --output homemaker_windows_amd64.tar.gz
tar -xz -f homemaker_windows_amd64.tar.gz
MOVE "homemaker_windows_amd64\homemaker.exe" homemaker.exe
RMDIR "homemaker_windows_amd64\"
IF EXIST "%USERPROFILE%\bin\homemaker.exe" ERASE homemaker_windows_amd64.tar.gz

CD "%STARTDIR%"

GOTO:eof


:end