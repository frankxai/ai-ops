# Guardrails Research

> Ensuring safe, reliable, and compliant AI outputs

## Overview

Guardrails protect against:
- **Harmful content** - Toxicity, hate speech, violence
- **Privacy violations** - PII leakage, data exposure
- **Prompt injection** - Malicious input attacks
- **Hallucinations** - Factually incorrect outputs
- **Policy violations** - Brand, legal, compliance

---

## Types of Guardrails

### Input Guardrails (Pre-processing)
- Prompt injection detection
- PII detection and masking
- Topic restrictions
- Language filtering

### Output Guardrails (Post-processing)
- Toxicity filtering
- PII scrubbing
- Factuality checking
- Format validation
- Policy compliance

---

## Comparison Matrix

| Platform | Self-Hosted | Open Source | Input | Output | PII | Toxicity |
|----------|-------------|-------------|-------|--------|-----|----------|
| **NeMo Guardrails** | Yes | Yes (Apache) | Yes | Yes | Via integration | Yes |
| **Guardrails AI** | Yes | Yes | Yes | Yes | Yes | Yes |
| **LlamaGuard** | Yes | Yes | Yes | Yes | No | Yes |
| **Lakera** | No | No | Yes | Yes | Yes | Yes |
| **Rebuff** | Yes | Yes | Yes | No | No | No |

---

## NeMo Guardrails (NVIDIA)

**Why:** Most comprehensive open source option.

### Pros
- Programmable rails (Colang language)
- Flexible architecture
- Good documentation
- NVIDIA backing

### Cons
- Learning curve (Colang)
- Can add latency
- Requires careful tuning

### Key Features
```
Input Rails:
  - Jailbreak detection
  - Topic control
  - Input validation

Output Rails:
  - Content moderation
  - Fact checking
  - Response filtering

Dialog Rails:
  - Conversation flow control
  - Multi-turn context
```

### Example Config
```yaml
# config.yml
models:
  - type: main
    engine: openai
    model: gpt-4

rails:
  input:
    flows:
      - self check input
  output:
    flows:
      - self check output
```

### Links
- [GitHub](https://github.com/NVIDIA/NeMo-Guardrails)
- [Docs](https://docs.nvidia.com/nemo/guardrails/)

---

## Guardrails AI

**Why:** Python-first, validation-focused.

### Pros
- Pythonic interface
- Structured output validation
- Good for data extraction
- Easy to integrate

### Cons
- Less comprehensive than NeMo
- Focused on validation vs safety

### Example
```python
from guardrails import Guard
from guardrails.hub import ToxicLanguage

guard = Guard().use(ToxicLanguage(on_fail="filter"))

result = guard(
    messages=[{"role": "user", "content": prompt}],
    model="gpt-4"
)
```

### Links
- [GitHub](https://github.com/guardrails-ai/guardrails)
- [Docs](https://docs.guardrails.ai/)

---

## LlamaGuard (Meta)

**Why:** Purpose-built safety classifier.

### Pros
- Specifically trained for safety
- Fast inference
- Open weights

### Cons
- Classification only (not filtering)
- Needs additional logic
- Limited customization

### Links
- [Meta AI](https://ai.meta.com/research/publications/llama-guard-llm-based-input-output-safeguard-for-human-ai-conversations/)

---

## PII Detection Options

| Tool | Method | Self-Hosted |
|------|--------|-------------|
| **Presidio** (Microsoft) | NER + regex | Yes |
| **Phileas** | NER | Yes |
| **AWS Comprehend** | API | No |
| **spaCy NER** | Custom model | Yes |

### Presidio Example
```python
from presidio_analyzer import AnalyzerEngine
from presidio_anonymizer import AnonymizerEngine

analyzer = AnalyzerEngine()
anonymizer = AnonymizerEngine()

results = analyzer.analyze(text=text, language='en')
anonymized = anonymizer.anonymize(text=text, analyzer_results=results)
```

---

## Recommendation

**For AI Ops:**

1. **Safety/Toxicity:** NeMo Guardrails or LlamaGuard
2. **PII:** Presidio (self-hosted, comprehensive)
3. **Validation:** Guardrails AI for structured outputs

### Implementation Strategy
```
Input → Presidio (PII mask) → NeMo (safety check) → LLM
                                                      │
Output ← Presidio (PII scrub) ← NeMo (safety check) ←─┘
```

---

## Research TODO

- [ ] Test NeMo Guardrails latency impact
- [ ] Evaluate Presidio accuracy for PII
- [ ] Build custom topic rails for family safety
- [ ] Test prompt injection detection
- [ ] Benchmark guardrails overhead

---

*Last Updated: January 2026*
