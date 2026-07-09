# Llama.cpp Scripts

Colección de scripts `.bat` para ejecutar servidores locales con diferentes modelos usando `llama-server.exe`.

## Configuración

Para evitar modificar cada script cuando actualices la versión de `llama.cpp` u otras variables compartidas, el proyecto utiliza un archivo `.env`.

1. Copia el archivo `.env.example` a `.env`
2. Modifica `.env` con tus rutas personalizadas:

```env
LLAMA_PATH="..\bin\llama-b9803-bin-win-cuda-13.3-x64"
```

## Uso

Ejecuta cualquiera de los scripts pasando como argumentos el puerto (opcional) y el host (opcional):

```cmd
Qwen3.5-4B-Q4-MTP.bat [--PORT=8080] [--HOST=127.0.0.1]
```

Ejemplos:
```cmd
:: Arranca en el puerto 8080 (por defecto) y localhost (por defecto)
Qwen3.5-4B-Q4-MTP.bat

:: Arranca en el puerto 1234
Qwen3.5-4B-Q4-MTP.bat --PORT=1234

:: Arranca en el puerto 8080, accesible en la red local
Qwen3.5-4B-Q4-MTP.bat --PORT=8080 --HOST=0.0.0.0
```

## Descargas Necesarias

### 1. Descargar Llama.cpp
Puedes obtener la última versión precompilada de `llama.cpp` para Windows desde su repositorio oficial en GitHub:
- [Llama.cpp Releases](https://github.com/ggml-org/llama.cpp/releases)

Descarga el archivo zip correspondiente a tu sistema (generalmente el que incluye `bin-win-cuda` si usas NVIDIA) y extrae su contenido. Luego, asegúrate de actualizar la variable `LLAMA_PATH` en tu archivo `.env` para que apunte a la carpeta donde se encuentra `llama-server.exe`.

### 2. Descargar Modelos
Los scripts están configurados para usar modelos GGUF, específicamente de la familia Qwen. Puedes descargar los modelos requeridos desde HuggingFace:

- **Qwen3.6-35B-A3B-MTP:** [https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF)
- **Qwen3.5-9B-MTP:** [https://huggingface.co/unsloth/Qwen3.5-9B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.5-9B-MTP-GGUF)
- **Qwen3.5-4B-MTP:** [https://huggingface.co/unsloth/Qwen3.5-4B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.5-4B-MTP-GGUF)

Una vez descargados los archivos `.gguf`, colócalos respetando la estructura de carpetas especificada dentro de tu directorio de modelos (configurable vía `MODELS_FOLDER` en el `.env`).
