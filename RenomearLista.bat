:: Renomei em massa o final no texto em uma lista em um arquivo TXT.
:: Está programado para pegar um nome, como "nome1" e transformar em "nome1.ini"
:: Mudei a variável "novoNome" para o desejado.

@echo off
setlocal EnableDelayedExpansion

:: Defina o nome do arquivo
set "leitor=lista.txt"
set "novoNome=.ini"

:: Loop para ler cada linha do arquivo
for /f %%a in ('type "%leitor%"') do (
    echo %%a%novoNome%>> NovaLista.txt
)
pause
:: Fim do script

endlocal


