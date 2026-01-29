# Essential GitHub Repositories for AI Ops

> Curated list of must-have repos for building production AI systems
> **Last Updated**: 2026-01-29

---

## Tier 1: Core Infrastructure

### Gateway & Routing
| Repository | Stars | What It Does |
|------------|-------|--------------|
| [BerriAI/litellm](https://github.com/BerriAI/litellm) | 15k+ | Unified API for 100+ LLM providers |
| [portkey-ai/gateway](https://github.com/portkey-ai/gateway) | 6k+ | AI gateway with guardrails |

### Observability
| Repository | Stars | What It Does |
|------------|-------|--------------|
| [langfuse/langfuse](https://github.com/langfuse/langfuse) | 10k+ | LLM observability, evals, prompt management |
| [Helicone/helicone](https://github.com/Helicone/helicone) | 2k+ | LLM observability platform |

### Chat Interfaces
| Repository | Stars | What It Does |
|------------|-------|--------------|
| [open-webui/open-webui](https://github.com/open-webui/open-webui) | 50k+ | Self-hosted ChatGPT-style UI |
| [danny-avila/LibreChat](https://github.com/danny-avila/LibreChat) | 20k+ | Multi-provider chat with enterprise auth |
| [lobehub/lobe-chat](https://github.com/lobehub/lobe-chat) | 50k+ | Most polished UI, extensible |
| [Mintplex-Labs/anything-llm](https://github.com/Mintplex-Labs/anything-llm) | 30k+ | Document Q&A, RAG-focused |

---

## Tier 2: Agent Orchestration

### Frameworks
| Repository | Stars | Best For |
|------------|-------|----------|
| [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) | 8k+ | Complex stateful workflows |
| [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) | 25k+ | Team-based agent coordination |
| [microsoft/autogen](https://github.com/microsoft/autogen) | 35k+ | Multi-agent conversations |
| [langgenius/dify](https://github.com/langgenius/dify) | 60k+ | No-code agent builder |

### Workflow Automation
| Repository | Stars | What It Does |
|------------|-------|--------------|
| [n8n-io/n8n](https://github.com/n8n-io/n8n) | 50k+ | Workflow automation with AI nodes |
| [huginn/huginn](https://github.com/huginn/huginn) | 45k+ | Self-hosted IFTTT alternative |

---

## Tier 3: Memory & Context

| Repository | Stars | What It Does |
|------------|-------|--------------|
| [mem0ai/mem0](https://github.com/mem0ai/mem0) | 25k+ | Universal memory layer for agents |
| [qdrant/qdrant](https://github.com/qdrant/qdrant) | 22k+ | High-performance vector database |
| [chroma-core/chroma](https://github.com/chroma-core/chroma) | 18k+ | Embedding database for AI |

---

## Tier 4: Safety & Guardrails

| Repository | Stars | What It Does |
|------------|-------|--------------|
| [NVIDIA-NeMo/Guardrails](https://github.com/NVIDIA-NeMo/Guardrails) | 4k+ | Programmable LLM guardrails |
| [guardrails-ai/guardrails](https://github.com/guardrails-ai/guardrails) | 4k+ | Input/output validation |
| [protectai/llm-guard](https://github.com/protectai/llm-guard) | 2k+ | Security toolkit for LLMs |

---

## Tier 5: Local Models

| Repository | Stars | What It Does |
|------------|-------|--------------|
| [ollama/ollama](https://github.com/ollama/ollama) | 110k+ | Run LLMs locally |
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | 75k+ | Efficient local LLM inference |
| [janhq/jan](https://github.com/janhq/jan) | 25k+ | Privacy-first local AI assistant |

---

## Tier 6: Knowledge & Learning

### Curated Lists
| Repository | What It Covers |
|------------|----------------|
| [tensorchord/Awesome-LLMOps](https://github.com/tensorchord/Awesome-LLMOps) | Comprehensive LLMOps tooling |
| [kyrolabs/awesome-agents](https://github.com/kyrolabs/awesome-agents) | AI agent ecosystem |
| [OpsPAI/awesome-AIOps](https://github.com/OpsPAI/awesome-AIOps) | Academic AIOps research |

### Learning Resources
| Repository | What It Teaches |
|------------|-----------------|
| [AI-Maker-Space/LLM-Ops-Cohort-1](https://github.com/AI-Maker-Space/LLM-Ops-Cohort-1) | End-to-end LLMOps |
| [ksm26/LLMOps](https://github.com/ksm26/LLMOps) | Fine-tuning and deployment |

---

## Quick Start Combinations

### Minimal Stack (Personal Use)
```
Ollama + Open WebUI
```
- Free, local, private
- Works offline

### Standard Stack (Creator/Professional)
```
LiteLLM + Langfuse + Open WebUI + Qdrant
```
- Multi-provider access
- Cost tracking
- RAG capabilities

### Enterprise Stack
```
LiteLLM + Langfuse + LibreChat + Qdrant + NeMo Guardrails + Mem0
```
- Full observability
- Enterprise auth
- Safety guardrails
- Persistent memory

### Agent Development Stack
```
LangGraph/CrewAI + Mem0 + Langfuse + n8n
```
- Complex agent workflows
- Memory persistence
- Workflow automation

---

## Installation Commands

### Core Stack
```bash
# Clone essential repos
git clone https://github.com/BerriAI/litellm
git clone https://github.com/langfuse/langfuse
git clone https://github.com/open-webui/open-webui
git clone https://github.com/qdrant/qdrant

# Or use Docker (recommended)
# See: ai-ops/implementations/gateway/docker-compose.yml
```

### Agent Frameworks
```bash
pip install langgraph
pip install crewai
pip install mem0ai
pip install guardrails-ai
```

### Local Models
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama3.3:70b
ollama pull mistral:7b
```

---

*Curated by FrankX Research Council • Updated 2026-01-29*
