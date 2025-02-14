@echo off
setlocal enabledelayedexpansion

:: Use provided Lua directory or default
if "%~1"=="" (
    set LUA_DIR=lua-5.4.6
) else (
    set LUA_DIR=%~1
)

echo ==================================================
echo Compiling Lua Script to Bytecode...
echo ==================================================

:: Set path to luac.exe
set LUAC=%LUA_DIR%\src\luac.exe

:: Check if luac.exe exists
if not exist "%LUAC%" (
    echo Error: %LUAC% not found!
    exit /b 1
)

:: Check if Lua script exists
if not exist "initScript.lua" (
    echo Error: initScript.lua not found!
    exit /b 1
)

:: Compile Lua script to bytecode
"%LUAC%" -o initScript.luac initScript.lua

:: Verify success
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to compile initScript.lua!
    exit /b 1
)

echo Compilation successful! Output: initScript.luac
exit /b 0
