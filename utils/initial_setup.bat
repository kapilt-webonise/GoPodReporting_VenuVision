@echo off
REM Exit immediately if a command fails
setlocal enabledelayedexpansion

REM Get the directory of this script (utils\)
set "SCRIPT_DIR=%~dp0"

REM Navigate to the project root (one level up)
cd /d "%SCRIPT_DIR%\.."

echo Creating virtual environment in %CD%\.venv ...
python -m venv .venv

IF ERRORLEVEL 1 (
    echo Failed to create virtual environment.
    exit /b 1
)

echo Virtual environment created.

echo Activating virtual environment...
call .venv\Scripts\activate.bat

echo Installing dependencies from requirements.txt...
pip install -r utils\requirements.txt

echo.
echo Setup complete.
echo To activate the environment later, run:
echo     .venv\Scripts\activate.bat
