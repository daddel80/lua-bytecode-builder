Option Explicit

' -------------------------------------------------------------------------------------
' Script: convert_luac.vbs
' Description:
'   Reads a compiled Lua bytecode file (initScript.luac) and the original Lua source
'   (initScript.lua), then generates a C++ header file (luaEmbedded.h).
'
' Expected input:
'   - initScript.luac (compiled Lua bytecode)
'   - initScript.lua  (original Lua source)
'
' Output:
'   - luaEmbedded.h   (C++ header file with both bytecode and source)
' -------------------------------------------------------------------------------------

Dim stream, byteArray, i, hexStr, outStr, fso, outFile
Dim sourceStream, sourceStr, sourceArray, line

' --- Read Lua bytecode file ---
Set stream = CreateObject("ADODB.Stream")
stream.Type = 1 ' Binary mode
stream.Open
stream.LoadFromFile "initScript.luac"
byteArray = stream.Read
stream.Close

' --- Read Lua source file ---
Set sourceStream = CreateObject("ADODB.Stream")
sourceStream.Type = 2 ' Text mode
sourceStream.Charset = "UTF-8"
sourceStream.Open
sourceStream.LoadFromFile "initScript.lua"
sourceStr = sourceStream.ReadText
sourceStream.Close

' --- Start generating the C++ header file ---
outStr = "#ifndef LUA_EMBEDDED_H" & vbCrLf & _
         "#define LUA_EMBEDDED_H" & vbCrLf & vbCrLf & _
         "// ==========================================================================================" & vbCrLf & _
         "// IMPORTANT: Do not delete the code below!" & vbCrLf & _
         "// The following bytecode is generated from the Lua source code and is used at runtime." & vbCrLf & _
         "// The original Lua source is provided below for documentation and fallback purposes." & vbCrLf & _
         "// ==========================================================================================" & vbCrLf & vbCrLf & _
         "// ---------- Precompiled Lua Bytecode (Used at Runtime) ----------" & vbCrLf & _
         "static const unsigned char luaBytecode[] = {" & vbCrLf

' --- Store bytecode as a C++ array ---
For i = 1 To LenB(byteArray)
    hexStr = Right("0" & Hex(AscB(MidB(byteArray, i, 1))), 2)
    outStr = outStr & "0x" & hexStr & ", "
    If (i Mod 16) = 0 Then outStr = outStr & vbCrLf
Next
outStr = outStr & "};" & vbCrLf & _
         "static const size_t luaBytecodeSize = sizeof(luaBytecode);" & vbCrLf & vbCrLf

' --- Store Lua source code as a C++ string ---
outStr = outStr & "// ---------- Original Lua Source Code (For Documentation/Fallback) ----------" & vbCrLf & _
         "static const char luaSourceCode[] = {" & vbCrLf

' --- Append Lua source code as a valid C++ array ---
sourceArray = Split(sourceStr, vbCrLf)
For i = 0 To UBound(sourceArray)
    line = sourceArray(i)
    outStr = outStr & """ " & Replace(line, """", "\""") & "\n""" & vbCrLf
Next

outStr = outStr & "};" & vbCrLf & _
         "static const size_t luaSourceSize = sizeof(luaSourceCode);" & vbCrLf & vbCrLf & _
         "#endif // LUA_EMBEDDED_H" & vbCrLf

' --- Save the header file ---
Set fso = CreateObject("Scripting.FileSystemObject")
Set outFile = fso.CreateTextFile("luaEmbedded.h", True)
outFile.Write outStr
outFile.Close

WScript.Echo "C++ header file has been saved as luaEmbedded.h!"
