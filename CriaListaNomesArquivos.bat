@echo off
setlocal

for /f "delims=" %%a in ('dir /b "%~dp0\*.*"') do (
  echo %%a >> ListaNomesArquivos.txt
)

endlocal