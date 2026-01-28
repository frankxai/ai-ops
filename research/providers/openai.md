# OpenAI Provider Research

> GPT models, o1/o3 reasoning, and DALL-E

## Overview

OpenAI offers:
- GPT-4o for general tasks
- o1/o3 for deep reasoning
- DALL-E for image generation
- Whisper for speech-to-text
- TTS for text-to-speech

---

## Models (January 2026)

### Chat/Reasoning
| Model | Context | Best For | Cost (Input/Output per 1M) |
|-------|---------|----------|---------------------------|
| **GPT-4o** | 128K | General tasks, vision | $2.50 / $10 |
| **GPT-4o-mini** | 128K | Fast, cheap tasks | $0.15 / $0.60 |
| **o1** | 128K | Complex reasoning, math, code | $15 / $60 |
| **o3-mini** | 128K | Reasoning, faster than o1 | $1.10 / $4.40 |

### Other
| Model | Purpose | Cost |
|-------|---------|------|
| **DALL-E 3** | Image generation | $0.04-0.12/image |
| **Whisper** | Speech-to-text | $0.006/minute |
| **TTS** | Text-to-speech | $0.015/1K chars |

---

## Capabilities

### GPT-4o Strengths
- Fast responses
- Vision (image understanding)
- Function calling
- JSON mode
- Good value

### o1/o3 Strengths
- Deep reasoning
- Math and science
- Complex coding
- Multi-step problems

### Limitations
- o1/o3 slower and expensive
- No streaming for o1
- Knowledge cutoff
- Can hallucinate

---

## API Access

### Authentication
```bash
export OPENAI_API_KEY="sk-..."
```

### Direct API
```python
from openai import OpenAI

client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "user", "content": "Hello"}
    ]
)
```

### Via LiteLLM
```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: gpt-4o
      api_key: os.environ/OPENAI_API_KEY

  - model_name: gpt-4o-mini
    litellm_params:
      model: gpt-4o-mini
      api_key: os.environ/OPENAI_API_KEY

  - model_name: o1
    litellm_params:
      model: o1
      api_key: os.environ/OPENAI_API_KEY
```

---

## Use Cases in AI Ops

| Domain | Model | Use Case |
|--------|-------|----------|
| **GenCreator** | GPT-4o | Quick edits, image analysis |
| **GenCreator** | DALL-E | Image generation |
| **ACOS** | o1 | Complex planning agents |
| **ACOS** | GPT-4o-mini | High-volume tool agents |
| **Family** | GPT-4o | Homework help |
| **Family** | Whisper | Voice notes |

---

## Cost Optimization

### Strategies
1. **GPT-4o-mini first** - 17x cheaper than GPT-4o
2. **Use o1 sparingly** - Only for truly complex tasks
3. **Batch API** - 50% discount
4. **Prompt caching** - Automatic for repeated prefixes

---

## Features

### Vision
```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "What's in this image?"},
                {"type": "image_url", "image_url": {"url": "data:image/png;base64,..."}}
            ]
        }
    ]
)
```

### Function Calling
```python
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {"type": "string"}
                }
            }
        }
    }
]

response = client.chat.completions.create(
    model="gpt-4o",
    tools=tools,
    messages=[...]
)
```

### JSON Mode
```python
response = client.chat.completions.create(
    model="gpt-4o",
    response_format={"type": "json_object"},
    messages=[...]
)
```

---

## Rate Limits

Vary by tier and model. Generally:
- Tier 1: 500 RPM
- Tier 2: 5,000 RPM
- Tier 3: 10,000 RPM
- Tier 5: 30,000 RPM

---

## Integration Notes

### For AI Ops Gateway
```yaml
model_list:
  # General purpose
  - model_name: gpt
    litellm_params:
      model: gpt-4o
      api_key: os.environ/OPENAI_API_KEY

  # Fast/cheap
  - model_name: gpt-mini
    litellm_params:
      model: gpt-4o-mini
      api_key: os.environ/OPENAI_API_KEY

  # Deep reasoning (use sparingly)
  - model_name: reasoning-openai
    litellm_params:
      model: o1
      api_key: os.environ/OPENAI_API_KEY

router_settings:
  fallbacks: [
    {"gpt": ["claude-sonnet"]},
    {"reasoning-openai": ["claude-opus"]}
  ]
```

---

## Resources

- [OpenAI API Docs](https://platform.openai.com/docs)
- [Pricing](https://openai.com/pricing)
- [Model Overview](https://platform.openai.com/docs/models)

---

*Last Updated: January 2026*
