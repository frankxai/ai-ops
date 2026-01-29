# Your First AI Ops Stack

> From scattered tools to unified intelligence in one afternoon

## Why This Guide Exists

You're probably using ChatGPT here, Claude there, maybe Gemini for something else. Different tabs, different contexts, no memory of what you discussed where. You're paying multiple subscriptions but have no idea what anything costs per query.

This guide gets you to:
- **One interface** for all your AI models
- **Full visibility** into usage and cost
- **Local option** for private/sensitive work
- **Foundation** for everything else in AI Ops

## The Minimum Viable Stack

```
┌─────────────────────────────────────┐
│         Open WebUI (:3000)          │  ← You chat here
│         Beautiful chat UI           │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│          LiteLLM (:4000)            │  ← Routes to right model
│     Claude | GPT | Gemini | Local   │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│         Langfuse (:3001)            │  ← Tracks everything
│    Costs | Latency | Quality        │
└─────────────────────────────────────┘
```

## Prerequisites

- Docker Desktop installed
- API keys for at least one provider (Anthropic, OpenAI, or Google)
- 30 minutes

## Step 1: Get the Files

```bash
git clone https://github.com/frankxai/ai-ops.git
cd ai-ops/implementations/gateway
```

## Step 2: Configure Your Keys

```bash
cp .env.example .env
```

Edit `.env`:

```bash
# Required: At least one AI provider
ANTHROPIC_API_KEY=sk-ant-your-key-here
OPENAI_API_KEY=sk-your-key-here
GOOGLE_API_KEY=your-key-here

# Required: Gateway security
LITELLM_MASTER_KEY=sk-aiops-$(openssl rand -hex 16)

# Required: Database
POSTGRES_PASSWORD=$(openssl rand -hex 16)

# Required: Langfuse security
NEXTAUTH_SECRET=$(openssl rand -hex 32)
LANGFUSE_SALT=$(openssl rand -hex 32)

# Leave blank for now, fill after Langfuse setup
LANGFUSE_PUBLIC_KEY=
LANGFUSE_SECRET_KEY=
```

## Step 3: Launch

```bash
docker-compose up -d
```

Wait 60 seconds for services to initialize.

## Step 4: First-Time Setup

### Langfuse (Observability)
1. Go to http://localhost:3001
2. Create account (local only, no external auth)
3. Create a project called "AI Ops"
4. Go to Settings → API Keys → Create
5. Copy public/secret keys to your `.env`

### Restart LiteLLM with Keys
```bash
docker-compose restart litellm
```

### Open WebUI (Chat Interface)
1. Go to http://localhost:3000
2. Create admin account
3. All models auto-appear from LiteLLM

## Step 5: Test It

In Open WebUI:
- Select "claude-sonnet" → Send a message
- Select "gpt-4o" → Send a message
- Check Langfuse → See both logged with costs

## What You Now Have

| Capability | Before | After |
|------------|--------|-------|
| Interfaces | 3+ browser tabs | 1 unified UI |
| Context | Lost between tools | Persistent per chat |
| Cost tracking | None | Per-query visibility |
| Model switching | Logout/login | Dropdown selection |
| API access | Multiple endpoints | One endpoint |
| Local/private | None | Ollama ready |

## Using the Unified API

Any code that uses OpenAI SDK now works with all models:

```python
import openai

client = openai.OpenAI(
    base_url="http://localhost:4000/v1",
    api_key="your-litellm-master-key"
)

# Use semantic names
response = client.chat.completions.create(
    model="reasoning",  # → Claude Opus
    messages=[{"role": "user", "content": "Solve this..."}]
)

# Or specific models
response = client.chat.completions.create(
    model="claude-sonnet",
    messages=[{"role": "user", "content": "Draft this..."}]
)
```

## Model Aliases

Use semantic names in your code—swap underlying models without code changes:

| Alias | Current Model | Use For |
|-------|---------------|---------|
| `reasoning` | Claude Opus | Complex analysis, hard problems |
| `default` | Claude Sonnet | Daily driver, most tasks |
| `fast` | Claude Haiku | Quick questions, high volume |
| `vision` | GPT-4o | Image understanding |
| `cheap` | GPT-4o-mini | Bulk processing, low stakes |
| `long-context` | Gemini Pro | Large documents |
| `private` | Local Llama | Sensitive data, offline |

## Next Steps

1. **Add local models**: `docker exec -it ai-ops-local ollama pull llama3.3:70b`
2. **Set budgets**: Configure cost limits in LiteLLM
3. **Build workflows**: Create custom prompts in Open WebUI
4. **Enable RAG**: Upload documents to Qdrant via Open WebUI
5. **Read the framework**: `methodology/AI_OPS_FRAMEWORK.md`

## Troubleshooting

**Services won't start**: Check `docker-compose logs -f`
**Models not appearing**: Verify API keys in `.env`, restart LiteLLM
**Langfuse not tracking**: Confirm keys are set, restart LiteLLM

---

*This is Level 2-3 on the AI Ops Maturity Model. You've organized and systematized. Next: intelligent automation.*
