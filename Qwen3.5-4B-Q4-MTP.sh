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
MODEL_FOLDER="$MODELS_FOLDER/Qwen/Qwen3.5-4B-MTP"
MODEL_PATH="$MODEL_FOLDER/Qwen3.5-4B-UD-Q4_K_XL.gguf"
MODEL_ALIAS="Qwen3.5-4B"

if [ -z "$CONTEXT_WINDOW" ]; then
    CONTEXT_WINDOW=131072
fi

# 2. Ejecutar llama-server (usamos \ para romper líneas en Bash)
"$LLAMA_PATH/llama-server" \
  -m "$MODEL_PATH" \
  -mm "$MODEL_FOLDER/mmproj-BF16.gguf" \
  -ngl 999 \
  --fit off \
  -c "$CONTEXT_WINDOW" \
  --reasoning on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --cache-type-k-draft q8_0 \
  --cache-type-v-draft q8_0 \
  --spec-type draft-mtp \
  --spec-draft-n-max 2 \
  --temp 0.6 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0.0 \
  --presence-penalty 0.0 \
  --repeat-penalty 1.0 \
  -np 1 \
  -lv 4 \
  --image-min-tokens 1024 \
  --cache-idle-slots \
  --kv-unified \
  --host "$HOST_ARG" \
  --port "$PORT_ARG" \
  -a "$MODEL_ALIAS"
