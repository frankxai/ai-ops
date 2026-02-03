# AI Operations Research Papers

> **Curated Academic Literature on AI Agents, Memory Systems, and LLM Operations**
> *The definitive reading list for AI Ops researchers and practitioners*

**Last Updated**: 2026-02-03 | **Papers**: 40+ | **Categories**: 8

---

## Featured Papers (2025-2026)

### Memory Systems for AI Agents

| Paper | Authors | Date | Key Contribution |
|-------|---------|------|------------------|
| **[Memory in the Age of AI Agents](https://arxiv.org/abs/2512.13564)** | Liu et al. | Dec 2025 | Comprehensive survey; new taxonomy beyond long/short-term |
| **[A-MEM: Agentic Memory for LLM Agents](https://arxiv.org/abs/2502.12110)** | NeurIPS 2025 | Feb 2025 | Zettelkasten-inspired interconnected knowledge networks |
| **[Memory-R1](https://arxiv.org/abs/2508.19828)** | Aug 2025 | Reinforcement learning for memory management (ADD, UPDATE, DELETE) |
| **[Mem0: Building Production-Ready AI Agents](https://arxiv.org/abs/2504.19413)** | Mem0 Team | Apr 2025 | 26% accuracy boost, 90% token savings |
| **[General Agentic Memory (GAM)](https://arxiv.org/abs/2511.18423)** | Nov 2025 | JIT memory compilation, Memorizer + Researcher architecture |
| **[Memoria: Scalable Agentic Memory](https://arxiv.org/abs/2512.12686)** | Dec 2025 | Weighted knowledge graphs for personalization |
| **[Zep: Temporal Knowledge Graph Architecture](https://arxiv.org/abs/2501.13956)** | Jan 2026 | Graphiti framework for dynamic relationships |

### Multi-Agent Systems

| Paper | Authors | Date | Key Contribution |
|-------|---------|------|------------------|
| **[Large Language Model Agents: Comprehensive Survey](https://www.preprints.org/manuscript/202512.2119)** | Dec 2025 | Architectures, capabilities, applications |
| **[MAGMA: Multi-Graph Agentic Memory](https://arxiv.org/)** | Jan 2026 | Graph-based multi-agent coordination |
| **[EverMemOS: Self-Organizing Memory OS](https://arxiv.org/)** | Jan 2026 | Operating system for agent memory |
| **[MemRL: Self-Evolving Agents](https://arxiv.org/)** | Jan 2026 | Runtime reinforcement learning |

### Alignment & Safety

| Paper | Authors | Date | Key Contribution |
|-------|---------|------|------------------|
| **[Anthropic-OpenAI Alignment Evaluation](https://alignment.anthropic.com/2025/openai-findings/)** | Anthropic/OpenAI | 2025 | Joint misalignment evaluation exercise |
| **[Constitutional AI](https://arxiv.org/abs/2212.08073)** | Anthropic | 2022 | Foundational safety methodology |
| **[Sleeper Agents](https://arxiv.org/abs/2401.05566)** | Anthropic | Jan 2024 | Deceptive behavior in trained models |

---

## By Topic

### 1. LLM Operations & Infrastructure

#### Gateways & Routing
- **LiteLLM Documentation** - [docs.litellm.ai](https://docs.litellm.ai/) - Unified API implementation
- **RouteLLM** - [GitHub](https://github.com/lm-sys/RouteLLM) - Cost-effective model routing (85% savings)
- **Semantic Router** - [GitHub](https://github.com/aurelio-labs/semantic-router) - Intent-based routing

#### Observability
- **Langfuse** - [langfuse.com](https://langfuse.com/) - Open-source LLM engineering platform
- **OpenTelemetry for LLMs** - Standardized tracing protocols
- **Helicone** - [helicone.ai](https://www.helicone.ai/) - Production observability

### 2. Agent Orchestration

#### Frameworks
| Framework | Paper/Docs | Architecture |
|-----------|------------|--------------|
| **LangGraph** | [langchain-ai.github.io/langgraph](https://langchain-ai.github.io/langgraph/) | Graph-based state machines |
| **CrewAI** | [docs.crewai.com](https://docs.crewai.com/) | Role-based agent teams |
| **AutoGen** | [microsoft/autogen](https://github.com/microsoft/autogen) | Conversational agents |
| **DSPy** | [dspy.ai](https://dspy.ai/) | Programmatic prompt optimization |

#### Research Papers
- **[ReAct: Synergizing Reasoning and Acting](https://arxiv.org/abs/2210.03629)** - Yao et al. - Reasoning traces + actions
- **[Reflexion](https://arxiv.org/abs/2303.11366)** - Shinn et al. - Self-reflection for agents
- **[Tree of Thoughts](https://arxiv.org/abs/2305.10601)** - Yao et al. - Deliberate problem solving

### 3. Knowledge Graphs & RAG

#### Temporal Knowledge
- **[Graphiti: Building Temporal Knowledge Graphs](https://neo4j.com/blog/developer/graphiti-knowledge-graph-memory/)** - Zep/Neo4j - Episode → Entity → Relationship layers
- **[Hipporag](https://arxiv.org/abs/2405.14831)** - Neurobiologically inspired RAG

#### Vector Databases
| System | Paper/Docs | Specialty |
|--------|------------|-----------|
| **Qdrant** | [qdrant.tech](https://qdrant.tech/) | High-performance similarity |
| **Weaviate** | [weaviate.io](https://weaviate.io/) | Hybrid vector-keyword |
| **Chroma** | [trychroma.com](https://www.trychroma.com/) | Developer-friendly |
| **Pinecone** | [pinecone.io](https://www.pinecone.io/) | Managed scale |

### 4. Guardrails & Safety

#### Implementations
- **[NeMo Guardrails](https://github.com/NVIDIA-NeMo/Guardrails)** - NVIDIA - Programmable safety rails
- **[Guardrails AI](https://www.guardrailsai.com/)** - Input/output validation
- **[LLM Guard](https://github.com/protectai/llm-guard)** - Security toolkit

#### Research
- **[LlamaGuard](https://arxiv.org/abs/2312.06674)** - Meta - Safety classifier
- **[Purple Llama CyberSecEval](https://arxiv.org/abs/2312.04724)** - Meta - Security benchmarks

### 5. Evaluation & Benchmarks

| Benchmark | Focus | Paper |
|-----------|-------|-------|
| **MMLU** | General knowledge | [arxiv.org/abs/2009.03300](https://arxiv.org/abs/2009.03300) |
| **HumanEval** | Coding | [arxiv.org/abs/2107.03374](https://arxiv.org/abs/2107.03374) |
| **GAIA** | Real-world assistant tasks | [arxiv.org/abs/2311.12983](https://arxiv.org/abs/2311.12983) |
| **AgentBench** | Agent capabilities | [arxiv.org/abs/2308.03688](https://arxiv.org/abs/2308.03688) |
| **SWE-bench** | Software engineering | [swe-bench.com](https://www.swe-bench.com/) |

### 6. Foundation Models

#### From AI Labs
| Lab | Key Papers (2024-2026) |
|-----|------------------------|
| **Anthropic** | Claude 3 Technical Report, Constitutional AI, Sleeper Agents, Model Spec |
| **OpenAI** | GPT-4 Technical Report, o1 System Card, Preparedness Framework |
| **Google DeepMind** | Gemini Technical Report, Genie 3 (World Models), AlphaFold 3 |
| **Meta** | Llama 3 Paper, Code Llama, Purple Llama |

### 7. AGI & Future Systems

- **[Levels of AGI](https://arxiv.org/abs/2311.02462)** - DeepMind - Framework for measuring progress
- **[Sparks of AGI](https://arxiv.org/abs/2303.12712)** - Microsoft - GPT-4 analysis
- **[AI 2027](https://situational-awareness.ai/)** - Leopold Aschenbrenner - Scaling projections

### 8. Industry Reports

| Report | Organization | Focus |
|--------|--------------|-------|
| **State of AI 2025** | Retool | Developer survey |
| **AI Index Report** | Stanford HAI | Comprehensive metrics |
| **Big Ideas 2026** | a16z | Venture perspective |
| **Signals 2026** | O'Reilly | Technology trends |

---

## Reading Paths

### For AI Ops Practitioners
1. **Start**: LiteLLM + Langfuse documentation
2. **Memory**: Mem0 paper → A-MEM → Memory-R1
3. **Agents**: ReAct → LangGraph docs → CrewAI docs
4. **Safety**: NeMo Guardrails → LlamaGuard

### For Researchers
1. **Surveys**: "Memory in the Age of AI Agents" → "LLM Agents Comprehensive Survey"
2. **Architectures**: A-MEM (Zettelkasten) → GAM (JIT) → Graphiti (temporal)
3. **Evaluation**: GAIA → AgentBench → SWE-bench

### For Enterprise Leaders
1. **Strategy**: Big Ideas 2026 → State of AI → AI Index
2. **Safety**: Anthropic-OpenAI Alignment → Constitutional AI
3. **Implementation**: LiteLLM → Langfuse → NeMo Guardrails

---

## Paper Repositories

| Repository | URL | Focus |
|------------|-----|-------|
| **Agent-Memory-Paper-List** | [GitHub](https://github.com/Shichun-Liu/Agent-Memory-Paper-List) | Memory systems |
| **LLM-Agent-Memory-Survey** | [GitHub](https://github.com/nuster1128/LLM_Agent_Memory_Survey) | ACM survey papers |
| **Awesome-LLMOps** | [GitHub](https://github.com/tensorchord/Awesome-LLMOps) | Operations tools |
| **Awesome-Agents** | [GitHub](https://github.com/kyrolabs/awesome-agents) | Agent ecosystem |

---

## Citation Format

When citing papers from this collection:

```bibtex
@article{mem0-2025,
  title={Building Production-Ready AI Agents with Intelligent Memory},
  author={Mem0 Team},
  journal={arXiv preprint arXiv:2504.19413},
  year={2025}
}
```

---

## Contributing

This paper collection is actively maintained. To suggest additions:
1. Papers must be peer-reviewed or from recognized AI labs
2. Include arXiv link or official publication
3. Brief description of key contribution

---

*Curated by FrankX Research Council*
*For: frankx.ai/research/ai-ops/papers*
