:: Verifica se um número de entrada é primo.

	@echo off
	chcp 1252
	setlocal enabledelayedexpansion
	MODE CON: COLS=75 LINES=50
	color 07
	cls

:: Tela inicial:
:inicio
	echo.
	echo Digite um número positivo qualquer (ou 's' para sair):
	set "_entrada="
	set /p "_entrada="Entrada: ""

	if "!_entrada!"==" " (
	cls
	goto seErro
	)

	if !_entrada!==^, (
	cls
	goto seErro
	)
::	pause>nul
cls
::	echo Entrada: %_entrada%

	if '%_entrada%'=='s' exit

	set /a "_resto=%_entrada%%%2"
::	echo Resto: %_resto%
	
	set /a "_soma1=_entrada+0"
::	echo Soma: %_soma1%

	if '%_entrada%'=='%_soma1%' (
	::passa reto que está tudo certo
	echo.
	) else (
:seErro
		color 4F
		echo.
		echo Sua entrada "%_entrada%" é:
		echo INVÁLIDA. DIGITE APENAS NÚMEROS.
	goto final
	)

	if %_entrada%==0 (
		color 9F
		echo O número %_entrada% é:
		echo Viiishii... Zero é par??? Dizem que sim.
		echo.
		echo Se Primo:
		echo Resto da divisão de 0 por 0 = Fim do Mundo.
		echo Não é primo.
		goto final
	) else if %_resto%==1 (
		color 02
		echo O número %_entrada% é:
		echo Impar
	) else if %_resto%==0 (
		color 09
		echo O número %_entrada% é:
		echo Par
goto naoPrimoPar
	) else (
		::para valores negativos:
		color 02
		echo O número %_entrada% é:
		echo Impar
	)
	
:: Considerações para primos:
:: - Divisível apenas por 1 e por ele mesmo.
:: - 2 é o primeiro primo
:: - Apenas o número 2 é primo par
	:: Conferir se par != de 2 antes dos loops.
	:: Pular verificação dos pares na divisão

	if %_entrada% leq 1 goto naoPrimoMenor

	echo.
echo Se Primo:
	set /a cont=3
:loopPrimo
	if %cont% geq %_entrada% goto ePrimo
	set /a respDiv=%_entrada%%%cont%
	echo Resto da divisão de %_entrada% por %cont% = %respDiv%
	set /a raiz=%cont%*%cont%
	if %raiz% gtr %_entrada% (
	echo %cont%² é maior que %_entrada%, então...
	goto ePrimo
	)
	if %respDiv% equ 0 goto naoPrimo
	set /a cont+=2
goto loopPrimo
	
:ePrimo
	echo É primo.
goto final

:naoPrimo
	echo Não é Primo.
goto final

:naoPrimoPar
	echo.
	echo Se Primo:
	if %_entrada% equ 2 goto ePrimo
	echo Resto da divisão de %_entrada% por 2 = 0
goto naoPrimo

:naoPrimoMenor
	echo.
	echo Se Primo:
	echo O valor %_entrada% é menor que 2.
goto naoPrimo


	echo ?????????
:final
goto inicio

