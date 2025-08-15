@echo off
setlocal

set contador = 0
for /f "delims=" %%a in ('dir /b /ad "%~dp0\*.*"') do (
  echo %%a >> ListaNomesPastas.txt
  contador += 1
  
)

endlocal