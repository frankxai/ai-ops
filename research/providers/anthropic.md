# Anthropic (Claude) Provider Research

> Claude models for reasoning, coding, and creative tasks

## Overview

Anthropic's Claude is known for:
- Strong reasoning and analysis
- Excellent coding capabilities
- Long context windows (200K tokens)
- Constitutional AI safety approach

---

## Models (January 2026)

| Model | Context | Best For | Cost (Input/Output per 1M) |
|-------|---------|----------|---------------------------|
| **Claude Opus 4.5** | 200K | Complex reasoning, research, strategy | $15 / $75 |
| **Claude Sonnet 4** | 200K | Balanced performance, daily tasks | $3 / $15 |
| **Claude Haiku 3.5** | 200K | Fast, simple tasks, high volume | $0.25 / $1.25 |

---

## Capabilities

### Strengths
- **Reasoning**: Multi-step analysis, planning
- **Coding**: Strong across languages, debugging
- **Writing**: Natural, nuanced content
- **Safety**: Built-in refusals for harmful content
- **Context**: 200K tokens = entire codebases

### Limitations
- No image generation
- No real-time data (knowledge cutoff)
- Can be overly cautious/verbose
- No fine-tuning (yet)

---

## API Access

### Authentication
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### Direct API
```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-opus-4-5-20251101",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude"}
    ]
)
```

### Via LiteLLM
```yaml
# litellm_config.yaml
model_list:
  - model_name: claude-opus
    litellm_params:
      model: claude-opus-4-5-20251101
      api_key: os.environ/ANTHROPIC_API_KEY

  - model_name: claude-sonnet
    litellm_params:
      model: claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY

  - model_name: claude-haiku
    litellm_params:
      model: claude-3-5-haiku-20241022
      api_key: os.environ/ANTHROPIC_API_KEY
```

---

## Use Cases in AI Ops

| Domain | Model | Use Case |
|--------|-------|----------|
| **GenCreator** | Opus | Strategy, long-form content |
| **GenCreator** | Sonnet | Daily writing, editing |
| **ACOS** | Opus | Orchestrator agent |
| **ACOS** | Haiku | Tool-calling agents |
| **Family** | Sonnet | General assistant |
| **Family** | Haiku | Quick Q&A |

---

## Cost Optimization

### Strategies
1. **Use Haiku for simple tasks** - 60x cheaper than Opus
2. **Prompt caching** - Reduce repeated context costs
3. **Batch API** - 50% discount for async workloads
4. **Context pruning** - Don't send full history every time

### Example Cost Scenarios
| Scenario | Model | Tokens | Cost |
|----------|-------|--------|------|
| Quick question | Haiku | 1K in / 500 out | $0.0009 |
| Article writing | Sonnet | 5K in / 2K out | $0.045 |
| Deep analysis | Opus | 10K in / 5K out | $0.525 |

---

## Features

### Extended Thinking (Opus)
```python
response = client.messages.create(
    model="claude-opus-4-5-20251101",
    max_tokens=16000,
    thinking={
        "type": "enabled",
        "budget_tokens": 10000
    },
    messages=[...]
)
```

### Tool Use
```python
tools = [
    {
        "name": "get_weather",
        "description": "Get current weather",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {"type": "string"}
            }
        }
    }
]

response = client.messages.create(
    model="claude-sonnet-4-20250514",
    tools=tools,
    messages=[...]
)
```

### Vision (Sonnet/Opus)
```python
message = client.messages.create(
    model="claude-sonnet-4-20250514",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "image", "source": {"type": "base64", "media_type": "image/png", "data": base64_image}},
                {"type": "text", "text": "Describe this image"}
            ]
        }
    ]
)
```

---

## Rate Limits

| Tier | Opus | Sonnet | Haiku |
|------|------|--------|-------|
| Tier 1 | 1K RPM | 1K RPM | 1K RPM |
| Tier 2 | 2K RPM | 2K RPM | 2K RPM |
| Tier 3 | 4K RPM | 4K RPM | 4K RPM |
| Tier 4 | 8K RPM | 8K RPM | 8K RPM |

---

## Integration Notes

### For AI Ops Gateway
- Use LiteLLM proxy for unified access
- Set up fallbacks: Opus → Sonnet → Haiku
- Enable prompt caching for cost savings
- Track costs via Langfuse

### Recommended Config
```yaml
model_list:
  # Primary reasoning model
  - model_name: reasoning
    litellm_params:
      model: claude-opus-4-5-20251101
      api_key: os.environ/ANTHROPIC_API_KEY
    model_info:
      mode: chat

  # Daily driver
  - model_name: default
    litellm_params:
      model: claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY

  # Fast/cheap
  - model_name: fast
    litellm_params:
      model: claude-3-5-haiku-20241022
      api_key: os.environ/ANTHROPIC_API_KEY

router_settings:
  routing_strategy: "usage-based-routing"
  enable_pre_call_checks: true
```

---

## Resources

- [Anthropic API Docs](https://docs.anthropic.com/)
- [Claude Model Card](https://www.anthropic.com/claude)
- [Pricing](https://www.anthropic.com/pricing)

---

*Last Updated: January 2026*
