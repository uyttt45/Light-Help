@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check if the script is running as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator.
    pause
    exit /b
)

:: Prompt the user to enter the path of the folder or drive they want to share
echo Please enter the path of the folder or drive you want to share (e.g., C:\Users\YourUser\Documents or D:\):
set /p folderPath=Path: 

:: Check if the specified folder or drive exists
if not exist "%folderPath%" (
    echo Error: The specified path does not exist: %folderPath%
    pause
    exit /b
)

:: Enable SMB protocol (SMB1 and SMB2 for compatibility)
echo Enabling SMB protocol...
dism /online /enable-feature /featurename:FS-SMB1 /all /norestart
dism /online /enable-feature /featurename:FS-SMB2 /all /norestart
net stop "lanmanserver"
net start "lanmanserver"

:: Prompt the user to enter the name for the shared folder
echo Please enter a name for the shared folder (e.g., "Shared_Folder"):
set /p shareName=Share Name: 

:: Create the network share with the specified folder path and name
echo Sharing the folder...
net share "%shareName%"="%folderPath%" /GRANT:everyone,FULL

:: Confirmation that the folder has been shared
echo Finished! SMB is enabled, and the folder "%folderPath%" is now shared as "%shareName%".
pause
ENDLOCAL
