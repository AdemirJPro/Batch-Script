:: Cria uma lista o nome de todos os arquivos onde o bat está.

@echo off
setlocal

for /f "delims=" %%a in ('dir /b "%~dp0\*.*"') do (
  echo %%a >> ListaNomesArquivos.txt
)


endlocal
