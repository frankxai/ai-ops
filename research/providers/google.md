# Google (Gemini) Provider Research

> Gemini models for multimodal AI

## Overview

Google's Gemini offers:
- Strong multimodal capabilities (text, image, video, audio)
- Long context (up to 2M tokens)
- Competitive pricing
- Google Search grounding
- Image generation (Gemini 2.0)

---

## Models (January 2026)

| Model | Context | Best For | Cost (Input/Output per 1M) |
|-------|---------|----------|---------------------------|
| **Gemini 2.5 Pro** | 1M | Complex tasks, long context | $1.25-2.50 / $5-10 |
| **Gemini 2.5 Flash** | 1M | Fast, efficient | $0.075 / $0.30 |
| **Gemini 2.0 Flash** | 1M | Multimodal, image gen | $0.10 / $0.40 |

---

## Capabilities

### Strengths
- **Multimodal**: Native image, video, audio understanding
- **Long Context**: Up to 2M tokens
- **Grounding**: Google Search integration
- **Image Generation**: Built into 2.0 models
- **Competitive Pricing**: Often cheaper than competitors

### Limitations
- API can be less stable
- Some features preview-only
- Less coding-focused than Claude
- Availability varies by region

---

## API Access

### Authentication
```bash
export GOOGLE_API_KEY="..."
# Or use service account for Vertex AI
```

### Direct API (Google AI Studio)
```python
import google.generativeai as genai

genai.configure(api_key=os.environ["GOOGLE_API_KEY"])

model = genai.GenerativeModel("gemini-2.5-pro")
response = model.generate_content("Hello")
```

### Via LiteLLM
```yaml
# litellm_config.yaml
model_list:
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-2.5-pro
      api_key: os.environ/GOOGLE_API_KEY

  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-2.5-flash
      api_key: os.environ/GOOGLE_API_KEY
```

---

## Use Cases in AI Ops

| Domain | Model | Use Case |
|--------|-------|----------|
| **GenCreator** | 2.5 Pro | Long document analysis |
| **GenCreator** | 2.0 Flash | Image generation |
| **ACOS** | 2.5 Flash | Fast multimodal agents |
| **Family** | 2.5 Flash | Video/image understanding |

---

## Cost Optimization

### Strategies
1. **Flash models first** - Much cheaper than Pro
2. **Use long context wisely** - Charges per token
3. **Leverage grounding** - Better than separate search

---

## Features

### Image Generation (Gemini 2.0)
```python
response = model.generate_content(
    "Generate an image of a sunset over mountains",
    generation_config={"response_mime_type": "image/png"}
)
```

### Grounding with Google Search
```python
response = model.generate_content(
    "What's the latest news about AI?",
    tools=[{"google_search_retrieval": {}}]
)
```

### Video Understanding
```python
video_file = genai.upload_file("video.mp4")
response = model.generate_content([
    "Summarize this video",
    video_file
])
```

### Long Context (2M tokens)
- Can process entire codebases
- Full book analysis
- Large document sets

---

## Integration Notes

### For AI Ops Gateway
```yaml
model_list:
  # Multimodal workhorse
  - model_name: gemini
    litellm_params:
      model: gemini/gemini-2.5-flash
      api_key: os.environ/GOOGLE_API_KEY

  # Long context / complex
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-2.5-pro
      api_key: os.environ/GOOGLE_API_KEY

  # Image generation
  - model_name: gemini-image
    litellm_params:
      model: gemini/gemini-2.0-flash
      api_key: os.environ/GOOGLE_API_KEY
```

---

## Vertex AI vs Google AI Studio

| Feature | Google AI Studio | Vertex AI |
|---------|------------------|-----------|
| Setup | Simple API key | GCP project + auth |
| Pricing | Pay-as-you-go | Enterprise pricing |
| SLA | None | Enterprise SLA |
| Features | Consumer | Full enterprise |

**Recommendation:** Start with Google AI Studio, move to Vertex for production.

---

## Resources

- [Google AI Studio](https://aistudio.google.com/)
- [Gemini API Docs](https://ai.google.dev/docs)
- [Vertex AI](https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/gemini)

---

*Last Updated: January 2026*
