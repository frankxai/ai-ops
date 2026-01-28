# Ollama (Local Models) Provider Research

> Run LLMs locally for privacy and cost savings

## Overview

Ollama enables:
- Running open-source LLMs locally
- Complete privacy (no data leaves your machine)
- Zero API costs after setup
- OpenAI-compatible API

---

## Popular Models (January 2026)

| Model | Size | VRAM | Best For |
|-------|------|------|----------|
| **Llama 3.3 70B** | 40GB | 48GB+ | Best open-source quality |
| **Llama 3.2 8B** | 4.5GB | 8GB | Fast local inference |
| **Mistral 7B** | 4GB | 8GB | Efficient, good quality |
| **Mixtral 8x7B** | 26GB | 32GB+ | MoE, good reasoning |
| **Qwen 2.5 72B** | 40GB | 48GB+ | Strong multilingual |
| **DeepSeek-R1** | Various | Various | Reasoning focused |
| **Phi-3** | 2GB | 4GB | Ultra-efficient |

---

## Hardware Requirements

### Minimum (7B models)
- 16GB RAM
- 8GB VRAM (or CPU-only, slower)
- Modern CPU

### Recommended (70B models)
- 64GB RAM
- 48GB+ VRAM (RTX 4090 or A100)
- Fast NVMe SSD

### Budget Options
- **Mac M1/M2/M3**: Unified memory works well
- **Gaming GPU**: RTX 3090/4090 (24GB VRAM)
- **CPU-only**: Slower but works for small models

---

## Installation

### macOS/Linux
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Windows
Download from [ollama.com](https://ollama.com/download)

### Docker
```bash
docker run -d -v ollama:/root/.ollama -p 11434:11434 ollama/ollama
```

---

## Usage

### Pull Models
```bash
ollama pull llama3.3:70b
ollama pull mistral:7b
ollama pull phi3:mini
```

### Run Locally
```bash
ollama run llama3.3:70b
```

### API
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.3:70b",
  "prompt": "Hello"
}'
```

---

## Via LiteLLM

```yaml
# litellm_config.yaml
model_list:
  - model_name: local-llama-70b
    litellm_params:
      model: ollama/llama3.3:70b
      api_base: http://localhost:11434

  - model_name: local-llama-8b
    litellm_params:
      model: ollama/llama3.2:8b
      api_base: http://localhost:11434

  - model_name: local-mistral
    litellm_params:
      model: ollama/mistral:7b
      api_base: http://localhost:11434
```

---

## Use Cases in AI Ops

| Domain | Model | Use Case |
|--------|-------|----------|
| **Family** | Llama 8B | Ultra-private queries |
| **Family** | Mistral 7B | Fast local assistant |
| **GenCreator** | Llama 70B | Drafting when offline |
| **Dev** | DeepSeek Coder | Code completion |
| **Privacy** | Any | Sensitive data processing |

---

## Cost Analysis

### Cloud API vs Local

| Scenario | Cloud (Claude) | Local (Llama 70B) |
|----------|----------------|-------------------|
| 1M tokens/month | ~$50 | $0 (electricity only) |
| 10M tokens/month | ~$500 | $0 |
| Hardware cost | $0 | $2,000-5,000 one-time |
| Break-even | - | ~4-10 months |

### When to Use Local
- Privacy-critical queries
- High volume, simple tasks
- Offline operation needed
- Cost optimization for repetitive tasks

---

## Integration Notes

### Hybrid Strategy
```yaml
# Use local for simple/private, cloud for complex
model_list:
  # Simple tasks → local (free)
  - model_name: simple
    litellm_params:
      model: ollama/llama3.2:8b
      api_base: http://localhost:11434

  # Complex tasks → cloud (better quality)
  - model_name: complex
    litellm_params:
      model: claude-opus-4-5-20251101
      api_key: os.environ/ANTHROPIC_API_KEY

router_settings:
  routing_strategy: "cost-based-routing"
```

### Fallback to Cloud
```yaml
router_settings:
  fallbacks: [
    {"local-llama": ["claude-haiku"]}
  ]
```

---

## Performance Tuning

### GPU Acceleration
```bash
# Check GPU is being used
ollama ps

# Set GPU layers
ollama run llama3.3:70b --num-gpu 99
```

### Context Length
```bash
# Increase context window
ollama run llama3.3:70b --ctx-size 32768
```

### Quantization
```bash
# Smaller models, faster inference
ollama pull llama3.3:70b-q4_K_M  # 4-bit quantized
```

---

## Resources

- [Ollama](https://ollama.com/)
- [Model Library](https://ollama.com/library)
- [GitHub](https://github.com/ollama/ollama)

---

*Last Updated: January 2026*
