#!/bin/bash

# Valores por defecto
PORT_ARG="8080"
HOST_ARG="127.0.0.1"

# Parsear argumentos (--PORT=8080 --HOST=127.0.0.1)
for arg in "$@"; do
    case $arg in
        --PORT=*)
            PORT_ARG="${arg#*=}"
            shift
            ;;
        --HOST=*)
            HOST_ARG="${arg#*=}"
            shift
            ;;
        *)
            # Otros argumentos si los hubiera
            shift
            ;;
    esac
done

# 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Cargar archivo .env si existe (ignora comentarios que empiecen con #)
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

# Asignar rutas por defecto si las variables de entorno están vacías
if [ -z "$LLAMA_PATH" ]; then
    LLAMA_PATH="../bin/llama-b9803-bin-linux" # Ajusta el nombre de la carpeta según tu versión de Linux
fi

if [ -z "$MODELS_FOLDER" ]; then
    MODELS_FOLDER="../models"
fi

ROOT="$SCRIPT_DIR/.."
MODEL_FOLDER="$MODELS_FOLDER/Nanbeige/Nanbeige4.2-3B"
MODEL_PATH="$MODEL_FOLDER/Nanbeige4.2-3B-Q4_K_M.gguf"
MODEL_ALIAS="Nanbeige4.2-3B"

if [ -z "$CONTEXT_WINDOW" ]; then
    CONTEXT_WINDOW=131072
fi

# 2. Ejecutar llama-server (usamos \ para romper líneas en Bash)
"$LLAMA_PATH/llama-server" \
  -m "$MODEL_PATH" \
  -ngl 999 \
  --fit off \
  -c "$CONTEXT_WINDOW" \
  --cache-idle-slots \
  --kv-unified \
  --host "$HOST_ARG" \
  --port "$PORT_ARG" \
  -a "$MODEL_ALIAS"
