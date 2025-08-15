@echo off
echo Digite o nome do arquivo executavel para ser fechado:
set /p "arquivo=Arquivo: "

taskkill /f /im "%arquivo%.exe"