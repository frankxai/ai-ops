# AI Operations Glossary

> **Version:** 1.0.0 | **Last Updated:** 2026-01-29
> **Author:** FrankX Research | **License:** CC BY-SA 4.0
> **Purpose:** Comprehensive terminology reference for AI Operations

---

## Usage Guide

This glossary provides precise definitions for AI Operations terminology. Each entry includes:
- **Definition**: Precise, unambiguous explanation
- **Context**: When and where the term is used
- **Related Terms**: Cross-references to related concepts
- **Example**: Practical illustration

Terms are organized alphabetically with semantic markup for AI consumption.

---

## A

### Agent
**Definition:** An AI system that can autonomously take actions to achieve goals, using tools and making decisions based on observations and reasoning.

**Context:** Orchestration layer; multi-agent systems

**Related Terms:** [Multi-Agent System](#multi-agent-system), [Tool Calling](#tool-calling), [Orchestration](#orchestration)

**Example:** A research agent that searches the web, synthesizes information, and produces a report without human intervention at each step.

```yaml
semantic:
  type: "aiops:Concept"
  broader: "AI System"
  narrower: ["Autonomous Agent", "Reactive Agent", "Cognitive Agent"]
```

---

### Agent Orchestration
**Definition:** The coordination and management of multiple AI agents working together, including task assignment, communication, state management, and result aggregation.

**Context:** Complex AI workflows; multi-agent systems

**Related Terms:** [Agent](#agent), [Multi-Agent System](#multi-agent-system), [LangGraph](#langgraph)

**Example:** An orchestrator that coordinates a research agent, analysis agent, and writing agent to produce a comprehensive report.

---

### AI Gateway
**Definition:** A centralized entry point that routes AI requests to appropriate providers, handling authentication, load balancing, caching, and observability.

**Context:** Gateway layer; infrastructure

**Related Terms:** [LiteLLM](#litellm), [Portkey](#portkey), [Unified API](#unified-api)

**Example:** LiteLLM deployment that provides a single OpenAI-compatible endpoint for Claude, GPT-4, and Gemini.

---

### AI Ops (AI Operations)
**Definition:** The practice of managing, monitoring, and optimizing AI systems in production, encompassing infrastructure, observability, quality assurance, cost management, and governance.

**Context:** Entire AI Operations domain

**Related Terms:** [MLOps](#mlops), [LLMOps](#llmops)

**Example:** An AI Ops practice includes unified gateways, observability platforms, evaluation pipelines, and cost optimization.

```yaml
semantic:
  type: "aiops:Concept"
  definition: "Operational management of AI systems"
  related_to: ["MLOps", "DevOps", "LLMOps"]
```

---

### Alignment
**Definition:** The degree to which an AI system's behavior matches intended goals and values, ensuring it acts in accordance with human intentions.

**Context:** AI safety; governance; AGI preparation

**Related Terms:** [Guardrails](#guardrails), [Constitutional AI](#constitutional-ai)

**Example:** An aligned AI assistant follows user instructions while refusing harmful requests.

---

### API Key
**Definition:** A secret credential used to authenticate requests to an AI provider's API.

**Context:** Security; authentication

**Related Terms:** [Authentication](#authentication), [Rate Limiting](#rate-limiting)

**Example:** `sk-xxx...xxx` for OpenAI, `sk-ant-xxx...xxx` for Anthropic.

---

### Async Processing
**Definition:** Handling AI requests without blocking, allowing multiple requests to be processed concurrently.

**Context:** Performance optimization; scalability

**Related Terms:** [Batching](#batching), [Streaming](#streaming)

**Example:** Processing 100 document summaries concurrently using `asyncio.gather()`.

---

### Authentication
**Definition:** The process of verifying the identity of a user or system attempting to access AI services.

**Context:** Security layer; gateway

**Related Terms:** [API Key](#api-key), [OAuth](#oauth), [JWT](#jwt)

**Example:** Validating a JWT token before allowing access to the AI gateway.

---

## B

### Batching
**Definition:** Grouping multiple AI requests together for more efficient processing, reducing overhead and often cost.

**Context:** Cost optimization; performance

**Related Terms:** [Async Processing](#async-processing), [Cost Optimization](#cost-optimization)

**Example:** Batching 50 embedding requests into a single API call.

---

### Bedrock (AWS)
**Definition:** Amazon Web Services' managed service for accessing foundation models from multiple providers.

**Context:** AI providers; cloud platforms

**Related Terms:** [Azure OpenAI](#azure-openai), [Vertex AI](#vertex-ai)

**Example:** Accessing Claude through AWS Bedrock with AWS credentials.

---

## C

### Caching
**Definition:** Storing AI responses for reuse when identical or similar requests are made, reducing latency and cost.

**Context:** Cost optimization; performance

**Related Terms:** [Semantic Caching](#semantic-caching), [Cost Optimization](#cost-optimization)

**Example:** Returning a cached response for "What is the capital of France?" instead of calling the LLM.

```yaml
semantic:
  type: "aiops:Capability"
  subtypes: ["Exact Match Caching", "Semantic Caching", "Fragment Caching"]
```

---

### Chain
**Definition:** A sequence of LLM calls or operations connected together, where the output of one becomes the input of the next.

**Context:** Orchestration; LangChain

**Related Terms:** [Agent](#agent), [Workflow](#workflow), [LangChain](#langchain)

**Example:** A chain that first summarizes a document, then extracts key entities, then generates questions.

---

### Chunking
**Definition:** Splitting large documents into smaller segments for processing, particularly for embedding and retrieval.

**Context:** RAG; document processing

**Related Terms:** [RAG](#rag), [Embedding](#embedding), [Vector Database](#vector-database)

**Example:** Splitting a 100-page PDF into 500-word chunks with 100-word overlap.

---

### Claude
**Definition:** Anthropic's family of large language models, known for safety, helpfulness, and long context windows.

**Context:** AI providers; models

**Related Terms:** [GPT](#gpt), [Gemini](#gemini), [Anthropic](#anthropic)

**Example:** Claude 3.5 Sonnet, Claude Opus 4

---

### Completion
**Definition:** The generated text output from an LLM in response to a prompt.

**Context:** LLM interaction; API

**Related Terms:** [Prompt](#prompt), [Token](#token), [Chat Completion](#chat-completion)

**Example:** The response "Paris is the capital of France." to the prompt "What is the capital of France?"

---

### Constitutional AI
**Definition:** An AI training approach where the model is given principles to follow, enabling self-correction and alignment.

**Context:** AI safety; alignment

**Related Terms:** [Alignment](#alignment), [Guardrails](#guardrails)

**Example:** Claude's training includes constitutional principles about being helpful, harmless, and honest.

---

### Context Window
**Definition:** The maximum number of tokens an LLM can process in a single request, including both input and output.

**Context:** Model capabilities; limitations

**Related Terms:** [Token](#token), [Long Context](#long-context)

**Example:** GPT-4 Turbo has a 128K context window; Gemini 1.5 Pro has 2M tokens.

---

### Cost Optimization
**Definition:** Strategies and techniques to reduce AI operational costs while maintaining quality, including caching, model selection, and prompt optimization.

**Context:** Cost management; optimization

**Related Terms:** [Caching](#caching), [Model Routing](#model-routing), [Token](#token)

**Example:** Routing simple queries to cheaper models while reserving expensive models for complex tasks.

```yaml
semantic:
  type: "aiops:Pattern"
  techniques:
    - "Model tiering"
    - "Response caching"
    - "Prompt compression"
    - "Request batching"
```

---

### CrewAI
**Definition:** An open-source framework for orchestrating role-playing AI agents that collaborate like a crew with defined roles.

**Context:** Orchestration; multi-agent

**Related Terms:** [LangGraph](#langgraph), [Agent](#agent), [Multi-Agent System](#multi-agent-system)

**Example:** A crew with a researcher agent, analyst agent, and writer agent working together.

---

## D

### Data Loss Prevention (DLP)
**Definition:** Security measures to prevent sensitive data from being exposed through AI systems.

**Context:** Security; privacy; compliance

**Related Terms:** [PII](#pii), [Privacy](#privacy), [Guardrails](#guardrails)

**Example:** Automatically masking credit card numbers before sending to cloud AI.

---

### Dataset
**Definition:** A collection of examples used for evaluating or fine-tuning AI models.

**Context:** Evaluation; training

**Related Terms:** [Evaluation](#evaluation), [Fine-tuning](#fine-tuning)

**Example:** A dataset of 1000 question-answer pairs for testing a customer support bot.

---

## E

### Embedding
**Definition:** A dense vector representation of text (or other data) that captures semantic meaning, enabling similarity search.

**Context:** Memory layer; RAG; vector databases

**Related Terms:** [Vector Database](#vector-database), [Semantic Search](#semantic-search), [RAG](#rag)

**Example:** Converting "The cat sat on the mat" into a 1536-dimensional vector using `text-embedding-3-small`.

```yaml
semantic:
  type: "aiops:Concept"
  uses: ["Similarity Search", "Clustering", "Classification"]
  created_by: ["Embedding Models"]
```

---

### Evaluation
**Definition:** The process of measuring AI output quality against defined criteria, either automatically or with human review.

**Context:** Observability; quality assurance

**Related Terms:** [Metric](#metric), [LLM-as-Judge](#llm-as-judge), [Benchmark](#benchmark)

**Example:** Automatically scoring responses for relevance, accuracy, and helpfulness.

---

## F

### Fallback
**Definition:** An alternative provider or model used when the primary option fails or is unavailable.

**Context:** Gateway; reliability; resilience

**Related Terms:** [Load Balancing](#load-balancing), [Routing](#routing)

**Example:** Automatically switching to GPT-4 when Claude API returns errors.

---

### Few-Shot Learning
**Definition:** Providing a small number of examples in the prompt to guide the model's behavior.

**Context:** Prompting; in-context learning

**Related Terms:** [Zero-Shot](#zero-shot), [Prompt Engineering](#prompt-engineering)

**Example:** Including 3 example classifications before asking the model to classify a new item.

---

### Fine-tuning
**Definition:** Training a pre-trained model on specific data to specialize it for a particular task or domain.

**Context:** Model customization; training

**Related Terms:** [Pre-training](#pre-training), [Transfer Learning](#transfer-learning)

**Example:** Fine-tuning GPT-4 on company-specific customer support conversations.

---

### Function Calling
**Definition:** The ability of an LLM to invoke external functions/tools by generating structured output that specifies the function and arguments.

**Context:** Tool use; agents

**Related Terms:** [Tool Calling](#tool-calling), [Agent](#agent)

**Example:** Model outputs `{"function": "search_web", "arguments": {"query": "AI trends 2026"}}`.

---

## G

### Gateway
**Definition:** See [AI Gateway](#ai-gateway).

---

### Gemini
**Definition:** Google's family of multimodal large language models, known for massive context windows and native multimodality.

**Context:** AI providers; models

**Related Terms:** [Claude](#claude), [GPT](#gpt)

**Example:** Gemini 1.5 Pro with 2M token context window.

---

### GPT (Generative Pre-trained Transformer)
**Definition:** OpenAI's family of large language models, the most widely used LLM series.

**Context:** AI providers; models

**Related Terms:** [Claude](#claude), [Gemini](#gemini), [OpenAI](#openai)

**Example:** GPT-4 Turbo, GPT-4o, o1

---

### Graph Database
**Definition:** A database optimized for storing and querying relationships between entities, used for knowledge graphs.

**Context:** Memory layer; knowledge management

**Related Terms:** [Knowledge Graph](#knowledge-graph), [Neo4j](#neo4j)

**Example:** Neo4j storing relationships between people, companies, and products.

---

### Guardrails
**Definition:** Constraints and safety measures that prevent AI systems from producing harmful, inappropriate, or incorrect outputs.

**Context:** Safety; security; quality

**Related Terms:** [Alignment](#alignment), [Content Filtering](#content-filtering)

**Example:** Blocking requests for harmful content; validating output format.

```yaml
semantic:
  type: "aiops:Concept"
  subtypes:
    - "Input Guardrails"
    - "Output Guardrails"
    - "Behavioral Guardrails"
```

---

## H

### Hallucination
**Definition:** When an AI model generates content that is factually incorrect, nonsensical, or fabricated, presented as if true.

**Context:** Quality; evaluation; RAG

**Related Terms:** [Grounding](#grounding), [RAG](#rag), [Evaluation](#evaluation)

**Example:** An AI claiming a fictional person won a Nobel Prize.

---

### Human-in-the-Loop (HITL)
**Definition:** A workflow pattern where human review or approval is required at certain decision points in an AI system.

**Context:** Orchestration; safety; quality

**Related Terms:** [Agent](#agent), [Workflow](#workflow), [Approval Gate](#approval-gate)

**Example:** Requiring human approval before an AI agent sends an email to customers.

---

## I

### Inference
**Definition:** The process of running a trained model to generate predictions or outputs for new inputs.

**Context:** Model operations; deployment

**Related Terms:** [Training](#training), [Serving](#serving)

**Example:** Sending a prompt to Claude and receiving a response.

---

## J

### JSON Mode
**Definition:** A model capability that ensures output is valid JSON, useful for structured data extraction.

**Context:** Output formatting; function calling

**Related Terms:** [Structured Output](#structured-output), [Function Calling](#function-calling)

**Example:** Setting `response_format: { type: "json_object" }` in the API call.

---

### JWT (JSON Web Token)
**Definition:** A compact, URL-safe token format used for authentication and authorization.

**Context:** Security; authentication

**Related Terms:** [Authentication](#authentication), [OAuth](#oauth)

**Example:** Using JWT tokens to authenticate users to the AI gateway.

---

## K

### Knowledge Graph
**Definition:** A structured representation of knowledge as entities and relationships, enabling complex queries and reasoning.

**Context:** Memory layer; semantic search

**Related Terms:** [Graph Database](#graph-database), [Neo4j](#neo4j), [Entity](#entity)

**Example:** A graph connecting "Claude" (AI model) to "Anthropic" (company) via "created_by" relationship.

---

## L

### LangChain
**Definition:** A popular open-source framework for building LLM applications, providing abstractions for chains, agents, and memory.

**Context:** Orchestration; development frameworks

**Related Terms:** [LlamaIndex](#llamaindex), [Chain](#chain), [Agent](#agent)

**Example:** Building a RAG application using LangChain's document loaders and retrievers.

---

### Langfuse
**Definition:** An open-source LLM engineering platform for tracing, evaluation, prompt management, and cost tracking.

**Context:** Observability; evaluation

**Related Terms:** [LangSmith](#langsmith), [Tracing](#tracing), [Evaluation](#evaluation)

**Example:** Tracking all LLM calls with latency, tokens, and quality scores in Langfuse.

```yaml
semantic:
  type: "aiops:Tool"
  layer: "Observability"
  capabilities:
    - "Tracing"
    - "Evaluation"
    - "Prompt Management"
    - "Cost Tracking"
```

---

### LangGraph
**Definition:** A library for building stateful, multi-actor applications with LLMs, using graph-based workflow definitions.

**Context:** Orchestration; agents; workflows

**Related Terms:** [CrewAI](#crewai), [Agent](#agent), [State Machine](#state-machine)

**Example:** Defining an agent workflow as a directed graph with nodes for different agents and edges for transitions.

---

### LangSmith
**Definition:** LangChain's commercial platform for LLM application development, providing tracing, testing, and monitoring.

**Context:** Observability; evaluation

**Related Terms:** [Langfuse](#langfuse), [LangChain](#langchain)

**Example:** Using LangSmith to debug and evaluate a LangChain application.

---

### Latency
**Definition:** The time elapsed between sending a request and receiving a response, critical for user experience.

**Context:** Performance; monitoring

**Related Terms:** [P50/P95/P99](#p50p95p99), [Time to First Token](#time-to-first-token)

**Example:** P95 latency of 2 seconds for chat completions.

---

### LiteLLM
**Definition:** An open-source unified API gateway that provides an OpenAI-compatible interface to 100+ LLM providers.

**Context:** Gateway layer; infrastructure

**Related Terms:** [Portkey](#portkey), [AI Gateway](#ai-gateway)

**Example:** Calling `litellm.completion(model="claude-3-5-sonnet", messages=[...])`.

```yaml
semantic:
  type: "aiops:Tool"
  layer: "Gateway"
  capabilities:
    - "Unified API"
    - "Load Balancing"
    - "Fallback"
    - "Caching"
```

---

### LLM (Large Language Model)
**Definition:** A neural network trained on vast amounts of text data, capable of understanding and generating human-like text.

**Context:** Core AI technology

**Related Terms:** [GPT](#gpt), [Claude](#claude), [Gemini](#gemini)

**Example:** GPT-4, Claude 3.5 Sonnet, Gemini 1.5 Pro

---

### LLM-as-Judge
**Definition:** Using an LLM to evaluate the quality of outputs from another LLM (or itself), enabling scalable automated evaluation.

**Context:** Evaluation; quality assurance

**Related Terms:** [Evaluation](#evaluation), [Metric](#metric)

**Example:** Using GPT-4 to rate the helpfulness of Claude's responses on a 1-5 scale.

---

### LLMOps
**Definition:** The specialized practice of operating LLM-based systems, a subset of AI Ops focused on language models.

**Context:** Operations; management

**Related Terms:** [AI Ops](#ai-ops-ai-operations), [MLOps](#mlops)

**Example:** Managing prompt versions, evaluating output quality, optimizing inference costs.

---

### LlamaIndex
**Definition:** A framework for building LLM applications, particularly focused on data ingestion and retrieval (RAG).

**Context:** Orchestration; RAG

**Related Terms:** [LangChain](#langchain), [RAG](#rag)

**Example:** Building a document Q&A system using LlamaIndex's index and query engine.

---

### Load Balancing
**Definition:** Distributing AI requests across multiple providers or instances to optimize performance and reliability.

**Context:** Gateway; infrastructure

**Related Terms:** [Fallback](#fallback), [Routing](#routing)

**Example:** Round-robin distribution of requests between two Claude API endpoints.

---

### Local Model
**Definition:** An LLM running on local hardware rather than through a cloud API, enabling privacy and cost control.

**Context:** Privacy; cost; deployment

**Related Terms:** [Ollama](#ollama), [Privacy](#privacy)

**Example:** Running Llama 3.1 locally using Ollama for sensitive data processing.

---

### Long Context
**Definition:** The capability to process very large amounts of text in a single request, enabling whole-document analysis.

**Context:** Model capabilities

**Related Terms:** [Context Window](#context-window), [RAG](#rag)

**Example:** Gemini's 2M token context window can process entire codebases.

---

## M

### MCP (Model Context Protocol)
**Definition:** A protocol for standardizing how AI models interact with external tools and data sources.

**Context:** Integration; tool use; standards

**Related Terms:** [Tool Calling](#tool-calling), [Function Calling](#function-calling)

**Example:** An MCP server that provides file system access to Claude.

---

### Mem0
**Definition:** An open-source memory layer for AI assistants, providing persistent personal memory with graph-based storage.

**Context:** Memory layer; personalization

**Related Terms:** [Memory](#memory), [Personalization](#personalization)

**Example:** Mem0 remembering that a user prefers concise responses.

```yaml
semantic:
  type: "aiops:Tool"
  layer: "Memory"
  capabilities:
    - "Personal Memory"
    - "Graph Memory"
    - "Memory Search"
```

---

### Memory
**Definition:** Persistent storage of context, preferences, and knowledge that allows AI to maintain state across interactions.

**Context:** Memory layer; personalization

**Related Terms:** [Mem0](#mem0), [RAG](#rag), [Knowledge Graph](#knowledge-graph)

**Example:** An AI assistant remembering past conversations and user preferences.

```yaml
semantic:
  type: "aiops:Concept"
  subtypes:
    - "Working Memory"
    - "Short-term Memory"
    - "Long-term Memory"
    - "Semantic Memory"
```

---

### Metric
**Definition:** A quantitative measure of AI system performance, quality, or behavior.

**Context:** Observability; evaluation

**Related Terms:** [KPI](#kpi), [Evaluation](#evaluation), [Latency](#latency)

**Example:** Response latency, token usage, quality score, error rate.

---

### MLOps
**Definition:** The practice of deploying and maintaining machine learning models in production, encompassing CI/CD, monitoring, and governance.

**Context:** Operations; ML systems

**Related Terms:** [AI Ops](#ai-ops-ai-operations), [LLMOps](#llmops)

**Example:** Automating model training, deployment, and monitoring pipelines.

---

### Model Routing
**Definition:** Directing AI requests to different models based on criteria like capability, cost, or latency requirements.

**Context:** Gateway; optimization

**Related Terms:** [Load Balancing](#load-balancing), [Cost Optimization](#cost-optimization)

**Example:** Routing complex queries to Claude Opus and simple ones to Haiku.

---

### Multi-Agent System
**Definition:** An AI architecture where multiple specialized agents collaborate to accomplish complex tasks.

**Context:** Orchestration; advanced patterns

**Related Terms:** [Agent](#agent), [Agent Orchestration](#agent-orchestration), [LangGraph](#langgraph)

**Example:** A system with research, analysis, and writing agents working together.

---

### Multimodal
**Definition:** The capability to process and generate multiple types of content (text, images, audio, video).

**Context:** Model capabilities

**Related Terms:** [Vision](#vision), [Audio](#audio)

**Example:** GPT-4o processing an image and responding with text about its contents.

---

## N

### Neo4j
**Definition:** A popular graph database used for storing knowledge graphs and relationship data.

**Context:** Memory layer; knowledge management

**Related Terms:** [Knowledge Graph](#knowledge-graph), [Graph Database](#graph-database)

**Example:** Storing entity relationships in Neo4j and querying with Cypher.

---

## O

### OAuth
**Definition:** An authorization framework that allows third-party applications to obtain limited access to user accounts.

**Context:** Security; authentication

**Related Terms:** [Authentication](#authentication), [JWT](#jwt)

**Example:** Authenticating users to the AI platform using Google OAuth.

---

### Observability
**Definition:** The ability to understand the internal state of an AI system through its external outputs (logs, metrics, traces).

**Context:** Observability layer; monitoring

**Related Terms:** [Tracing](#tracing), [Logging](#logging), [Metric](#metric)

**Example:** Langfuse providing full visibility into LLM request traces.

```yaml
semantic:
  type: "aiops:Layer"
  components:
    - "Tracing"
    - "Logging"
    - "Metrics"
    - "Evaluation"
    - "Alerting"
```

---

### Ollama
**Definition:** A tool for running open-source LLMs locally with a simple interface.

**Context:** Local models; privacy

**Related Terms:** [Local Model](#local-model), [Llama](#llama)

**Example:** Running `ollama run llama3.1` to interact with Llama locally.

---

### OpenAI
**Definition:** The company that created GPT and ChatGPT, a leading AI provider.

**Context:** AI providers

**Related Terms:** [GPT](#gpt), [ChatGPT](#chatgpt)

**Example:** Using the OpenAI API to access GPT-4.

---

### Orchestration
**Definition:** The coordination of multiple AI components, tools, and services to accomplish complex tasks.

**Context:** Orchestration layer

**Related Terms:** [Agent](#agent), [Chain](#chain), [Workflow](#workflow)

**Example:** LangGraph orchestrating multiple agents with shared state.

---

## P

### P50/P95/P99
**Definition:** Percentile metrics where P50 is median, P95 is the value below which 95% of observations fall, and P99 is 99th percentile.

**Context:** Performance monitoring

**Related Terms:** [Latency](#latency), [Metric](#metric)

**Example:** P95 latency of 2s means 95% of requests complete within 2 seconds.

---

### Personalization
**Definition:** Adapting AI behavior and responses based on individual user preferences, history, and context.

**Context:** Memory; user experience

**Related Terms:** [Memory](#memory), [Mem0](#mem0)

**Example:** An AI that remembers a user prefers brief, technical responses.

---

### PII (Personally Identifiable Information)
**Definition:** Information that can identify an individual, requiring special handling for privacy compliance.

**Context:** Privacy; security; compliance

**Related Terms:** [DLP](#data-loss-prevention-dlp), [Privacy](#privacy)

**Example:** Names, email addresses, phone numbers, social security numbers.

---

### Pinecone
**Definition:** A serverless vector database for storing and searching embeddings at scale.

**Context:** Memory layer; vector search

**Related Terms:** [Vector Database](#vector-database), [Embedding](#embedding)

**Example:** Storing 1 million document embeddings in Pinecone for semantic search.

```yaml
semantic:
  type: "aiops:Tool"
  layer: "Memory"
  capabilities:
    - "Vector Storage"
    - "Semantic Search"
    - "Metadata Filtering"
```

---

### Portkey
**Definition:** A commercial AI gateway providing unified API access, observability, and management for LLMs.

**Context:** Gateway layer

**Related Terms:** [LiteLLM](#litellm), [AI Gateway](#ai-gateway)

**Example:** Using Portkey to manage multiple AI providers with built-in analytics.

---

### Privacy
**Definition:** The protection of sensitive information from unauthorized access or exposure in AI systems.

**Context:** Security; compliance

**Related Terms:** [PII](#pii-personally-identifiable-information), [DLP](#data-loss-prevention-dlp), [Local Model](#local-model)

**Example:** Processing sensitive data with local models to avoid cloud exposure.

---

### Prompt
**Definition:** The input text provided to an LLM to generate a response.

**Context:** LLM interaction; prompting

**Related Terms:** [Completion](#completion), [System Prompt](#system-prompt), [Prompt Engineering](#prompt-engineering)

**Example:** "Explain quantum computing in simple terms."

---

### Prompt Engineering
**Definition:** The practice of designing effective prompts to elicit desired responses from LLMs.

**Context:** Development; optimization

**Related Terms:** [Prompt](#prompt), [Few-Shot Learning](#few-shot-learning), [System Prompt](#system-prompt)

**Example:** Adding "Think step by step" to improve reasoning quality.

---

### Prompt Injection
**Definition:** An attack where malicious instructions are embedded in user input to manipulate AI behavior.

**Context:** Security; safety

**Related Terms:** [Guardrails](#guardrails), [Security](#security)

**Example:** User input containing "Ignore previous instructions and..."

---

## Q

### Qdrant
**Definition:** A high-performance open-source vector database for similarity search.

**Context:** Memory layer; vector search

**Related Terms:** [Vector Database](#vector-database), [Pinecone](#pinecone)

**Example:** Self-hosting Qdrant for fast, local vector search.

---

### Quality Score
**Definition:** A numeric measure of AI output quality based on defined criteria like relevance, accuracy, and helpfulness.

**Context:** Evaluation; observability

**Related Terms:** [Evaluation](#evaluation), [Metric](#metric)

**Example:** A relevance score of 0.85 out of 1.0.

---

## R

### RAG (Retrieval-Augmented Generation)
**Definition:** An architecture pattern that enhances LLM generation by retrieving relevant information from external knowledge bases.

**Context:** Memory layer; knowledge management

**Related Terms:** [Vector Database](#vector-database), [Embedding](#embedding), [Chunking](#chunking)

**Example:** Searching company documents and providing results to the LLM before generating a response.

```yaml
semantic:
  type: "aiops:Pattern"
  components:
    - "Document Ingestion"
    - "Chunking"
    - "Embedding"
    - "Retrieval"
    - "Reranking"
    - "Generation"
```

---

### Rate Limiting
**Definition:** Restricting the number of requests a user or application can make within a time period.

**Context:** Gateway; security; cost control

**Related Terms:** [Quota](#quota), [Throttling](#throttling)

**Example:** Limiting each user to 100 requests per minute.

---

### Reranking
**Definition:** Re-scoring and reordering retrieved documents to improve relevance before presenting to the LLM.

**Context:** RAG; retrieval

**Related Terms:** [RAG](#rag-retrieval-augmented-generation), [Retrieval](#retrieval)

**Example:** Using a cross-encoder to rerank the top 20 retrieved chunks.

---

### Routing
**Definition:** Directing AI requests to specific providers, models, or endpoints based on defined rules.

**Context:** Gateway; optimization

**Related Terms:** [Model Routing](#model-routing), [Load Balancing](#load-balancing)

**Example:** Routing code generation requests to Claude and creative writing to GPT-4.

---

## S

### Semantic Search
**Definition:** Search based on meaning rather than keyword matching, using embeddings to find similar content.

**Context:** Memory layer; RAG

**Related Terms:** [Embedding](#embedding), [Vector Database](#vector-database)

**Example:** Finding documents about "vehicle" when searching for "car".

---

### Semantic Caching
**Definition:** Caching responses based on meaning similarity rather than exact match, improving cache hit rates.

**Context:** Cost optimization; caching

**Related Terms:** [Caching](#caching), [Embedding](#embedding)

**Example:** Returning cached response for "What's Paris's capital?" when asked "Capital of France?"

---

### Span
**Definition:** A unit of work within a trace, representing a specific operation with timing and metadata.

**Context:** Observability; tracing

**Related Terms:** [Tracing](#tracing), [Trace](#trace)

**Example:** A span for the embedding generation step within a RAG pipeline trace.

---

### Streaming
**Definition:** Receiving AI responses incrementally as they are generated, rather than waiting for completion.

**Context:** User experience; performance

**Related Terms:** [Time to First Token](#time-to-first-token)

**Example:** Showing tokens as they stream from Claude for faster perceived response.

---

### System Prompt
**Definition:** Instructions provided to set the AI's behavior, persona, and constraints for a conversation.

**Context:** Prompting; configuration

**Related Terms:** [Prompt](#prompt), [Prompt Engineering](#prompt-engineering)

**Example:** "You are a helpful customer support agent. Be concise and professional."

---

## T

### Temperature
**Definition:** A parameter controlling randomness in LLM output, where lower values are more deterministic.

**Context:** LLM configuration; generation

**Related Terms:** [Top-P](#top-p), [Sampling](#sampling)

**Example:** Temperature 0 for factual responses, 0.7 for creative writing.

---

### Time to First Token (TTFT)
**Definition:** The latency between sending a request and receiving the first token of the response.

**Context:** Performance; user experience

**Related Terms:** [Latency](#latency), [Streaming](#streaming)

**Example:** TTFT of 200ms for a streaming response.

---

### Token
**Definition:** The basic unit of text that LLMs process, typically representing a word or part of a word.

**Context:** LLM fundamentals; cost

**Related Terms:** [Context Window](#context-window), [Tokenizer](#tokenizer)

**Example:** "Hello, world!" is approximately 4 tokens.

---

### Tool Calling
**Definition:** The capability of an LLM to invoke external tools or functions to accomplish tasks.

**Context:** Agents; integration

**Related Terms:** [Function Calling](#function-calling), [MCP](#mcp-model-context-protocol), [Agent](#agent)

**Example:** An LLM calling a weather API to answer "What's the weather in Paris?"

---

### Trace
**Definition:** A record of a request's journey through an AI system, including all operations, timing, and metadata.

**Context:** Observability

**Related Terms:** [Span](#span), [Tracing](#tracing)

**Example:** A trace showing the RAG pipeline from query to response.

---

### Tracing
**Definition:** The practice of recording detailed information about AI system operations for debugging and analysis.

**Context:** Observability

**Related Terms:** [Trace](#trace), [Span](#span), [Langfuse](#langfuse)

**Example:** Tracing all LLM calls with input, output, latency, and cost.

---

## U

### Unified API
**Definition:** A single API interface that provides access to multiple AI providers with a consistent format.

**Context:** Gateway layer

**Related Terms:** [AI Gateway](#ai-gateway), [LiteLLM](#litellm)

**Example:** Using OpenAI-compatible format to access Claude, GPT-4, and Gemini.

---

## V

### Vector Database
**Definition:** A database optimized for storing and searching high-dimensional vectors (embeddings).

**Context:** Memory layer; RAG

**Related Terms:** [Embedding](#embedding), [Pinecone](#pinecone), [Qdrant](#qdrant), [Weaviate](#weaviate)

**Example:** Storing 1 million document embeddings for semantic search.

```yaml
semantic:
  type: "aiops:Concept"
  examples:
    - "Pinecone"
    - "Weaviate"
    - "Qdrant"
    - "Chroma"
    - "pgvector"
```

---

### Vertex AI
**Definition:** Google Cloud's AI platform for building and deploying ML models, including Gemini access.

**Context:** AI providers; cloud platforms

**Related Terms:** [Bedrock](#bedrock-aws), [Azure OpenAI](#azure-openai)

**Example:** Accessing Gemini Pro through Vertex AI.

---

### Vision
**Definition:** The capability of an LLM to understand and process images as input.

**Context:** Multimodal; model capabilities

**Related Terms:** [Multimodal](#multimodal)

**Example:** GPT-4V analyzing a screenshot and describing its contents.

---

## W

### Weaviate
**Definition:** An open-source vector database with built-in hybrid search combining vectors and keywords.

**Context:** Memory layer; vector search

**Related Terms:** [Vector Database](#vector-database), [Pinecone](#pinecone)

**Example:** Using Weaviate for combined semantic and keyword search.

---

### Workflow
**Definition:** A defined sequence of steps or operations that an AI system follows to complete a task.

**Context:** Orchestration

**Related Terms:** [Chain](#chain), [Agent](#agent), [Orchestration](#orchestration)

**Example:** A document processing workflow: ingest, chunk, embed, index, query.

---

## Z

### Zero-Shot
**Definition:** Using an LLM to perform a task without providing any examples, relying only on instructions.

**Context:** Prompting

**Related Terms:** [Few-Shot Learning](#few-shot-learning), [Prompt Engineering](#prompt-engineering)

**Example:** "Classify this review as positive or negative: [review]"

---

## Acronyms Quick Reference

| Acronym | Full Form | Reference |
|---------|-----------|-----------|
| AGI | Artificial General Intelligence | General AI with human-level capabilities |
| API | Application Programming Interface | Interface for software communication |
| CAG | Context-Augmented Generation | Future pattern using large context windows |
| DLP | Data Loss Prevention | [Link](#data-loss-prevention-dlp) |
| HITL | Human-in-the-Loop | [Link](#human-in-the-loop-hitl) |
| JWT | JSON Web Token | [Link](#jwt-json-web-token) |
| KPI | Key Performance Indicator | Critical business metrics |
| LLM | Large Language Model | [Link](#llm-large-language-model) |
| MCP | Model Context Protocol | [Link](#mcp-model-context-protocol) |
| ML | Machine Learning | Subset of AI using statistical learning |
| PII | Personally Identifiable Information | [Link](#pii-personally-identifiable-information) |
| RAG | Retrieval-Augmented Generation | [Link](#rag-retrieval-augmented-generation) |
| TTFT | Time to First Token | [Link](#time-to-first-token-ttft) |

---

## Index by Category

### Infrastructure & Gateway
- [AI Gateway](#ai-gateway)
- [Authentication](#authentication)
- [Caching](#caching)
- [Fallback](#fallback)
- [LiteLLM](#litellm)
- [Load Balancing](#load-balancing)
- [Portkey](#portkey)
- [Rate Limiting](#rate-limiting)
- [Routing](#routing)
- [Unified API](#unified-api)

### Observability
- [Evaluation](#evaluation)
- [Langfuse](#langfuse)
- [LangSmith](#langsmith)
- [Latency](#latency)
- [Logging](#logging)
- [Metric](#metric)
- [Observability](#observability)
- [Quality Score](#quality-score)
- [Span](#span)
- [Trace](#trace)
- [Tracing](#tracing)

### Memory & Knowledge
- [Chunking](#chunking)
- [Embedding](#embedding)
- [Knowledge Graph](#knowledge-graph)
- [Mem0](#mem0)
- [Memory](#memory)
- [Neo4j](#neo4j)
- [Pinecone](#pinecone)
- [Qdrant](#qdrant)
- [RAG](#rag-retrieval-augmented-generation)
- [Semantic Search](#semantic-search)
- [Vector Database](#vector-database)
- [Weaviate](#weaviate)

### Orchestration & Agents
- [Agent](#agent)
- [Agent Orchestration](#agent-orchestration)
- [Chain](#chain)
- [CrewAI](#crewai)
- [Function Calling](#function-calling)
- [Human-in-the-Loop](#human-in-the-loop-hitl)
- [LangChain](#langchain)
- [LangGraph](#langgraph)
- [LlamaIndex](#llamaindex)
- [MCP](#mcp-model-context-protocol)
- [Multi-Agent System](#multi-agent-system)
- [Orchestration](#orchestration)
- [Tool Calling](#tool-calling)
- [Workflow](#workflow)

### Security & Privacy
- [Alignment](#alignment)
- [Constitutional AI](#constitutional-ai)
- [DLP](#data-loss-prevention-dlp)
- [Guardrails](#guardrails)
- [PII](#pii-personally-identifiable-information)
- [Privacy](#privacy)
- [Prompt Injection](#prompt-injection)

### Models & Providers
- [Anthropic](#anthropic)
- [Bedrock](#bedrock-aws)
- [Claude](#claude)
- [Gemini](#gemini)
- [GPT](#gpt-generative-pre-trained-transformer)
- [LLM](#llm-large-language-model)
- [Local Model](#local-model)
- [Ollama](#ollama)
- [OpenAI](#openai)
- [Vertex AI](#vertex-ai)

### Prompting & Generation
- [Completion](#completion)
- [Context Window](#context-window)
- [Few-Shot Learning](#few-shot-learning)
- [Hallucination](#hallucination)
- [Prompt](#prompt)
- [Prompt Engineering](#prompt-engineering)
- [Streaming](#streaming)
- [System Prompt](#system-prompt)
- [Temperature](#temperature)
- [Token](#token)
- [Zero-Shot](#zero-shot)

---

**End of Glossary**

---

*This glossary is part of the AI Operations Knowledge Base.*
*For the complete knowledge base, see:*
- [AI_OPS_MASTER_ARCHITECTURE.md](./AI_OPS_MASTER_ARCHITECTURE.md)
- [AI_OPS_KNOWLEDGE_GRAPH.md](./AI_OPS_KNOWLEDGE_GRAPH.md)
- [AI_OPS_IMPLEMENTATION_PATTERNS.md](./AI_OPS_IMPLEMENTATION_PATTERNS.md)
- [AI_OPS_MATURITY_MODEL.md](./AI_OPS_MATURITY_MODEL.md)
- [AI_OPS_FUTURE_VISION.md](./AI_OPS_FUTURE_VISION.md)
