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

set SCRIPT_DIR=%~dp0
:: 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
cd /d "%SCRIPT_DIR%"

if exist "%SCRIPT_DIR%.env" (
    for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%SCRIPT_DIR%.env") do (
        set "%%A=%%~B"
    )
)

if "%LLAMA_PATH%"=="" set LLAMA_PATH="..\bin\llama-b9803-bin-win-cuda-13.3-x64"
if "%MODELS_FOLDER%"=="" set MODELS_FOLDER="..\models"

set ROOT=%SCRIPT_DIR%..

set MODEL_FOLDER="%MODELS_FOLDER%\Qwythos"
set MODEL_PATH=%MODEL_FOLDER%\Qwythos-9B-Claude-Mythos-5-1M-Q4_K_M.gguf
set MODEL_ALIAS=Qwythos-9B
if "%CONTEXT_WINDOW%"=="" set CONTEXT_WINDOW=131072

:: 2. Ahora las rutas relativas funcionarán perfectamente siempre
%LLAMA_PATH%\llama-server.exe ^
-m %MODEL_PATH% ^
-mm %MODEL_FOLDER%\mmproj-Qwythos-9B-Claude-Mythos-5-1M-F16.gguf ^
-c %CONTEXT_WINDOW% ^
-ngl 99 ^
-fa on ^
--cache-type-k q8_0 ^
--cache-type-v q8_0 ^
--image-min-tokens 1024 ^
--reasoning on ^
--temp 0.6 ^
--top-p 0.95 ^
--top-k 20 ^
--min-p 0.00 ^
--presence-penalty 0.0 ^
--repeat-penalty 1.05 ^
--dry-multiplier 0.1 ^
--dry-base 1.05 ^
--dry-allowed-length 12 ^
--dry-penalty-last-n 128 ^
--host %HOST_ARG% ^
--port %PORT_ARG% ^
-a %MODEL_ALIAS%
