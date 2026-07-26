# Llama.cpp Scripts

Colección de scripts para ejecutar servidores locales con diferentes modelos usando `llama-server.exe` (Windows) y `llama-server` (Linux).

## Estructura del Proyecto

```
llama.cpp/
├── scripts/
│   ├── README.md
│   ├── presets.ini              # Configuraciones compartidas por modelo
│   ├── .env                      # Variables de entorno compartidas
│   ├── llama-server.bat         # Script genérico Windows
│   ├── linux/
│   │   └── llama-server.sh       # Script genérico Linux
│   └── windows/
│       ├── llama-server.bat      # Script genérico Windows
│       └── Qwen/
│           ├── Qwen3.6-35B.bat
│           ├── Qwen3.5-9B.bat
│           └── Qwen3.5-4B.bat
├── models/
│   ├── Qwen/
│   │   ├── Qwen3.6-35B-A3B/
│   │   ├── Qwen3.5-9B/
│   │   └── Qwen3.5-4B/
│   └── Gemma/
│       └── Gemma4-12B/
└── bin/
    └── llama-b9803-bin-win-cuda-13.3-x64/
        └── llama-server.exe
```

## Configuración

Para evitar modificar cada script cuando actualices la versión de `llama.cpp` u otras variables compartidas, el proyecto utiliza un archivo `.env`.

1. Copia el archivo `.env.example` a `.env`
2. Modifica `.env` con tus rutas personalizadas:

```env
LLAMA_PATH="..\bin\llama-b9803-bin-win-cuda-13.3-x64"
MODELS_FOLDER="..\models"
CONTEXT_WINDOW=32000
```

## Uso

Los scripts se dividen en dos categorías:

### Scripts Genéricos

Ejecuta el script genérico pasando como argumentos el puerto (opcional) y el host (opcional):

```cmd
llama-server.bat [--PORT=8080] [--HOST=127.0.0.1]
```

**Nota:** Los scripts genéricos usan `presets.ini` para cargar las configuraciones del modelo.

#### Ejemplos:

```cmd
:: Arranca usando la configuración de presets.ini (por defecto)
llama-server.bat

:: Arranca en el puerto 1234
llama-server.bat --PORT=1234

:: Arranca en el puerto 8080, accesible en la red local
llama-server.bat --PORT=8080 --HOST=0.0.0.0
```

### Scripts Específicos por Modelo

Los scripts específicos (ej. `Qwen3.5-4B.bat`) cargan automáticamente:
- La ruta al modelo GGUF específico
- El archivo mmproj (multimodal) si existe
- Parámetros personalizados según el modelo

```cmd
Qwen3.5-4B.bat [--PORT=8080] [--HOST=127.0.0.1]
```

#### Ejemplos:

```cmd
:: Arranca Qwen3.5-4B en el puerto 8080 (por defecto) y localhost (por defecto)
Qwen3.5-4B.bat

:: Arranca Qwen3.5-4B en el puerto 1234
Qwen3.5-4B.bat --PORT=1234

:: Arranca Qwen3.5-4B en el puerto 8080, accesible en la red local
Qwen3.5-4B.bat --PORT=8080 --HOST=0.0.0.0
```

## Cómo funcionan los scripts

### Scripts Genéricos (llama-server.bat / llama-server.sh)

1. Cargan `.env` para obtener rutas compartidas
2. Cargan `presets.ini` usando `--models-preset`
3. Ejecutan `llama-server` con las configuraciones del preset

**Ejemplo de carga de presets.ini:**

```batch
# Windows
--models-preset "%SCRIPT_DIR%presets.ini"
```

```bash
# Linux
--models-preset "$SCRIPT_DIR/presets.ini"
```

Los scripts genéricos leen `presets.ini` y cargan automáticamente las configuraciones de la sección `[Qwen3.5-4B]` o la primera sección disponible.

### Parámetros de presets.ini (Documentación oficial)

Consulta la [documentación oficial de llama.cpp](https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md) para ver todos los parámetros disponibles.

### Scripts Específicos por Modelo (Qwen/*.bat)

1. Cargan `.env` para obtener rutas compartidas
2. Definen la ruta específica al modelo GGUF
3. Definen el archivo mmproj si existe
4. Aplican parámetros específicos del modelo
5. Ejecutan `llama-server` directamente sin usar `presets.ini`

**Ejemplo de configuración de modelo:**

```batch
set MODEL_FOLDER="%MODELS_FOLDER%\Qwen\Qwen3.5-4B-MTP"
set MODEL_PATH=%MODEL_FOLDER%\Qwen3.5-4B-UD-Q4_K_XL.gguf
set MODEL_ALIAS=Qwen3.5-4B

%LLAMA_PATH%\llama-server.exe ^
    -m %MODEL_PATH% ^
    -mm %MODEL_FOLDER%\mmproj-BF16.gguf ^
    --reasoning on ^
    --cache-type-k q8_0 ^
    --cache-type-v q8_0 ^
    --spec-type draft-mtp ^
    --temp 0.6 ^
    --top-p 0.95 ^
    --top-k 20 ^
    ...
    -a %MODEL_ALIAS%
```

## Descargas Necesarias

### 1. Descargar Llama.cpp

Puedes obtener la última versión precompilada de `llama.cpp` para Windows desde su repositorio oficial en GitHub:
- [Llama.cpp Releases](https://github.com/ggml-org/llama.cpp/releases)

Descarga el archivo zip correspondiente a tu sistema (generalmente el que incluye `bin-win-cuda` si usas NVIDIA) y extrae su contenido. Luego, asegúrate de actualizar la variable `LLAMA_PATH` en tu archivo `.env` para que apunte a la carpeta donde se encuentra `llama-server.exe`.

### 2. Descargar Modelos

Los scripts están configurados para usar modelos de diferentes familias. Puedes descargar los modelos requeridos desde HuggingFace:

#### Qwen Series

- **Qwen3.6-35B-A3B-MTP:** [https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF)
- **Qwen3.5-9B-MTP:** [https://huggingface.co/unsloth/Qwen3.5-9B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.5-9B-MTP-GGUF)
- **Qwen3.5-4B-MTP:** [https://huggingface.co/unsloth/Qwen3.5-4B-MTP-GGUF](https://huggingface.co/unsloth/Qwen3.5-4B-MTP-GGUF)

#### Gemma Series

- **Gemma-4-12B:** [https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF](https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF)

Una vez descargados los archivos `.gguf`, colócalos respetando la estructura de carpetas especificada dentro de tu directorio de modelos (configurable vía `MODELS_FOLDER` en el `.env`).

**Ejemplo de estructura de modelos:**

```
models/
├── Qwen/
│   ├── Qwen3.6-35B-A3B/
│   │   └── Qwen3.6-35B-A3B-MXFP4_MOE.gguf
│   ├── Qwen3.5-9B/
│   │   ├── Qwen3.5-9B-UD-Q4_K_XL.gguf
│   │   └── mmproj-BF16.gguf
│   └── Qwen3.5-4B/
│       ├── Qwen3.5-4B-UD-Q4_K_XL.gguf
│       └── mmproj-BF16.gguf
└── Gemma/
    └── Gemma4-12B/
        ├── gemma-4-12B-it-qat-UD-Q4_K_XL.gguf
        └── mmproj-BF16.gguf
```

### 3. Configurar presets.ini

El archivo `presets.ini` contiene configuraciones compartidas para todos los modelos. Cada sección representa un modelo diferente:

```ini
[Qwen3.5-4B]
model               = ../models/Qwen/Qwen3.5-4B/Qwen3.5-4B-UD-Q4_K_XL.gguf
mmproj              = ../models/Qwen/Qwen3.5-4B/mmproj-BF16.gguf
reasoning           = 1
cache-type-k        = q8_0
cache-type-v        = q8_0
cache-type-k-draft  = q8_0
cache-type-v-draft  = q8_0
spec-type           = draft-mtp
spec-draft-n-max    = 2
temp                = 0.6
top-k               = 20
parallel            = 1
```

Para usar un preset específico, los scripts genéricos cargan automáticamente la primera sección disponible.

## Diferencias entre Windows y Linux

| Aspecto | Windows (.bat) | Linux (.sh) |
|---------|---------------|-------------|
| Sintaxis de argumentos | `--PORT=8080` | `--PORT=8080` |
| Rutas relativas | `..\models` | `../models` |
| Carga de .env | `set "VAR=valor"` | `source .env` |
| Ejecución | `llama-server.bat` | `./llama-server.sh` |
| Scripts modelo | `Qwen/*.bat` | `linux/llama-server.sh` (genérico) |

## Notas Importantes

1. **Scripts genéricos vs específicos:** Los scripts genéricos usan `presets.ini`, mientras que los scripts específicos cargan las configuraciones directamente en el comando.

2. **Rutas relativas:** Los scripts usan rutas relativas desde la carpeta `scripts/`. Asegúrate de ejecutarlos desde ahí o ajusta las rutas en `.env`.

3. **Modelos multimodales:** Los modelos Qwen y Gemma requieren un archivo `mmproj` adicional. Los scripts lo cargan automáticamente si existe.

4. **Context window:** La variable `CONTEXT_WINDOW` en `.env` define el tamaño del contexto por defecto (por defecto: 32000 tokens).
