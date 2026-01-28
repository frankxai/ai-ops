# Oracle OCI GenAI Provider Research

> Enterprise AI on Oracle Cloud Infrastructure

## Overview

Oracle OCI GenAI offers:
- Cohere models (Command A, Embed 4)
- Meta Llama models
- Dedicated AI Clusters for private hosting
- Enterprise security and compliance
- Integration with Oracle ecosystem

---

## Models (January 2026)

### On-Demand (Shared)
| Model | Context | Best For | Cost |
|-------|---------|----------|------|
| **Cohere Command A** | 256K | Enterprise chat, RAG | Pay-per-token |
| **Cohere Embed 4** | 512 | Embeddings | Pay-per-token |
| **Llama 3.3 70B** | 128K | General purpose | Pay-per-token |

### Dedicated AI Clusters (Private)
| Unit Count | Monthly Cost | Use Case |
|------------|--------------|----------|
| 2-5 units | $3-7.5K | Dev/Test |
| 5-15 units | $7.5-22.5K | Production |
| 15-30 units | $22.5-45K | High volume |

---

## Capabilities

### Strengths
- **Enterprise**: SOC 2, HIPAA, FedRAMP
- **Private**: Dedicated clusters = your data isolated
- **Integrated**: Works with Oracle apps (Fusion, EBS)
- **Fine-tuning**: T-Few adapter training
- **Oracle Database 26ai**: Vector search integration

### Limitations
- Smaller model selection than hyperscalers
- Higher cost for small workloads
- OCI-specific (not portable)

---

## API Access

### Authentication
```bash
# OCI CLI config
oci setup config

# Or set environment variables
export OCI_CONFIG_FILE=~/.oci/config
export OCI_CONFIG_PROFILE=DEFAULT
```

### Direct SDK
```python
import oci
from oci.generative_ai_inference import GenerativeAiInferenceClient
from oci.generative_ai_inference.models import (
    CohereLlmInferenceRequest,
    OnDemandServingMode,
    GenerateTextDetails
)

config = oci.config.from_file()
client = GenerativeAiInferenceClient(config)

response = client.generate_text(
    GenerateTextDetails(
        compartment_id=COMPARTMENT_ID,
        serving_mode=OnDemandServingMode(
            model_id="cohere.command-a"
        ),
        inference_request=CohereLlmInferenceRequest(
            prompt="Hello",
            max_tokens=500
        )
    )
)
```

### Via LiteLLM
```yaml
# litellm_config.yaml
model_list:
  - model_name: oci-cohere
    litellm_params:
      model: oci/cohere.command-a
      oci_config_profile: DEFAULT

  - model_name: oci-llama
    litellm_params:
      model: oci/meta.llama-3.3-70b-instruct
      oci_config_profile: DEFAULT
```

---

## Use Cases in AI Ops

| Domain | Model | Use Case |
|--------|-------|----------|
| **Oracle Work** | Cohere Command A | Customer-facing AI |
| **Oracle Work** | Dedicated Cluster | Sensitive workloads |
| **Enterprise** | Llama on OCI | Private, compliant AI |

---

## Dedicated AI Clusters

### When to Use
- Predictable high volume
- Data sovereignty requirements
- Need to fine-tune
- Compliance requirements

### Sizing Guide
```
1 Unit ≈ 1,500 tokens/second
       ≈ 10,000 requests/day

Example:
- 50,000 requests/day → 5 units
- With 2x headroom → 10 units
- Monthly cost → ~$15K
```

### Fine-Tuning
```python
# Upload training data
# Create fine-tuning job
# Deploy custom endpoint
```

---

## OCI GenAI Agents

Built-in agent framework with:
- Knowledge bases (OCI Search, OpenSearch)
- RAG pipelines
- Tool integration
- Session management

```python
from oci.generative_ai_agent_runtime import GenerativeAiAgentRuntimeClient
from oci.generative_ai_agent_runtime.models import ChatDetails

client = GenerativeAiAgentRuntimeClient(config)

response = client.chat(
    agent_endpoint_id="ocid1.genaiagentendpoint.oc1...",
    chat_details=ChatDetails(
        user_message="What are our Q4 results?",
        session_id=session_id
    )
)
```

---

## Integration Notes

### For AI Ops Gateway (Oracle Work Only)

**IMPORTANT:** OCI GenAI should be isolated for Oracle work due to:
- Data residency requirements
- Customer confidentiality
- Compliance needs

```yaml
# Separate LiteLLM instance for Oracle work
# Do NOT mix with personal AI Ops

model_list:
  - model_name: enterprise
    litellm_params:
      model: oci/cohere.command-a
      oci_config_profile: ORACLE_WORK
```

### Hybrid Pattern
```
Personal AI Ops (LiteLLM #1)
├── Claude, GPT, Gemini, Ollama
└── GenCreator, ACOS, Family

Oracle Work AI Ops (LiteLLM #2) ← ISOLATED
├── OCI GenAI only
└── Customer projects
```

---

## Resources

- [OCI GenAI Docs](https://docs.oracle.com/en-us/iaas/Content/generative-ai/home.htm)
- [GenAI Agents](https://docs.oracle.com/en-us/iaas/Content/generative-ai-agents/home.htm)
- [Pricing](https://www.oracle.com/cloud/price-list.html)

---

*Last Updated: January 2026*
