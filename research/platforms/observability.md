# LLM Observability Platforms Research

> Tools for tracing, monitoring, and understanding LLM behavior

## Overview

LLM Observability provides visibility into:
- Token usage and costs
- Latency and performance
- Request/response tracing
- Quality and evaluation metrics
- Prompt versioning

---

## Comparison Matrix

| Platform | Self-Hosted | Open Source | Tracing | Cost | Evaluation | Prompts |
|----------|-------------|-------------|---------|------|------------|---------|
| **Langfuse** | Yes | Yes (MIT) | Yes | Yes | Yes | Yes |
| **Helicone** | Partial | Yes | Yes | Yes | Basic | No |
| **Fiddler** | No | No | Yes | Yes | Yes | Basic |
| **Arize Phoenix** | Yes | Yes | Yes | Basic | Yes | No |
| **Weights & Biases** | No | No | Yes | Basic | Yes | Yes |
| **LangSmith** | No | No | Yes | Yes | Yes | Yes |

---

## Langfuse (Recommended)

**Why:** Open source, self-hosted, comprehensive features.

### Pros
- Full tracing (spans, generations, scores)
- Cost tracking by model, user, feature
- Prompt management with versioning
- Evaluation pipelines
- Self-hosted = data stays local
- Great integration with LiteLLM

### Cons
- Requires infrastructure
- Some features still maturing
- Smaller community than commercial options

### Key Features
```
Tracing:
  - Every LLM call tracked
  - Nested spans for complex flows
  - Latency breakdown
  - Token counts

Cost Analytics:
  - Total spend
  - Spend by model
  - Spend by user
  - Budget alerts

Evaluation:
  - LLM-as-judge
  - Human feedback
  - Custom scorers
  - Dataset management

Prompts:
  - Version control
  - A/B testing
  - Environment-based deployment
```

### Integration with LiteLLM
```yaml
# litellm_config.yaml
litellm_settings:
  success_callback: ["langfuse"]
  failure_callback: ["langfuse"]

environment_variables:
  LANGFUSE_PUBLIC_KEY: "pk-..."
  LANGFUSE_SECRET_KEY: "sk-..."
  LANGFUSE_HOST: "http://langfuse:3000"
```

### Deployment
```yaml
# docker-compose.yml
services:
  langfuse:
    image: langfuse/langfuse:latest
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://...
      - NEXTAUTH_SECRET=...
      - SALT=...
```

### Links
- [GitHub](https://github.com/langfuse/langfuse)
- [Docs](https://langfuse.com/docs)
- [Self-hosting Guide](https://langfuse.com/docs/deployment/self-host)

---

## Helicone

**Why:** Simple, proxy-based observability.

### Pros
- Easy setup (just change base URL)
- Good cost tracking
- Open source core

### Cons
- Less comprehensive than Langfuse
- Evaluation features limited
- No prompt management

### Links
- [Website](https://helicone.ai/)

---

## Arize Phoenix

**Why:** Strong on evaluation and traces.

### Pros
- Excellent trace visualization
- Good for debugging
- Open source

### Cons
- Cost tracking limited
- No prompt management
- Focused on ML evaluation

### Links
- [GitHub](https://github.com/Arize-ai/phoenix)

---

## Recommendation

**For AI Ops:** Langfuse

Reasons:
1. Self-hosted = privacy
2. Comprehensive = tracing + cost + prompts + eval
3. LiteLLM integration = perfect stack combo
4. Open source = no lock-in
5. Active development

---

## The Open Source LLMOps Stack

```
LiteLLM (Gateway) + Langfuse (Observability)
```

This combination is well-documented and commonly recommended:
- [oss-llmops-stack.com](https://oss-llmops-stack.com/)

---

## Research TODO

- [ ] Deploy Langfuse locally
- [ ] Test tracing with multi-model flows
- [ ] Evaluate cost accuracy
- [ ] Build evaluation pipeline
- [ ] Test prompt versioning workflow

---

*Last Updated: January 2026*
