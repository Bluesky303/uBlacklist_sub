@echo off
setlocal enabledelayedexpansion

set "FILE=%~dp0..\myblacklist.txt"
if not exist "%FILE%" type nul > "%FILE%"

:loop
if "%~1"=="" goto :end

findstr /x /l /c:"%~1" "%FILE%" >nul 2>&1
if !errorlevel! equ 0 (
    echo [SKIP] %~1
) else (
    echo %~1>> "%FILE%"
    echo [ADD]  %~1
)

shift
goto :loop

:end
echo.
sort /unique "%FILE%" /o "%FILE%"
echo [OK] Done
type "%FILE%"
