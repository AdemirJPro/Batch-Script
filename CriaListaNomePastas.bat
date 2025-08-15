:: Cria uma lista com os nomes das pastas do local.

@echo off
setlocal

for /f "delims=" %%a in ('dir /b /ad "%~dp0\*.*"') do (
  echo %%a >> ListaNomesPastas.txt
  set %%a=+1
)


endlocal
