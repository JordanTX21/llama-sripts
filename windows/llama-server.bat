@echo off
setlocal

set PORT_ARG=8080
set HOST_ARG=127.0.0.1

:parse_args
if "%~1"=="" goto end_parse_args
for /f "tokens=1,2 delims==" %%a in ("%~1") do (
    if /i "%%a"=="--PORT" set PORT_ARG=%%b
    if /i "%%a"=="--HOST" set HOST_ARG=%%b
)
shift
goto parse_args
:end_parse_args

set SCRIPT_DIR=%~dp0..\
:: 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
cd /d "%SCRIPT_DIR%"

if exist "%SCRIPT_DIR%.env" (
    for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%SCRIPT_DIR%.env") do (
        set "%%A=%%~B"
    )
)

if "%LLAMA_PATH%"=="" set LLAMA_PATH="..\bin\llama-b9803-bin-win-cuda-13.3-x64"
:: Convertir MODELS_FOLDER a una ruta absoluta completa
if "%MODELS_FOLDER%"=="" (
    for %%i in ("%SCRIPT_DIR%..\models") do set "MODELS_FOLDER=%%~fi"
)

set ROOT=%SCRIPT_DIR%..

%LLAMA_PATH%\llama-server.exe ^
    --models-dir "%MODELS_FOLDER%" ^
    --models-max 1 ^
    --models-preset "%SCRIPT_DIR%presets.ini" ^
    --host %HOST_ARG% ^
    --port %PORT_ARG%
