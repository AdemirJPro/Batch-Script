:: Cria uma lista em ListaNomesPastas.txt com o nome de todas as pastas no local atual do bat.

@echo off
setlocal

set contador = 0
for /f "delims=" %%a in ('dir /b /ad "%~dp0\*.*"') do (
  echo %%a >> ListaNomesPastas.txt
  contador += 1
  
)


endlocal

