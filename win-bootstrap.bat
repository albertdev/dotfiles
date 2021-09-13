@ECHO OFF
:: Store common environment variables to make sure that homemaker works

SET "BATCHDIR=%~dp0"

:: Windows NT added this command yet somehow messed up quoting. If DOTFILESDIR ends with a slash
:: (which it always does) then the environment variable will contain a double quote at the end.
::SETX HOME "%USERPROFILE%"
::SETX DOTFILESPATH "%BATCHDIR%"

:: REG ADD has similar problems with quoting, so let Powershell translate our needs
powershell -Command Set-ItemProperty -Path HKCU:\Environment -Name HOME         -Value '%USERPROFILE%' -Force
powershell -Command Set-ItemProperty -Path HKCU:\Environment -Name DOTFILESPATH -Value '%BATCHDIR%' -Force

:: Now set the environment variables in the current context so next powershell invocation can see them
SET "HOME=%USERPROFILE%"
set "DOTFILESPATH=%BATCHDIR%"

:: Now run the homemaker invocation
powershell -ExecutionPolicy RemoteSigned -File "%BATCHDIR%\win-homemaker.ps1"
