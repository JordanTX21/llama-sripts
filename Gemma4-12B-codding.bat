@echo off
setlocal

set PORT_ARG=%1
if "%PORT_ARG%"=="" set PORT_ARG=8080

set SCRIPT_DIR=%~dp0
:: 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
cd /d "%SCRIPT_DIR%"

set ROOT=%SCRIPT_DIR%..

:: 2. Ahora las rutas relativas funcionarán perfectamente siempre
..\bin\llama-b9859-bin-win-cuda-13.3-x64\llama-server.exe ^
-m ..\models\Gemma4\Gemma4-12B-codding\gemma4-coding-Q2_K.gguf ^
--ctx-size 16384 ^
--n-gpu-layers 99 ^
--no-mmap ^
-fa on ^
--cache-type-k q8_0 --cache-type-v q8_0 ^
--temp 1.0 --top-p 0.95 --top-k 64 ^
--host 127.0.0.1 ^
--port %PORT_ARG% ^
-a Gemma4-12B