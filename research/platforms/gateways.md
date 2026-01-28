# AI Gateway Platforms Research

> Unified API layers for managing multiple LLM providers

## Overview

An AI Gateway provides a single API endpoint that routes to multiple LLM providers, enabling:
- Unified interface (OpenAI-compatible)
- Cost tracking and budgets
- Rate limiting and caching
- Automatic fallbacks
- Load balancing

---

## Comparison Matrix

| Platform | Self-Hosted | Open Source | Providers | Cost Tracking | Guardrails |
|----------|-------------|-------------|-----------|---------------|------------|
| **LiteLLM** | Yes | Yes (MIT) | 100+ | Yes | Basic |
| **Portkey** | No (SaaS) | No | 100+ | Yes | Yes |
| **OpenRouter** | No (SaaS) | No | 300+ | Yes | No |
| **Cloudflare AI Gateway** | No | No | Limited | Yes | Yes |
| **Kong AI Gateway** | Yes | Partial | Major | Via plugins | Via plugins |
| **Helicone** | Partial | Yes | Major | Yes | No |

---

## LiteLLM (Recommended)

**Why:** Open source, self-hosted, comprehensive provider support.

### Pros
- 100+ model support
- OpenAI-compatible API
- Cost tracking built-in
- Self-hosted = full control
- Active development
- Good documentation

### Cons
- Need to manage infrastructure
- Basic guardrails only
- Learning curve for config

### Key Features
```yaml
# Provider support
- OpenAI, Azure OpenAI
- Anthropic (Claude)
- Google (Gemini, PaLM)
- AWS Bedrock
- Oracle OCI GenAI
- Ollama (local)
- 100+ more

# Routing features
- Fallbacks (if Claude fails → GPT)
- Load balancing
- Rate limiting
- Caching (Redis)
- Cost budgets per user/team
```

### Deployment
```bash
docker run -d \
  -p 4000:4000 \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -e OPENAI_API_KEY=$OPENAI_API_KEY \
  -v ./litellm_config.yaml:/app/config.yaml \
  ghcr.io/berriai/litellm:main-latest \
  --config /app/config.yaml
```

### Links
- [GitHub](https://github.com/BerriAI/litellm)
- [Docs](https://docs.litellm.ai/)

---

## Portkey

**Why:** Full-featured SaaS with guardrails.

### Pros
- Comprehensive feature set
- Built-in guardrails
- Great observability
- Easy setup (SaaS)

### Cons
- Not self-hosted (data goes through their servers)
- Costs scale with usage
- Vendor dependency

### Links
- [Website](https://portkey.ai/)

---

## OpenRouter

**Why:** Largest model selection, simple pricing.

### Pros
- 300+ models
- Simple API
- Good for experimentation

### Cons
- SaaS only
- No self-hosting
- Limited features vs LiteLLM

### Links
- [Website](https://openrouter.ai/)

---

## Recommendation

**For AI Ops:** LiteLLM

Reasons:
1. Self-hosted = data sovereignty
2. Open source = no vendor lock-in
3. Comprehensive = all providers we need
4. Cost tracking = know what we spend
5. Active community = good support

---

## Research TODO

- [ ] Test LiteLLM with all target providers
- [ ] Benchmark latency overhead
- [ ] Test fallback scenarios
- [ ] Evaluate caching effectiveness
- [ ] Compare cost tracking accuracy

---

*Last Updated: January 2026*
