:: Ao abrir o bat, digite o nome do executável que deseja finalizar e aperte Enter.
:: Se mais de um processo estiver aberto, todos irão fechar.

@echo off
echo Digite o nome do arquivo executavel para ser fechado:
set /p "arquivo=Arquivo: "


taskkill /f /im "%arquivo%.exe"
