# AI Ops Gateway Implementation

> LiteLLM + Langfuse + Open WebUI + Qdrant

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit .env with your API keys
```

### 2. Start the Stack

```bash
docker-compose up -d
```

### 3. Access Services

| Service | URL | Purpose |
|---------|-----|---------|
| Open WebUI | http://localhost:3000 | Chat interface |
| Langfuse | http://localhost:3001 | Observability |
| LiteLLM | http://localhost:4000 | API Gateway |
| Qdrant | http://localhost:6333 | Vector DB |

### 4. First-Time Setup

1. **Langfuse**: Visit http://localhost:3001, create account
2. **Open WebUI**: Visit http://localhost:3000, create admin account
3. **Get Langfuse keys**: Settings → API Keys → Copy to .env
4. **Restart**: `docker-compose restart litellm`

## Using the Gateway

### Direct API Access

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

### Python

```python
import openai

client = openai.OpenAI(
    base_url="http://localhost:4000/v1",
    api_key="your-litellm-master-key"
)

response = client.chat.completions.create(
    model="claude-sonnet",  # or: reasoning, fast, vision, etc.
    messages=[{"role": "user", "content": "Hello"}]
)
```

### Available Models

| Alias | Model | Best For |
|-------|-------|----------|
| `reasoning` | Claude Opus | Complex tasks |
| `default` | Claude Sonnet | Daily use |
| `fast` | Claude Haiku | Quick tasks |
| `vision` | GPT-4o | Image understanding |
| `cheap` | GPT-4o-mini | High volume |
| `long-context` | Gemini Pro | Large documents |
| `multimodal` | Gemini Flash | Mixed media |
| `private` | Local Llama | Sensitive data |

## Monitoring

### Langfuse Dashboard
- View all API calls
- Track costs by model
- Analyze latency
- Debug errors

### Cost Tracking
All calls are logged with:
- Token counts
- Cost in USD
- Model used
- Latency

## Troubleshooting

### Check Logs
```bash
docker-compose logs -f litellm
docker-compose logs -f langfuse
```

### Restart Services
```bash
docker-compose restart
```

### Reset Everything
```bash
docker-compose down -v
docker-compose up -d
```

## Architecture

```
┌─────────────────┐
│   Open WebUI    │ ← Chat interface
│   :3000         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    LiteLLM      │ ← Unified API
│    :4000        │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────┐
│Claude │ │ GPT   │ ... → AI Providers
└───────┘ └───────┘
         │
         ▼
┌─────────────────┐
│    Langfuse     │ ← Observability
│    :3001        │
└─────────────────┘
```

## Next Steps

1. Add more models to `litellm_config.yaml`
2. Set up cost budgets
3. Configure caching (Redis)
4. Add guardrails
5. Set up backups
