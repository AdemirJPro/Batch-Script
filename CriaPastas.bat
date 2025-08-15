:: Cria pastas a partir de uma lista em um arquivo ListaNomesPasta.txt no mesmo local.
:: Crie o arquivo ListaNomesPasta.txt e coloque cada nome em uma linha.

setlocal EnableDelayedExpansion

:: Defina o nome do arquivo
set "leitor=ListaNomesPasta.txt"

:: Loop para ler cada linha do arquivo
for /f %%a in ('type "%leitor%"') do (
mkdir %%a
)

:: Fim do script

endlocal
