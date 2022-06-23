echo off
cls
set AsmDir=c:\masm32\bin

%AsmDir%\ml.exe /c /coff /Cp main.asm

%AsmDir%\rc.exe rsrc.rc

%AsmDir%\link.exe /subsystem:windows main.obj rsrc.res

:ScriptEnd
pause