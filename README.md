# lua-bytecode-builder

## Overview  
This repository provides scripts and tools to compile the Lua runtime and generate Lua bytecode for embedding in the **MultiReplace** plugin (see [`notepadpp-multireplace`](https://github.com/your-org/notepadpp-multireplace)).  

By precompiling Lua scripts, this setup enhances execution speed and security by embedding the bytecode directly into the plugin, removing the need for external Lua script files.

## Features  
- **Lua Compilation**: Scripts to compile `lua.exe` and `luac.exe` for generating Lua bytecode.  
- **Automated Bytecode Generation**: Converts Lua scripts (`.lua`) into bytecode (`.luac`).  
- **C++ Integration**: Generates a `luaBytecode.h` file containing the compiled bytecode for direct embedding into MultiReplace.  
- **Cross-Platform Compatibility**: Works with Windows using Visual Studio 2022.

## Usage  
1. **Compile Lua and Luac**  
   ```sh
   ./compile_lua.bat
