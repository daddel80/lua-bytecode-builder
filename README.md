# lua-bytecode-builder

## Overview  
This repository provides scripts and tools to compile the Lua runtime and generate Lua bytecode for embedding in the **MultiReplace** plugin (see [`notepadpp-multireplace`](https://github.com/your-org/notepadpp-multireplace)).  

By precompiling Lua scripts, this setup enhances execution speed and security by embedding the bytecode directly into the plugin, removing the need for external Lua script files.

## Features  
- **Lua Compilation**: Scripts to compile `lua.exe` and `luac.exe` for generating Lua bytecode.  
- **Automated Bytecode Generation**: Converts Lua scripts (`.lua`) into bytecode (`.luac`).  
- **C++ Integration**: Generates a `luaEmbedded.h` file containing the compiled bytecode for direct embedding into MultiReplace.  
- **Cross-Platform Compatibility**: Works with Windows using Visual Studio 2022.

## Usage  
### 1. Compile Lua and Luac  
Run the following command to compile the Lua interpreter and bytecode compiler:  
```sh
./compile_lua.bat
```

### 2. Compile Lua script to bytecode  
Convert the `initScript.lua` file into Lua bytecode:  
```sh
./compile_luac.bat
```

### 3. Generate C++ Header with Lua Bytecode  
Convert the compiled bytecode into a C++ header file:  
```sh
cscript //nologo convert_luac.vbs
```

### 4. Run Everything at Once  
Alternatively, execute the full build process in one step:  
```sh
./run_all.bat
```

## Configuration  
The Lua directory can be set as a parameter when running `run_all.bat`. If no path is specified, the default `lua-5.4.6` directory is used.  

Example usage:  
```sh
./run_all.bat lua-5.4.6
```

## Output Files  
- `initScript.luac` → Compiled Lua bytecode  
- `luaEmbedded.h` → C++ header containing bytecode and source  
