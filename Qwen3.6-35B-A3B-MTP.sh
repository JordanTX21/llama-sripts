#!/usr/bin/env bash

# Valores por defecto
PORT_ARG="8080"
HOST_ARG="127.0.0.1"

# Parsear argumentos (Soporta --PORT=valor y --HOST=valor)
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
            # Otros argumentos no reconocidos
            ;;
    esac
done

# 1. FORZAR EL DIRECTORIO DE TRABAJO A LA CARPETA DEL SCRIPT
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Cargar variables de entorno desde el archivo .env si existe
if [ -f "$SCRIPT_DIR/.env" ]; then
    # Lee el archivo ignorando comentarios (#) y exporta las variables
    while IFS='=' read -r key value || [ -n "$key" ]; do
        # Ignorar líneas vacías y comentarios
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Limpiar comillas si existen en el valor
        value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')
        export "$key"="$value"
     Dilizado desde el archivo .env
    done < "$SCRIPT_DIR/.env"
fi

# Asignar rutas por defecto si no están en el entorno
# NOTA: Ajusté la ruta bin para Linux (quitando el entorno de windows/cuda-win)
if [ -z "$LLAMA_PATH" ]; then
    LLAMA_PATH="../bin" 
fi

if [ -z "$MODELS_FOLDER" ]; then
    MODELS_FOLDER="../models"
fi

ROOT="$SCRIPT_DIR/.."

MODEL_FOLDER="$MODELS_FOLDER/Qwen/Qwen3.6-35B-A3B-MTP"
MODEL_PATH="$MODEL_FOLDER/Qwen3.6-35B-A3B-UD-IQ2_XXS.gguf"
MODEL_ALIAS="Qwen3.6-35B-A3B"

if [ -z "$CONTEXT_WINDOW" ]; then
    CONTEXT_WINDOW=131072
fi

# 2. Ejecutar llama-server (sin el .exe y usando barras normales)
"$LLAMA_PATH/llama-server" \
  -m "$MODEL_PATH" \
  -ngl 999 \
  --fit off \
  -c "$CONTEXT_WINDOW" \
  -ncmoe 30 \
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
  --cache-idle-slots \
  --kv-unified \
  --host "$HOST_ARG" \
  --port "$PORT_ARG" \
  -a "$MODEL_ALIAS"
