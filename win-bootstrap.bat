@ECHO OFF
:: Store common environment variables to make sure that homemaker works

SET "BATCHDIR=%~dp0"

:: Encountered on a new PC: download dotfiles from github as a zip, extract them and now they were
:: all marked as untrusted because Windows stored that they're from the Internet in an alternate stream.
:: Powershell will treat scripts with this alternate stream as comming from a remote systen and hence
:: won't run without a valid digital signature.
:: This Powershell command will remove the alternate stream.
powershell -NoProfile -Command Get-ChildItem -Recurse -File '%BATCHDIR%' "|" Unblock-File

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
curl -L --tlsv1.2 https://github.com/FooSoft/homemaker/releases/download/21.12.14.0/homemaker_windows_amd64.zip --output homemaker_windows_amd64.zip
tar -x -f homemaker_windows_amd64.zip
::Seems the exe is now in the root folder of the zip file
::MOVE "homemaker_windows_amd64\homemaker.exe" homemaker.exe
::RMDIR "homemaker_windows_amd64\"
IF EXIST "%USERPROFILE%\bin\homemaker.exe" ERASE homemaker_windows_amd64.zip

CD "%STARTDIR%"

GOTO:eof


:end
