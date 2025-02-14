@echo off
setlocal enabledelayedexpansion

:: Check if a parameter is given, otherwise use default
if "%~1"=="" (
    set LUA_DIR=lua-5.4.6
    echo [INFO] No Lua directory specified. Using default: %LUA_DIR%
    echo [INFO] You can specify a different Lua directory as a parameter, e.g.:
    echo        run_all.bat lua-5.4.7
) else (
    set LUA_DIR=%~1
    echo [INFO] Using specified Lua directory: %LUA_DIR%
)

echo ==================================================
echo Starting Lua Bytecode Build Process...
echo ==================================================

:: 1️⃣ Check if initScript.lua exists
if not exist "initScript.lua" (
    echo [ERROR] initScript.lua not found!
    echo Please make sure the Lua source file is present in the directory.
    exit /b 1
)

:: 2️⃣ Compile Lua Interpreter and Compiler (lua.exe & luac.exe)
echo [INFO] Compiling Lua interpreter and bytecode compiler...
call compile_lua.bat %LUA_DIR%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to compile Lua interpreter and compiler!
    exit /b 1
)

:: 3️⃣ Compile initScript.lua to Lua bytecode (initScript.luac)
echo [INFO] Compiling Lua script to bytecode...
call compile_luac.bat %LUA_DIR%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Lua bytecode compilation failed!
    exit /b 1
)

:: 4️⃣ Convert Lua bytecode to C++ header (luaEmbedded.h)
echo [INFO] Converting Lua bytecode to C++ header...
cscript //nologo convert_luac.vbs
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Lua bytecode conversion failed!
    exit /b 1
)

echo ==================================================
echo [SUCCESS] Lua bytecode build process completed successfully!
echo Output files:
echo - initScript.luac (Compiled Lua bytecode)
echo - luaEmbedded.h (C++ header with Lua bytecode ^& source)
echo ==================================================
exit /b 0
