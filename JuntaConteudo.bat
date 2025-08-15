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