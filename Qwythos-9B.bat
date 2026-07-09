@echo off
setlocal

set PORT_ARG=%1
if "%PORT_ARG%"=="" set PORT_ARG=8080

set SCRIPT_DIR=%~dp0
:: 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
cd /d "%SCRIPT_DIR%"

set ROOT=%SCRIPT_DIR%..

:: 2. Ahora las rutas relativas funcionarán perfectamente siempre
..\bin\llama-b9803-bin-win-cuda-13.3-x64\llama-server.exe ^
-m ..\models\Qwythos\Qwythos-9B-Claude-Mythos-5-1M-Q4_K_M.gguf ^
-mm ..\models\Qwythos\mmproj-Qwythos-9B-Claude-Mythos-5-1M-F16.gguf ^
-c 131072 ^
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
--host 127.0.0.1 ^
--port %PORT_ARG% ^
-a Qwythos-9B
