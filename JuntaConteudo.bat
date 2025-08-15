:: Junta o conteúdo dentre de arquivos de texto ou semelhentes,
:: como arquivos .js, .thml, .css e outros em apenas um arquivo chamado TudoJunto.txt.

@echo off
setlocal

for /f "delims=" %%a in ('dir /b "%~dp0\*.*"') do (
  echo Arquivo{%%a>>TudoJunto.txt
  echo.>>TudoJunto.txt
  type %%a >>TudoJunto.txt
  echo.>>TudoJunto.txt
  echo }>>TudoJunto.txt
  echo.>>TudoJunto.txt
)


endlocal
