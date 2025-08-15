:: Crie o arquivo ListaNomesPastas.txt no mesmo diretório do bat e
:: dentro dele coloque uma lista de nomes de pastas linha por linha para criar.

@echo off
setlocal

set contador = 0
for /f "delims=" %%a in ('dir /b /ad "%~dp0\*.*"') do (
  echo %%a >> ListaNomesPastas.txt
  contador += 1
  
)


endlocal
