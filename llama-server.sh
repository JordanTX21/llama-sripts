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
    set -o allexport
    source "$SCRIPT_DIR/.env"
    set +o allexport
fi

# Asignar rutas por defecto si las variables de entorno están vacías
if [ -z "$LLAMA_PATH" ]; then
    LLAMA_PATH="../bin/llama-b9803-bin-linux" # Ajusta el nombre de la carpeta según tu versión de Linux
fi

# Convertir MODELS_FOLDER a ruta absoluta
if [ -z "$MODELS_FOLDER" ]; then
    MODELS_FOLDER="$(cd "$SCRIPT_DIR/../models" && pwd)"
fi

ROOT="$SCRIPT_DIR/.."

# 2. Ejecutar llama-server (usamos \ para romper líneas en Bash)
"$LLAMA_PATH/llama-server" \
    --models-dir "$MODELS_FOLDER" \
    --models-preset "$SCRIPT_DIR/presets.ini" \
    --host "$HOST_ARG" \
    --port "$PORT_ARG"
