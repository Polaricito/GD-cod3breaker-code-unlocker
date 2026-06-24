@echo off
setlocal enabledelayedexpansion

set "PYTHON_CMD="

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py
if defined PYTHON_CMD goto run

echo Python no encontrado. Intentando instalar...
where winget >nul 2>&1
if errorlevel 1 (
    echo winget no esta disponible.
    goto download
)

winget install --id Python.Python.3 -e --silent --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo La instalacion con winget fallo.
    goto download
)

echo Python instalado. Verificando disponibilidad...

REM Refrescar PATH de la sesion actual desde el registro
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USERPATH=%%B"
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYSPATH=%%B"
if defined SYSPATH if defined USERPATH set "PATH=!SYSPATH!;!USERPATH!"

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py
if defined PYTHON_CMD goto run

echo No se pudo detectar Python despues de instalarlo.
echo Cierra esta ventana, abre una nueva y vuelve a ejecutar el script.
goto download

:run
echo Usando: %PYTHON_CMD%
%PYTHON_CMD% gd.py %*
goto :eof

:check_python
REM %1 = comando a probar (python o py)
"%~1" --version >nul 2>&1
if not errorlevel 1 (
    set "PYTHON_CMD=%~1"
)
goto :eof

:download
echo.
echo No se pudo instalar Python automaticamente.
echo Abriendo la pagina de descarga de Python...
start "" "https://www.python.org/downloads/"
echo.
echo Instala Python desde el instalador descargado y marca la casilla
echo "Add python.exe to PATH" durante la instalacion.
echo Luego vuelve a ejecutar este script.
pause
exit /b 1
