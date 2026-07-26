# AGENTS.md

## Project Overview

Local LLM server infrastructure for running Qwen and Gemma models using llama.cpp. Scripts orchestrate llama-server.exe with model-specific configurations.

## Setup Requirements

### 1. Prerequisites

- **llama-server.exe**: Download from [llama.cpp releases](https://github.com/ggml-org/llama.cpp/releases)
- **Model files (.gguf)**: Download from HuggingFace (Qwen/Gemma series)
- **Environment variable file**: Copy `.env.example` → `.env` and configure paths

### 2. Model Downloads

**Qwen Series** (MTP variants):
- Qwen3.6-35B-A3B: https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF
- Qwen3.5-9B-MTP: https://huggingface.co/unsloth/Qwen3.5-9B-MTP-GGUF  
- Qwen3.5-4B-MTP: https://huggingface.co/unsloth/Qwen3.5-4B-MTP-GGUF

**Gemma Series**:
- Gemma-4-12B: https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF

### 3. Directory Structure

```
scripts/
├── presets.ini              # Shared model configs for generic scripts
├── .env                     # Environment variables (must be created)
├── llama-server.bat         # Generic Windows launcher
├── presets.ini              # Model configurations
├── linux/                   # Linux-specific scripts
│   └── llama-server.sh
└── windows/                 # Windows-specific scripts
    └── Qwen/               # Model-specific batch files
        ├── Qwen3.6-35B.bat
        ├── Qwen3.5-9B.bat
        └── Qwen3.5-4B.bat
```

## How to Run

### Generic Scripts (use presets.ini)

```cmd
# Default preset
llama-server.bat

# Specific port
llama-server.bat --PORT=1234

# Network accessible
llama-server.bat --PORT=8080 --HOST=0.0.0.0
```

### Model-Specific Scripts (auto-loads model paths)

```cmd
# Default configuration
Qwen3.5-4B.bat

# Custom port
Qwen3.6-35B-A3B.bat --PORT=1234
```

### Model-Specific Parameters

Qwen models require:
- `--reasoning on`
- `--cache-type-k q8_0` / `--cache-type-v q8_0`
- `--spec-type draft-mtp`
- `--temp 0.6`
- `--top-p 0.95`
- `--top-k 20`

## Configuration

### .env Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LLAMA_PATH` | Path to llama-server.exe | `..\bin\llama-b10107-bin-win-cuda-13.3-x64` |
| `MODELS_FOLDER` | Models directory | `..\models` |
| `CONTEXT_WINDOW` | Default context size | `131072` |

### presets.ini Format

```ini
[ModelName]
model               = <path-to-gguf>
mmproj              = <path-to-mmproj>
reasoning           = 1
cache-type-k        = q8_0
cache-type-v        = q8_0
spec-type           = draft-mtp
temp                = 0.6
top-k               = 20
```

## Key Differences

| Aspect | Generic Scripts | Model-Specific Scripts |
|--------|----------------|------------------------|
| Config source | `presets.ini` | Direct command-line args |
| Model path | From preset | Explicitly defined |
| mmproj | Auto-detected from preset | Explicitly defined |

## Important Notes

1. **Execute from `scripts/` directory**: Scripts use relative paths from this location.
2. **Multimodal models**: Qwen and Gemma require `mmproj` files. Scripts auto-load if present.
3. **Windows vs Linux**: Path separators differ (`\` vs `/`), env loading differs (`set` vs `source`).
4. **Context window**: Set in `.env` (default: 131072 tokens).
5. **OpenCode integration**: Configured in `agents-settings/opencode.json` with model providers for Qwen/Gemma.

## OpenCode Configuration

- **MCP servers**: Playwright (local), Context7 (local)
- **Model providers**: Configured for Qwen3.5-9B, Qwen3.6-35B-A3B, Qwen3.5-4B, Gemma-4-12B
- **Server**: Port 4096, hostname 0.0.0.0, MDNS enabled
