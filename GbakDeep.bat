:: Esse scprit é para a ferramenta GBak do Firebird,
:: funcionando para qualquer versão, mas automaticamente reconhecendo as versões 2.5, 4.0 e 5.0.
:: Com menu interativo, compactação de descompactação pelo WinRAR e logs.

:reset
set "GBAK_PATH25=C:\Program Files\Firebird\Firebird_2_5\bin\gbak.exe"
set "GBAK_PATH40=C:\Program Files\Firebird\Firebird_4_0\gbak.exe"
set "GBAK_PATH50=C:\Program Files\Firebird\Firebird_5_0\gbak.exe"
set DB_USER=SYSDBA
set DB_PASS=masterkey
set diretorio=%~dp0
set LOG_FILE=%diretorio%GbakAdemirLog.txt
set modo_auto=0

set agora=menu
goto configuracoes

:inicio
:: Verificar qual vers�o existe
if exist "%GBAK_PATH50%" (
    set "GBAK_PATH=%GBAK_PATH50%"
	set versaoFirebird="5.0"
) else if exist "%GBAK_PATH40%" (
    set "GBAK_PATH=%GBAK_PATH40%"
	set versaoFirebird="4.0"
) else if exist "%GBAK_PATH25%" (
    set "GBAK_PATH=%GBAK_PATH25%"
	set versaoFirebird="2.5"
) else (
    echo Nenhuma vers�o do GBAK foi encontrada.
    exit /b 1
	pause
)
goto hora

:menu
set agora=menu
cls
echo Caminho atual: %diretorio%
echo Data e hora: %DataHora%
echo Modo: %modo_auto_desc%
echo Versao Firebird Atual: %versaoFirebird%
echo Bem vindo!
echo.

echo Escolha o que deseja fazer:
echo.
echo [ 1 ] - Realizar um backup - de FDB para FBK para RAR.
echo [ 2 ] - Restaurar fbk - de RAR para FBK para FDB.
echo [ D ] - Mudar diret�rio.
echo [ C ] - Cancelar e sair.
echo [ R ] - Relat�rio.
echo [ M ] - Alternar modo (Atual: %modo_auto_desc%)
echo [ G ] - Mudar versao Firebird (Atual: %versaoFirebird%)

echo.
echo OBSERVA��O: A op��o 2 s� pode ser feita como ADMINISTRADOR.
echo.
set menu=x
set /p menu="Digite 1, 2, c, d, r ou m: "

:: Tratamentos
if /i '%menu%'=='C' set menu=c
if /i '%menu%'=='D' set menu=d
if /i '%menu%'=='R' set menu=r
if /i '%menu%'=='M' set menu=m
if /i '%menu%'=='G' set menu=g

:: Escolhas:
if %menu% == 1 (
    goto realizarBackup
) else if %menu% == 2 (
    goto checkModAdm
) else if %menu% == c (
    call :log "Script finalizado pelo usu�rio"
    echo saindo...
    timeout /T 1 >nul
    exit
) else if %menu% == r (
    goto relatorio
) else if %menu% == d (
    goto diretorio
) else if %menu% == m (
    goto alternar_modo
) else if %menu% == g (
    goto mudar_Firebird
)else (
    color 4F
    echo.
    echo Op��o inv�lida. Digite apenas o n�mero da op��o.
    timeout /T 2 >nul
    color 70
    goto inicio
)
pause

:mudar_Firebird
set agora=mudar_Firebird
cls
echo Data e hora: %DataHora%
echo Caminho Atual do Gbak: %GBAK_PATH%
echo Versao Atual do Firebird: %versaoFirebird%
echo Bem vindo!
echo.

echo Escolha o que deseja fazer:
echo.
echo [ 2 ] - Firebird 2.5
echo [ 4 ] - Firebird 4.0
echo [ 5 ] - Firebird 5.0

echo.
set menu=x
set /p menu="Digite 2, 4 ou 5: "

:: Escolhas:
if %menu% == 2 (
	set versaoFirebird="2.5"
	set GBAK_PATH=%GBAK_PATH25%
    goto menu
) else if %menu% == 4 (
	set versaoFirebird="4.0"
	set GBAK_PATH=%GBAK_PATH40%
    goto menu
) else if %menu% == 5 (
	set versaoFirebird="5.0"
	set GBAK_PATH=%GBAK_PATH50%
    goto menu
)else (
    color 4F
    echo.
    echo Op��o inv�lida. Digite apenas o n�mero da op��o.
    timeout /T 2 >nul
    color 70
    goto mudar_Firebird
)
pause

:alternar_modo
if %modo_auto% equ 0 (
    set modo_auto=1
    set modo_auto_desc=AUTOM�TICO
) else (
    set modo_auto=0
    set modo_auto_desc=INTERATIVO
)
call :log "Modo alterado para %modo_auto_desc%"
goto inicio

:realizarBackup
cls
echo Caminho: %diretorio%
echo.
echo Arquivos FDB encontrados:
echo.
set count=0
for %%a in (*.fdb) do (
    set /a count+=1
    set "file[!count!]=%%a"
    echo  [!count!] - %%a
)
echo.
if %count%==0 (
    cls
    color 60
    echo.
    echo  Nenhum arquivo FDB encontrado.
    call :log "Nenhum FDB encontrado para backup"
    echo.
    goto voltarMenu
)
set opcaoFDB=x
set /p opcaoFDB="Escolha o n�mero do arquivo para realizar o backup (ou 'V' para voltar): "
if "%opcaoFDB%"=="V" set opcaoFDB=v
if /i "%opcaoFDB%"=="v" (
    echo Voltando...
    goto inicio
)
for /l %%i in (1,1,%count%) do (
    if /i "%opcaoFDB%"=="%%i" (
        cls
        set NomeFdb=!file[%%i]!
        call :log "Iniciando backup do arquivo: !file[%%i]!"
        echo Arquivo "!file[%%i]!" escolhido para o backup!
        timeout /T 1 >nul
        goto avisos
    )
)
cls
color 4F
echo.
echo Op��o inv�lida.
echo ...
call :log "Op��o inv�lida selecionada: %opcaoFDB%"
timeout /T 2 >nul
color 70
goto realizarBackup

:avisos
cls
echo.
echo AVISO: Esse backup N�O deve ser realizado com o banco em uso.
echo.
goto fazBackup

:fazBackup
set agora=VoltaFazBackup
goto hora

:VoltaFazBackup
for %%a in (%NomeFdb%) do (
    set ApenasNome=%%~na
)
call :log "Criando c�pia de seguran�a: %ApenasNome%B.fdb"
copy %diretorio%\%ApenasNome%.fdb %ApenasNome%B.fdb
if errorlevel 1 (
    call :log "ERRO ao copiar arquivo FDB"
    color 4F
    echo ERRO ao criar c�pia do banco
    timeout /T 2 >nul
    goto voltarMenu
)

cls
echo.
echo C�pia realizada, vamos fazer o backup...
timeout /T 1 >nul
cls
echo Aguarde... estamos criando o fbk.
echo.
call :log "Executando gbak: %GBAK_PATH% -b -g -v -user %DB_USER% -password %DB_PASS% %ApenasNome%B.fdb %ApenasNome%B.fbk"
"%GBAK_PATH%" -b -g -v -user %DB_USER% -password %DB_PASS% %ApenasNome%B.fdb %ApenasNome%B.fbk
set errorGabkFdbFbk=%errorlevel%
if %errorlevel% == 0 (
    echo finalizando...
    color 20
    echo Backup realizado com sucesso
    call :log "Backup realizado com sucesso para %ApenasNome%B.fbk"
    timeout /T 1 >nul
    color 70
    ren %diretorio%\%ApenasNome%B.fbk %ApenasNome%-%DataHora%.fbk
    del %ApenasNome%B.fdb
    call :log "C�pia tempor�ria removida: %ApenasNome%B.fdb"
    echo ...c�pia removida.
    timeout /T 2 >nul
    goto compactaFbkRAR
) else (
    color 4F
    call :log "ERRO no backup (gbak): c�digo %errorGabkFdbFbk%"
    echo ERRO ao realizar o backup.
    echo.
    goto voltarMenu
)
echo.

:compactaFbkRAR
call :log "Compactando arquivo: %ApenasNome%-%DataHora%.fbk"
echo Aguarde... estamos compactando o arquivo fbk.
"C:\Program Files\WinRAR\WinRAR.exe" a "%ApenasNome%-fbk-%DataHora%.rar" "%ApenasNome%-%DataHora%.fbk"
set errorCompactaRar=%errorlevel%
set nomeRar=%ApenasNome%-fbk-%DataHora%.rar

if %errorlevel% == 0 (
    color 20
    call :log "Arquivo compactado: %nomeRar%"
    echo Arquivo "%ApenasNome%" compactado com sucesso!
    echo.
    timeout /T 2 >nul
    color 70
) else (
    color 4F
    call :log "ERRO na compacta��o: c�digo %errorCompactaRar%"
    echo ERRO ao compactar arquivo!
    timeout /T 2 >nul
    color 70
)

if %modo_auto% equ 1 (
    call :log "Modo AUTOM�TICO: Excluindo FBK original"
    del "%ApenasNome%-%DataHora%.fbk"
    if errorlevel 1 (
        call :log "ERRO ao excluir FBK"
    ) else (
        call :log "FBK exclu�do com sucesso"
    )
    goto voltarMenu
)

:compactarFBK
cls
echo.
echo Deseja excluir o arquivo FBK original?
echo Arquivo: %ApenasNome%-%DataHora%.fbk
echo.
set DelFbk=x
set /p DelFbk="Digite S (sim) ou N (n�o): "
if /i '%DelFbk%'=='S' set DelFbk=s
if /i '%DelFbk%'=='Sim' set DelFbk=s
if /i '%DelFbk%'=='SIM' set DelFbk=s

if /i '%DelFbk%'=='N' set DelFbk=n
if /i '%DelFbk%'=='Nao' set DelFbk=n
if /i '%DelFbk%'=='NAO' set DelFbk=n

if "%DelFbk%"=="s" (
    call :log "Usu�rio escolheu EXCLUIR FBK"
    del "%ApenasNome%-%DataHora%.fbk"
    set errorDelFbk=%errorlevel%
    if %errorlevel% == 0 (
        call :log "FBK exclu�do com sucesso"
        echo ...arquivo fbk exclu�do.
    ) else (
        call :log "ERRO ao excluir FBK: c�digo %errorDelFbk%"
        echo ERRO ao excluir arquivo FBK
    )
    echo.
    timeout /T 1 >nul
) else if "%DelFbk%"=="n" (
    call :log "Usu�rio escolheu MANTER FBK"
    color 60
    cls
    echo.
    echo Arquivo FBK mantido: %ApenasNome%-%DataHora%.fbk
    echo.
    timeout /T 2 >nul
    color 70
) else (
    echo Op��o inv�lida.
    echo ...
    goto compactarFBK
)
goto voltarMenu

:voltarMenu
echo.
echo Deseja voltar ao menu principal?
set vMenu=x
set /p vMenu="Digite s (sim) ou n (n�o/encerrar): "
if /i '%vMenu%'=='S' set vMenu=s
if /i '%vMenu%'=='Sim' set vMenu=s
if /i '%vMenu%'=='SIM' set vMenu=s

if /i '%vMenu%'=='N' set vMenu=n
if /i '%vMenu%'=='Nao' set vMenu=n
if /i '%vMenu%'=='NAO' set vMenu=n

if "%vMenu%"=="s" (
    echo voltando ao menu...
    color 70
    set agora=menu
    goto hora
) else if "%vMenu%"=="n" (
    call :log "Script finalizado pelo usu�rio"
    echo encerrando...
    timeout /T 1 >nul
    exit
) else (
    color 4F
    cls
    echo.
    echo Op��o inv�lida.
    echo ...
    timeout /T 2 >nul
    color 70
    goto voltarMenu
)

::----------------------------------------------------------------------

:checkModAdm
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% == 0 (
    goto descompactarRAR
) else (
    cls
    color 4F
    echo.
    echo ERRO: Restaurar um FBK requer privil�gios de administrador.
    call :log "Tentativa de restaura��o sem privil�gios de administrador"
    echo Por favor, execute novamente como administrador.
    pause >nul
    exit /b 1
)

:descompactarRAR
cls
echo.
echo  Arquivos RAR encontrados:
echo.
set count=0
for %%a in (*.rar) do (
    set /a count+=1
    set "file[!count!]=%%a"
    echo  [!count!] - %%a
)
echo.
if %count%==0 (
    color 60
    cls
    echo.
    echo  Nenhum arquivo RAR encontrado.
    call :log "Nenhum RAR encontrado para restaura��o"
    echo.
    echo ...vamos procurar por arquivos fbk:
    timeout 2 >nul
    goto procurarFBK 
) else if %count%==1 (
    set opcaoRAR=1
    goto pulaOpcaoRAR
)
set opcaoRAR=x
set /p opcaoRAR="Escolha o n�mero do arquivo para descompactar (ou 'v' para voltar): "
:pulaOpcaoRAR
if "%opcaoRAR%"=="V" set opcaoRAR=v
if /i "%opcaoRAR%"=="v" (
    echo Voltando...
    timeout /T 1 >nul
    goto menu
)
for /l %%i in (1,1,%count%) do (
    if /i "%opcaoRAR%"=="%%i" (
        cls
        set NomeRar=!file[%%i]!
        call :log "Descompactando arquivo: !file[%%i]!"
        "C:\Program Files\WinRAR\UnRAR.exe" x -y "!file[%%i]!"
        if errorlevel 1 (
            color 4F
            call :log "ERRO na descompacta��o: c�digo %errorlevel%"
            echo ERRO ao descompactar arquivo!
            timeout /T 2 >nul
            color 70
            goto descompactarRAR
        )
        color 20
        call :log "Arquivo descompactado com sucesso"
        echo Arquivo "!file[%%i]!" descompactado com sucesso!
        set NomeFbk=x
        set NomeFbk=!file[%%i]!
        echo.
        goto procurarFBK
    )
)
color 4F
echo Op��o inv�lida.
timeout /T 1 >nul
color 70
goto descompactarRAR

:procurarFBK
cls
echo.
echo  Arquivos FBK encontrados:
echo.
set count=0
for %%a in (*.fbk) do (
    set /a count+=1
    set "file[!count!]=%%a"
    echo  [!count!] - %%a
)
echo.
if %count%==0 (
    cls
    color 60
    echo.
    echo Nenhum arquivo FBK encontrado.
    call :log "Nenhum FBK encontrado para restaura��o"
    echo ...
    timeout /T 2 >nul
    color 70
    goto voltarMenu
) else if %count%==1 (
    set opcaoFBK=1
    goto pulaOpcaoFBK
)
echo.
set opcaoFBK=x
set /p opcaoFBK="Escolha o n�mero do arquivo para restaurar (ou 'C' para cancelar): "
:pulaOpcaoFBK
if /i "%opcaoFBK%"=="C" (
    call :log "Restaura��o cancelada pelo usu�rio"
    echo Cancelando...
    exit /b
)
for /l %%i in (1,1,%count%) do (
    if /i "%opcaoFBK%"=="%%i" (
        cls
        set NomeFbk=!file[%%i]!
        call :log "Iniciando restaura��o do arquivo: !file[%%i]!"
        echo Arquivo "!NomeFbk!" escolhido para restaurar!
        timeout /T 1 >nul
        goto finalFBK
    )
)
echo Op��o inv�lida.
echo ...
goto procurarFBK

:finalFBK
for %%a in (%NomeFbk%) do (
    set ApenasNomeFBK=%%~na
)
cls
echo.
echo Aguarde... estamos criando o fdb.
timeout /T 1 >nul
echo.
call :log "Executando gbak restore: %GBAK_PATH% -c -v -user %DB_USER% -password %DB_PASS% %ApenasNomeFBK%.fbk %ApenasNomeFBK%.fdb"
"%GBAK_PATH%" -c -v -user %DB_USER% -password %DB_PASS% %ApenasNomeFBK%.fbk %ApenasNomeFBK%.fdb
set errorGbakFbkFdb=%errorlevel%
if %errorlevel% == 0 (
    color 20
    cls
    echo.
    call :log "Restaura��o conclu�da com sucesso"
    echo Restaura��o realizada com sucesso.
    echo.
    color 70
) else (
    color 4F
    call :log "ERRO na restaura��o: c�digo %errorGbakFbkFdb%"
    echo Erro ao realizar a restaura��o.
    echo.
)

if %modo_auto% equ 1 (
    call :log "Modo AUTOM�TICO: Excluindo FBK original"
    del "%ApenasNomeFBK%.fbk"
    if errorlevel 1 (
        call :log "ERRO ao excluir FBK"
    ) else (
        call :log "FBK exclu�do com sucesso"
    )
    goto voltarMenu
)

:excluirFbk
cls
echo.
echo Deseja excluir o arquivo FBK original?
echo Arquivo: %ApenasNomeFBK%.fbk
echo.
set DelFbk=x
set /p DelFbk="Digite S (sim) ou N (n�o): "
if /i '%DelFbk%'=='S' set DelFbk=s
if /i '%DelFbk%'=='Sim' set DelFbk=s
if /i '%DelFbk%'=='SIM' set DelFbk=s

if /i '%DelFbk%'=='N' set DelFbk=n
if /i '%DelFbk%'=='Nao' set DelFbk=n
if /i '%DelFbk%'=='NAO' set DelFbk=n

if "%DelFbk%"=="s" (
    call :log "Usu�rio escolheu EXCLUIR FBK"
    del "%ApenasNomeFBK%.fbk"
    if errorlevel 1 (
        call :log "ERRO ao excluir FBK"
        echo ERRO ao excluir arquivo FBK
    ) else (
        call :log "FBK exclu�do com sucesso"
        echo Arquivo FBK exclu�do.
    )
    goto voltarMenu
) else if "%DelFbk%"=="n" (
    call :log "Usu�rio escolheu MANTER FBK"
    color 60
    cls
    echo.
    echo Arquivo FBK mantido: %ApenasNomeFBK%.fbk
    echo.
    timeout /T 1 >nul
    goto voltarMenu
) else (
    echo Op��o inv�lida.
    echo ...
    goto excluirFbk
)

::---------------------------------------------------
exit

:relatorio
cls
echo.
echo --------------------------------------------------------------------
echo Realizar um backup:-------------------------------------------------
echo Nome do FDB original: %NomeFdb%
echo Nome do RAR criado: %nomeRar%
echo.
echo Error Levels:-------------------------------------------------------
echo Errorlevel ao deletar FBK (DelFbk): %errorDelFbk%
echo Errorlevel na compacta��o do FBK: %errorCompactaRar%
echo Errorlevel do Gbak Fdb-Fbk: %errorGabkFdbFbk%
echo --------------------------------------------------------------------
echo Restaurar fbk:------------------------------------------------------
echo Nome do FBK restaurado: %NomeFbk%
echo Errorlevel do Gbak Fbk-Fdb: %errorGbakFbkFdb%
echo --------------------------------------------------------------------
call :log "Relat�rio gerado pelo usu�rio"
pause >nul
goto hora

:hora
set hora=%TIME:~0,2%
if "%hora:~0,1%" == " " set hora=0%hora:~1,1%
set min=%TIME:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set seg=%TIME:~6,2%
if "%seg:~0,1%" == " " set seg=0%seg:~1,1%
set year=%DATE:~-4%
set mes=%DATE:~3,2%
if "%mes:~0,1%" == " " set mes=0%mes:~1,1%
set dia=%DATE:~0,2%
if "%dia:~0,1%" == " " set dia=0%dia:~1,1%
set DataHora=%year%-%mes%-%dia%-%hora%h%min%m%seg%s
goto %agora%

:diretorio
cls
echo.
echo Abaixo, digite o caminho inteiro do diret�rio:
set /p diretorio="Caminho: "
cd /d "%diretorio%" 2>nul
if errorlevel 1 (
    color 4F
    echo.
    echo Diret�rio n�o encontrado: %diretorio%
    call :log "Tentativa de acesso a diret�rio inv�lido: %diretorio%"
    echo.
    timeout /t 2 >nul
    color 70
    goto diretorio
)
set diretorio=%cd%
call :log "Diret�rio alterado para: %diretorio%"
echo.
echo Diret�rio alterado para: %diretorio%
timeout /t 2 >nul
goto inicio

:configuracoes
MODE CON: COLS=100 LINES=20
@echo off
chcp 1252
setlocal enabledelayedexpansion
color 70
cd /d "%diretorio%" 2>nul
if %modo_auto% equ 0 (
    set modo_auto_desc=INTERATIVO
) else (
    set modo_auto_desc=AUTOM�TICO
)
echo. > "%LOG_FILE%"
call :log "Script iniciado"
call :log "Diret�rio inicial: %diretorio%"
call :log "Modo inicial: %modo_auto_desc%"
cls
goto inicio

:log
set msg=%*
echo [%DataHora%] - %msg% >> "%LOG_FILE%"
exit /b