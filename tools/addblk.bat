@echo off
setlocal enabledelayedexpansion

set "REPO=%~dp0.."
set "FILE=%REPO%\myblacklist.txt"

rem 先拉取远端最新代码
cd /d "%REPO%"
git pull

rem 如果文件不存在就创建一个空文件
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

echo.
rem 提交并推送到 GitHub
git add myblacklist.txt
git diff --cached --quiet
if !errorlevel! neq 0 (
    git commit -m "add blacklist"
    git push
    echo [OK] Pushed to GitHub
) else (
    echo [OK] No changes to push
)
