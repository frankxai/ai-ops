# AI Ops - Claude Code Context

## Mission

Research, design, and implement a personal AI operations platform that provides:
- **Unified AI Gateway** - Single API for all providers
- **Observability** - Cost tracking, tracing, analytics
- **Guardrails** - Safety, PII detection, content filtering
- **Prompt Management** - Versioning, A/B testing, templates
- **Memory Systems** - Long-term agent memory
- **Evaluation** - Automated quality scoring

## Current Phase: Research

Focus on documenting and evaluating:
- AI providers (Claude, GPT, Gemini, Ollama, OCI)
- Gateway platforms (LiteLLM, Portkey, OpenRouter)
- Observability tools (Langfuse, Helicone, Fiddler)
- Guardrails solutions (NeMo, Guardrails AI)
- Memory systems (Mem0, custom)

## Key Principles

1. **Self-Hosted First** - Own the infrastructure
2. **Open Source Preferred** - Avoid vendor lock-in
3. **Privacy by Design** - Family data stays private
4. **Cost Awareness** - Track every API dollar
5. **Domain Isolation** - Work vs Personal vs Family never mix

## Commands

```
/research {topic}     - Research an AI Ops topic
/evaluate {tool}      - Evaluate a specific tool
/compare {a} vs {b}   - Compare two options
/implement {layer}    - Start implementing a layer
```

## Directory Guide

| Path | Purpose |
|------|---------|
| `research/providers/` | AI provider documentation |
| `research/platforms/` | Platform comparisons |
| `research/patterns/` | Architecture patterns |
| `research/evaluations/` | Tool evaluations |
| `docs/` | System documentation |
| `implementations/` | Actual code/configs |
| `config/` | Configuration files |

## Related Projects

- **agentic-creator-os** - Consumes AI Ops
- **FrankX** - Consumes AI Ops
- **oci-ai-architects** - Oracle-specific AI work

---

*AI Ops Research Hub*
