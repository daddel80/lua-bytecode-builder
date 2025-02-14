@echo off
setlocal enabledelayedexpansion

:: Use provided Lua directory or default
if "%~1"=="" (
    set LUA_DIR=lua-5.4.6
) else (
    set LUA_DIR=%~1
)

echo ==================================================
echo Initializing Visual Studio environment...
echo ==================================================
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to initialize Visual Studio environment.
    exit /b 1
)

cd /d "%~dp0\%LUA_DIR%\src"

:: Ensure build directory exists
if not exist build mkdir build

echo ==================================================
echo Compiling Lua Interpreter (lua.exe)...
echo ==================================================
cl /O2 /MD /D_CRT_SECURE_NO_WARNINGS /Fo"build\\" /Fe"lua.exe" ^
    lua.c lapi.c lauxlib.c lbaselib.c lcode.c lcorolib.c lctype.c ^
    ldblib.c ldebug.c ldo.c ldump.c lfunc.c lgc.c linit.c liolib.c ^
    llex.c lmathlib.c lmem.c loadlib.c lobject.c lopcodes.c loslib.c ^
    lparser.c lstate.c lstring.c lstrlib.c ltable.c ltablib.c ltm.c ^
    lundump.c lutf8lib.c lvm.c lzio.c

if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to compile lua.exe.
    exit /b 1
)

echo ==================================================
echo Compiling Lua Bytecode Compiler (luac.exe)...
echo ==================================================
cl /O2 /MD /D_CRT_SECURE_NO_WARNINGS /Fo"build\\" /Fe"luac.exe" ^
    luac.c lapi.c lauxlib.c lcode.c ldebug.c ldo.c ldump.c lfunc.c ^
    llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ^
    ltable.c ltm.c lundump.c lzio.c lgc.c lvm.c lctype.c lmathlib.c

if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to compile luac.exe.
    exit /b 1
)

echo ==================================================
echo Compilation completed successfully!
echo Lua and Luac are now available in %LUA_DIR%\src
echo ==================================================
endlocal
