@echo off
setlocal

set PORT_ARG=%1
if "%PORT_ARG%"=="" set PORT_ARG=8080

set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

set ROOT=%SCRIPT_DIR%..

..\bin\llama-b9803-bin-win-cuda-13.3-x64\llama-server.exe ^
-m ..\models\Qwen\Qwen3.6-35B-A3B\Qwen3.6-35B-A3B-UD-IQ2_XXS.gguf ^
-mm ..\models\Qwen\Qwen3.6-35B-A3B\mmproj-BF16.gguf ^
-c 131072 ^
-ngl 999 ^
-fa on ^
-t 6 ^
-tb 8 ^
-np 1 ^
-b 512 ^
-ub 512 ^
-Cr 0-11 ^
-Crb 0-11 ^
--cpu-strict 1 ^
--cpu-strict-batch 1 ^
--jinja ^
--reasoning on ^
--image-min-tokens 1024 ^
--cache-type-k q4_0 ^
--cache-type-v q4_0 ^
--prio 3 ^
--prio-batch 3 ^
--poll 100 ^
--poll-batch 1 ^
--temp 0.6 ^
--top-p 0.95 ^
--top-k 20 ^
--min-p 0.0 ^
--presence-penalty 0.0 ^
--repeat-penalty 1.0 ^
--no-mmap ^
--host 127.0.0.1 ^
--port %PORT_ARG% ^
-a Qwen3.6-35B-A3B