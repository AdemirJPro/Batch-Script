@echo off
setlocal EnableDelayedExpansion

:: Defina o nome do arquivo
set "leitor=lista.txt"

:: Loop para ler cada linha do arquivo
for /f %%a in ('type "%leitor%"') do (
    echo %%a.ini>> NovaLista.txt
)
pause
:: Fim do script
endlocal