@echo off
setlocal enabledelayedexpansion

set "PYTHON_CMD="

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py
if defined PYTHON_CMD goto run

echo Python not found. Trying to install...
where winget >nul 2>&1
if errorlevel 1 (
    echo winget not available.
    goto download
)

winget install --id Python.Python.3 -e --silent --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo Failed to install Python with winget.
    goto download
)

echo Python installed. Verifying availability...

REM Update PATH from registry to include newly installed Python
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USERPATH=%%B"
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYSPATH=%%B"
if defined SYSPATH if defined USERPATH set "PATH=!SYSPATH!;!USERPATH!"

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py
if defined PYTHON_CMD goto run

echo No Python detected after installation.
echo Close this window, open a new one and run the script again.
goto download

:run
echo Using: %PYTHON_CMD%
%PYTHON_CMD% gd.py %*
goto :eof

:check_python
REM %1 = command to test (python or py)
"%~1" --version >nul 2>&1
if not errorlevel 1 (
    set "PYTHON_CMD=%~1"
)
goto :eof

:download
echo.
echo No Python detected after installation.
echo Opening Python download page...
start "" "https://www.python.org/downloads/"
echo.
echo Install Python from the downloaded installer and check the box
echo "Add python.exe to PATH" during installation.
echo Then run this script again.
pause
exit /b 1
