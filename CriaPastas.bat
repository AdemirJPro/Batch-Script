setlocal EnableDelayedExpansion

:: Defina o nome do arquivo
set "leitor=ListaNomesPasta.txt"

:: Loop para ler cada linha do arquivo
for /f %%a in ('type "%leitor%"') do (
mkdir %%a
)

:: Fim do script
endlocal