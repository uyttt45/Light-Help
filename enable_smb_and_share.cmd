@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check if the user is running as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator.
    pause
    exit /b
)

:: Prompt the user to input the folder or disk to share
echo Please enter the path of the folder or drive you want to share (e.g., C:\Users\YourUser\Documents or D:\):
set /p folderPath=Path: 

:: Check if the folder or drive exists
if not exist "%folderPath%" (
    echo Error: The specified path does not exist: %folderPath%
    pause
    exit /b
)

:: Enable SMB protocol (SMB1 and SMB2 for compatibility)
echo Enabling SMB protocol...
dism /online /enable-feature /featurename:SMB1Protocol /all /norestart
dism /online /enable-feature /featurename:SMB2Protocol /all /norestart
net stop "lanmanserver"
net start "lanmanserver"

:: Prompt user for the share name
echo Please enter a name for the shared folder (e.g., "Shared_Folder"):
set /p shareName=Share Name: 

:: Create the share
echo Sharing the folder...
net share %shareName%="%folderPath%" /GRANT:everyone,FULL

echo Finished! SMB is enabled and the folder "%folderPath%" is now shared as "%shareName%".
pause
ENDLOCAL
