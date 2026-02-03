# AI Operations Implementation Patterns

> **Version:** 1.0.0 | **Last Updated:** 2026-01-29
> **Author:** FrankX Research | **License:** CC BY-SA 4.0
> **Purpose:** Deep implementation patterns with production code examples

---

## Table of Contents

1. [Pattern 1: Unified Gateway](#pattern-1-unified-gateway)
2. [Pattern 2: Observability-First](#pattern-2-observability-first)
3. [Pattern 3: Memory-Augmented Agents](#pattern-3-memory-augmented-agents)
4. [Pattern 4: Multi-Agent Orchestration](#pattern-4-multi-agent-orchestration)
5. [Pattern 5: Privacy-Preserving AI](#pattern-5-privacy-preserving-ai)
6. [Pattern 6: Cost-Optimized Operations](#pattern-6-cost-optimized-operations)
7. [Anti-Patterns](#anti-patterns)

---

## Pattern 1: Unified Gateway

### Problem Statement

Organizations use multiple AI providers (Anthropic, OpenAI, Google, etc.) with:
- Different API formats
- Different authentication methods
- No unified cost tracking
- No centralized control

### Solution Architecture

```
UNIFIED GATEWAY PATTERN
=======================

┌─────────────────────────────────────────────────────────────┐
│                     APPLICATION LAYER                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │  App 1  │  │  App 2  │  │  App 3  │  │  App N  │       │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘       │
│       │            │            │            │              │
│       └────────────┴─────┬──────┴────────────┘              │
│                          │                                   │
│                          ▼                                   │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                   UNIFIED GATEWAY                      │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  OpenAI-Compatible API Endpoint                 │  │  │
│  │  │  POST /v1/chat/completions                      │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                          │                             │  │
│  │  ┌───────────┬───────────┼───────────┬───────────┐    │  │
│  │  │           │           │           │           │    │  │
│  │  ▼           ▼           ▼           ▼           ▼    │  │
│  │ ┌────┐    ┌────┐    ┌────┐    ┌────┐    ┌────┐       │  │
│  │ │Auth│    │Route│   │Cache│   │Rate │   │Log │       │  │
│  │ │    │    │     │   │     │   │Limit│   │    │       │  │
│  │ └────┘    └────┘    └────┘    └────┘    └────┘       │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                   │
└──────────────────────────┼───────────────────────────────────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌───────────┐   ┌───────────┐   ┌───────────┐
    │ Anthropic │   │  OpenAI   │   │  Google   │
    │  Claude   │   │  GPT-4    │   │  Gemini   │
    └───────────┘   └───────────┘   └───────────┘
```

### Implementation with LiteLLM

```python
"""
Unified Gateway Implementation using LiteLLM

This implementation provides:
1. Single endpoint for all AI providers
2. Intelligent routing based on model capabilities
3. Automatic fallback on failures
4. Cost tracking and rate limiting
5. Response caching
"""

import os
from typing import Optional, Dict, Any, List
from litellm import completion, acompletion
from litellm import Router
import litellm

# Enable detailed logging for observability
litellm.set_verbose = True


class UnifiedAIGateway:
    """
    Production-ready unified gateway for AI providers.

    Features:
    - Multi-provider support with single API
    - Intelligent routing with fallbacks
    - Cost tracking
    - Rate limiting
    - Response caching
    """

    def __init__(self):
        self._setup_router()
        self._setup_callbacks()

    def _setup_router(self):
        """Configure the LiteLLM router with multiple providers."""

        # Define model deployments with fallbacks
        model_list = [
            # Primary: Claude for complex reasoning
            {
                "model_name": "claude-primary",
                "litellm_params": {
                    "model": "claude-3-5-sonnet-20241022",
                    "api_key": os.getenv("ANTHROPIC_API_KEY"),
                },
                "model_info": {
                    "max_tokens": 8192,
                    "input_cost_per_token": 0.000003,
                    "output_cost_per_token": 0.000015,
                }
            },
            # Fallback: GPT-4 if Claude unavailable
            {
                "model_name": "claude-primary",  # Same name = fallback
                "litellm_params": {
                    "model": "gpt-4-turbo",
                    "api_key": os.getenv("OPENAI_API_KEY"),
                },
                "model_info": {
                    "max_tokens": 4096,
                    "input_cost_per_token": 0.00001,
                    "output_cost_per_token": 0.00003,
                }
            },
            # Fast model for simple tasks
            {
                "model_name": "fast-model",
                "litellm_params": {
                    "model": "claude-3-5-haiku-20241022",
                    "api_key": os.getenv("ANTHROPIC_API_KEY"),
                },
                "model_info": {
                    "max_tokens": 8192,
                    "input_cost_per_token": 0.0000008,
                    "output_cost_per_token": 0.000004,
                }
            },
            # Local model for privacy-sensitive or high-volume
            {
                "model_name": "local-model",
                "litellm_params": {
                    "model": "ollama/llama3.1",
                    "api_base": "http://localhost:11434",
                },
                "model_info": {
                    "max_tokens": 8192,
                    "input_cost_per_token": 0,
                    "output_cost_per_token": 0,
                }
            },
        ]

        # Router configuration
        router_config = {
            "model_list": model_list,
            "routing_strategy": "usage-based-routing",  # or "latency-based-routing"
            "num_retries": 3,
            "timeout": 60,
            "fallbacks": [
                {"claude-primary": ["fast-model", "local-model"]},
            ],
            "set_verbose": True,
            "retry_after": 5,
            "allowed_fails": 2,
            "cooldown_time": 60,
        }

        self.router = Router(**router_config)

    def _setup_callbacks(self):
        """Configure callbacks for observability."""

        # Custom callback for logging and metrics
        class MetricsCallback(litellm.Callback):
            def log_success_event(self, kwargs, response_obj, start_time, end_time):
                # Log to your observability system
                print(f"[SUCCESS] Model: {kwargs.get('model')}")
                print(f"  Tokens: {response_obj.usage.total_tokens}")
                print(f"  Latency: {end_time - start_time}s")

            def log_failure_event(self, kwargs, response_obj, start_time, end_time):
                print(f"[FAILURE] Model: {kwargs.get('model')}")
                print(f"  Error: {response_obj}")

        litellm.callbacks = [MetricsCallback()]

    async def chat(
        self,
        messages: List[Dict[str, str]],
        model: str = "claude-primary",
        temperature: float = 0.7,
        max_tokens: int = 4096,
        metadata: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Send a chat completion request through the unified gateway.

        Args:
            messages: List of message dictionaries with 'role' and 'content'
            model: Model name (mapped to actual provider/model)
            temperature: Sampling temperature
            max_tokens: Maximum tokens in response
            metadata: Additional metadata for tracking

        Returns:
            Standardized response dictionary
        """

        try:
            response = await self.router.acompletion(
                model=model,
                messages=messages,
                temperature=temperature,
                max_tokens=max_tokens,
                metadata=metadata or {},
            )

            return {
                "success": True,
                "content": response.choices[0].message.content,
                "model": response.model,
                "usage": {
                    "prompt_tokens": response.usage.prompt_tokens,
                    "completion_tokens": response.usage.completion_tokens,
                    "total_tokens": response.usage.total_tokens,
                },
                "metadata": {
                    "response_id": response.id,
                    "created": response.created,
                }
            }

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
                "model": model,
            }

    def select_model_for_task(self, task_type: str) -> str:
        """
        Intelligent model selection based on task characteristics.

        This implements the cost-optimization pattern by routing
        simple tasks to cheaper/faster models.
        """

        task_to_model = {
            # Complex reasoning tasks -> best model
            "analysis": "claude-primary",
            "coding": "claude-primary",
            "research": "claude-primary",

            # Simple tasks -> fast model
            "summarization": "fast-model",
            "translation": "fast-model",
            "classification": "fast-model",

            # Privacy-sensitive -> local model
            "pii_processing": "local-model",
            "confidential": "local-model",

            # Default
            "general": "fast-model",
        }

        return task_to_model.get(task_type, "fast-model")


# Usage Example
async def main():
    gateway = UnifiedAIGateway()

    # Automatic model selection based on task
    task_type = "analysis"
    model = gateway.select_model_for_task(task_type)

    response = await gateway.chat(
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Analyze the key trends in AI operations."}
        ],
        model=model,
        metadata={"task_type": task_type, "user_id": "user_123"}
    )

    print(response)


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

### Configuration Example

```yaml
# config/gateway.yaml
# Production gateway configuration

gateway:
  name: "ai-ops-gateway"
  version: "1.0.0"

models:
  - name: "claude-primary"
    provider: "anthropic"
    model_id: "claude-3-5-sonnet-20241022"
    max_tokens: 8192
    cost:
      input: 0.000003
      output: 0.000015
    capabilities:
      - "reasoning"
      - "coding"
      - "analysis"
      - "vision"

  - name: "gpt-4-fallback"
    provider: "openai"
    model_id: "gpt-4-turbo"
    max_tokens: 4096
    cost:
      input: 0.00001
      output: 0.00003

  - name: "fast-model"
    provider: "anthropic"
    model_id: "claude-3-5-haiku-20241022"
    max_tokens: 8192
    cost:
      input: 0.0000008
      output: 0.000004
    capabilities:
      - "quick-tasks"
      - "classification"

routing:
  strategy: "cost-optimized"
  fallback_chain:
    - "claude-primary"
    - "gpt-4-fallback"
    - "fast-model"

rate_limits:
  global:
    requests_per_minute: 1000
    tokens_per_minute: 100000
  per_user:
    requests_per_minute: 60
    tokens_per_minute: 10000

caching:
  enabled: true
  strategy: "semantic"
  ttl_seconds: 3600
  similarity_threshold: 0.95

observability:
  tracing:
    enabled: true
    endpoint: "http://langfuse:3000"
  metrics:
    enabled: true
    endpoint: "http://prometheus:9090"
```

---

## Pattern 2: Observability-First

### Problem Statement

AI systems are black boxes without proper instrumentation:
- Cannot debug failures
- Cannot measure quality
- Cannot optimize costs
- Cannot demonstrate compliance

### Solution Architecture

```
OBSERVABILITY-FIRST PATTERN
===========================

┌─────────────────────────────────────────────────────────────┐
│                     AI APPLICATION                          │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              INSTRUMENTATION LAYER                     │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  @observe decorator / context managers          │  │  │
│  │  │  Automatic capture: prompts, completions,       │  │  │
│  │  │  tokens, latency, errors, metadata              │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              COLLECTION LAYER                          │  │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐         │  │
│  │  │  Traces   │  │  Metrics  │  │   Logs    │         │  │
│  │  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘         │  │
│  │        │              │              │                │  │
│  │        └──────────────┼──────────────┘                │  │
│  │                       │                                │  │
│  └───────────────────────┼───────────────────────────────┘  │
│                          │                                   │
└──────────────────────────┼───────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                  OBSERVABILITY PLATFORM                     │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                     LANGFUSE                           │ │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐     │ │
│  │  │ Traces  │ │ Prompts │ │  Evals  │ │Datasets │     │ │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘     │ │
│  └───────────────────────────────────────────────────────┘ │
│                          │                                  │
│  ┌───────────────────────▼───────────────────────────────┐ │
│  │                  DASHBOARDS & ALERTS                   │ │
│  │  - Real-time cost tracking                             │ │
│  │  - Quality metrics over time                           │ │
│  │  - Error rate monitoring                               │ │
│  │  - Latency percentiles                                 │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Implementation with Langfuse

```python
"""
Observability-First Implementation using Langfuse

This implementation provides:
1. Automatic tracing of all LLM calls
2. Hierarchical trace structure (sessions, traces, spans)
3. Custom evaluation pipelines
4. Cost tracking and attribution
5. Prompt versioning and A/B testing
"""

import os
from typing import Optional, Dict, Any, List, Callable
from functools import wraps
import time

from langfuse import Langfuse
from langfuse.decorators import observe, langfuse_context
from langfuse.openai import openai  # Drop-in replacement for OpenAI SDK
import litellm


class ObservableAISystem:
    """
    AI system with built-in observability.

    All LLM interactions are automatically traced, including:
    - Input/output tokens
    - Latency
    - Cost
    - Custom metadata
    - Evaluation scores
    """

    def __init__(self):
        # Initialize Langfuse client
        self.langfuse = Langfuse(
            public_key=os.getenv("LANGFUSE_PUBLIC_KEY"),
            secret_key=os.getenv("LANGFUSE_SECRET_KEY"),
            host=os.getenv("LANGFUSE_HOST", "https://cloud.langfuse.com"),
        )

        # Configure LiteLLM to use Langfuse callback
        litellm.success_callback = ["langfuse"]
        litellm.failure_callback = ["langfuse"]

    @observe(as_type="generation")
    async def generate(
        self,
        prompt: str,
        system_prompt: Optional[str] = None,
        model: str = "claude-3-5-sonnet-20241022",
        temperature: float = 0.7,
        metadata: Optional[Dict[str, Any]] = None,
    ) -> str:
        """
        Generate a response with full observability.

        The @observe decorator automatically captures:
        - Input prompt
        - Output completion
        - Token usage
        - Latency
        - Model information
        """

        messages = []
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        messages.append({"role": "user", "content": prompt})

        # Add custom metadata to the trace
        langfuse_context.update_current_observation(
            metadata=metadata or {},
            tags=["production", model],
        )

        response = await litellm.acompletion(
            model=model,
            messages=messages,
            temperature=temperature,
        )

        return response.choices[0].message.content

    @observe(as_type="trace")
    async def process_document(
        self,
        document: str,
        task: str = "summarize",
        session_id: Optional[str] = None,
    ) -> Dict[str, Any]:
        """
        Process a document through multiple AI steps.

        This creates a hierarchical trace with multiple spans:
        - Main trace for the entire operation
        - Nested spans for each processing step
        """

        # Set session for user-level tracking
        if session_id:
            langfuse_context.update_current_trace(session_id=session_id)

        results = {}

        # Step 1: Extract key information
        with langfuse_context.span(name="extract_info") as span:
            extraction = await self.generate(
                prompt=f"Extract key information from this document:\n\n{document}",
                model="claude-3-5-haiku-20241022",  # Fast model for extraction
            )
            results["extraction"] = extraction
            span.update(metadata={"step": "extraction", "doc_length": len(document)})

        # Step 2: Main task (summarize, analyze, etc.)
        with langfuse_context.span(name=f"task_{task}") as span:
            if task == "summarize":
                output = await self.generate(
                    prompt=f"Based on this information:\n{extraction}\n\nProvide a concise summary.",
                    model="claude-3-5-sonnet-20241022",
                )
            elif task == "analyze":
                output = await self.generate(
                    prompt=f"Based on this information:\n{extraction}\n\nProvide detailed analysis.",
                    model="claude-3-5-sonnet-20241022",
                )
            else:
                output = extraction

            results["output"] = output
            span.update(metadata={"task": task})

        # Step 3: Quality check
        with langfuse_context.span(name="quality_check") as span:
            quality_score = await self._evaluate_quality(document, results["output"])
            results["quality_score"] = quality_score
            span.update(metadata={"quality_score": quality_score})

            # Log score to Langfuse for tracking
            langfuse_context.score_current_observation(
                name="quality",
                value=quality_score,
                comment="Automated quality evaluation",
            )

        return results

    async def _evaluate_quality(self, input_text: str, output_text: str) -> float:
        """
        Automated quality evaluation using LLM-as-judge.
        """

        evaluation_prompt = f"""
        Evaluate the quality of this AI output on a scale of 0-1.

        Original Input:
        {input_text[:1000]}...

        AI Output:
        {output_text}

        Score criteria:
        - Relevance (0-0.3): Does the output address the input?
        - Accuracy (0-0.3): Is the information correct?
        - Completeness (0-0.2): Is the output comprehensive?
        - Clarity (0-0.2): Is the output well-written?

        Respond with only a number between 0 and 1.
        """

        score_response = await self.generate(
            prompt=evaluation_prompt,
            model="claude-3-5-haiku-20241022",
            temperature=0,
        )

        try:
            return float(score_response.strip())
        except ValueError:
            return 0.5  # Default if parsing fails


class EvaluationPipeline:
    """
    Automated evaluation pipeline for AI outputs.

    Supports:
    - LLM-as-judge evaluations
    - Heuristic evaluations
    - Human feedback integration
    - Dataset-based testing
    """

    def __init__(self, langfuse_client: Langfuse):
        self.langfuse = langfuse_client

    async def evaluate_trace(
        self,
        trace_id: str,
        evaluators: List[Callable],
    ) -> Dict[str, float]:
        """
        Run multiple evaluators on a trace.
        """

        # Fetch trace data
        trace = self.langfuse.get_trace(trace_id)

        scores = {}
        for evaluator in evaluators:
            score_name = evaluator.__name__
            score_value = await evaluator(trace)
            scores[score_name] = score_value

            # Log score to Langfuse
            self.langfuse.score(
                trace_id=trace_id,
                name=score_name,
                value=score_value,
            )

        return scores

    @staticmethod
    async def relevance_evaluator(trace) -> float:
        """Evaluate relevance of output to input."""
        # Implementation using LLM or heuristics
        return 0.85

    @staticmethod
    async def hallucination_evaluator(trace) -> float:
        """Detect potential hallucinations."""
        # Implementation using fact-checking
        return 0.95

    @staticmethod
    async def safety_evaluator(trace) -> float:
        """Check for safety issues in output."""
        # Implementation using content filters
        return 1.0


# Metrics Dashboard Configuration
DASHBOARD_CONFIG = """
# Grafana Dashboard Configuration for AI Ops Observability

dashboards:
  - name: "AI Operations Overview"
    panels:
      - title: "Request Volume"
        type: "timeseries"
        query: "sum(rate(ai_requests_total[5m]))"

      - title: "Latency P50/P95/P99"
        type: "timeseries"
        queries:
          - "histogram_quantile(0.50, ai_request_duration_seconds)"
          - "histogram_quantile(0.95, ai_request_duration_seconds)"
          - "histogram_quantile(0.99, ai_request_duration_seconds)"

      - title: "Token Usage"
        type: "stat"
        query: "sum(increase(ai_tokens_total[24h]))"

      - title: "Cost (Last 24h)"
        type: "stat"
        query: "sum(increase(ai_cost_usd_total[24h]))"

      - title: "Error Rate"
        type: "gauge"
        query: "sum(rate(ai_errors_total[5m])) / sum(rate(ai_requests_total[5m]))"

      - title: "Quality Score Distribution"
        type: "histogram"
        query: "ai_quality_score_bucket"

      - title: "Model Usage Breakdown"
        type: "piechart"
        query: "sum by (model) (ai_requests_total)"

alerts:
  - name: "High Error Rate"
    condition: "error_rate > 0.05"
    severity: "critical"

  - name: "Cost Spike"
    condition: "cost_increase_1h > 200%"
    severity: "warning"

  - name: "Quality Degradation"
    condition: "avg_quality_score < 0.7"
    severity: "warning"
"""

# Usage Example
async def main():
    system = ObservableAISystem()

    # Process a document with full observability
    result = await system.process_document(
        document="Long document content here...",
        task="summarize",
        session_id="user_123_session_456",
    )

    print(f"Output: {result['output']}")
    print(f"Quality Score: {result['quality_score']}")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## Pattern 3: Memory-Augmented Agents

### Problem Statement

AI assistants lack persistent memory:
- Forget user preferences between sessions
- Cannot learn from past interactions
- No continuity in long-running tasks

### Solution Architecture

```
MEMORY-AUGMENTED PATTERN
========================

┌─────────────────────────────────────────────────────────────┐
│                     USER INTERACTION                        │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              MEMORY RETRIEVAL LAYER                    │  │
│  │                                                        │  │
│  │  1. Extract entities/topics from user message         │  │
│  │  2. Query relevant memories                           │  │
│  │  3. Rank by relevance and recency                     │  │
│  │  4. Inject into context                               │  │
│  │                                                        │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              LLM GENERATION                            │  │
│  │                                                        │  │
│  │  System Prompt + Retrieved Memories + User Message    │  │
│  │                          │                             │  │
│  │                          ▼                             │  │
│  │                    AI Response                         │  │
│  │                                                        │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              MEMORY EXTRACTION LAYER                   │  │
│  │                                                        │  │
│  │  1. Analyze conversation for memorable facts          │  │
│  │  2. Extract entities, preferences, decisions          │  │
│  │  3. Deduplicate against existing memories             │  │
│  │  4. Store with embeddings and metadata                │  │
│  │                                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                   │
└──────────────────────────┼───────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    MEMORY STORE                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   MEM0 / Custom                      │   │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐        │   │
│  │  │  Vector   │  │   Graph   │  │ Key-Value │        │   │
│  │  │  Store    │  │   Store   │  │   Store   │        │   │
│  │  └───────────┘  └───────────┘  └───────────┘        │   │
│  │                                                      │   │
│  │  Memory Types:                                       │   │
│  │  - User preferences                                  │   │
│  │  - Conversation history                              │   │
│  │  - Learned facts                                     │   │
│  │  - Task context                                      │   │
│  │  - Entity relationships                              │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Implementation with Mem0

```python
"""
Memory-Augmented Agent Implementation using Mem0

This implementation provides:
1. Automatic memory extraction from conversations
2. Relevant memory retrieval
3. User-specific memory namespaces
4. Memory types (facts, preferences, context)
5. Memory decay and consolidation
"""

import os
from typing import Optional, Dict, Any, List
from mem0 import Memory
import litellm


class MemoryAugmentedAgent:
    """
    AI agent with persistent memory capabilities.

    Memory hierarchy:
    1. Working memory: Current conversation context
    2. Short-term memory: Recent interactions (hours)
    3. Long-term memory: Persistent facts and preferences
    4. Semantic memory: Conceptual knowledge
    """

    def __init__(self, user_id: str):
        self.user_id = user_id

        # Initialize Mem0 with configuration
        self.memory = Memory.from_config({
            "llm": {
                "provider": "anthropic",
                "config": {
                    "model": "claude-3-5-haiku-20241022",
                    "api_key": os.getenv("ANTHROPIC_API_KEY"),
                }
            },
            "embedder": {
                "provider": "openai",
                "config": {
                    "model": "text-embedding-3-small",
                    "api_key": os.getenv("OPENAI_API_KEY"),
                }
            },
            "vector_store": {
                "provider": "qdrant",
                "config": {
                    "host": os.getenv("QDRANT_HOST", "localhost"),
                    "port": 6333,
                    "collection_name": f"memories_{user_id}",
                }
            },
            "version": "v1.1",  # Enable graph memory
        })

        # Conversation history for working memory
        self.conversation_history: List[Dict[str, str]] = []

    async def chat(
        self,
        message: str,
        session_id: Optional[str] = None,
    ) -> str:
        """
        Chat with memory-augmented context.

        Process:
        1. Retrieve relevant memories
        2. Build context-aware prompt
        3. Generate response
        4. Extract and store new memories
        """

        # Step 1: Retrieve relevant memories
        relevant_memories = await self._retrieve_memories(message)

        # Step 2: Build system prompt with memories
        system_prompt = self._build_system_prompt(relevant_memories)

        # Step 3: Add to conversation history
        self.conversation_history.append({
            "role": "user",
            "content": message,
        })

        # Step 4: Generate response
        messages = [
            {"role": "system", "content": system_prompt},
            *self.conversation_history,
        ]

        response = await litellm.acompletion(
            model="claude-3-5-sonnet-20241022",
            messages=messages,
            temperature=0.7,
        )

        assistant_message = response.choices[0].message.content

        # Step 5: Add response to history
        self.conversation_history.append({
            "role": "assistant",
            "content": assistant_message,
        })

        # Step 6: Extract and store new memories (async)
        await self._extract_and_store_memories(
            user_message=message,
            assistant_message=assistant_message,
        )

        return assistant_message

    async def _retrieve_memories(
        self,
        query: str,
        limit: int = 10,
    ) -> List[Dict[str, Any]]:
        """
        Retrieve memories relevant to the current query.
        """

        # Search memories using semantic similarity
        search_results = self.memory.search(
            query=query,
            user_id=self.user_id,
            limit=limit,
        )

        # Format memories for context
        memories = []
        for result in search_results.get("results", []):
            memories.append({
                "content": result["memory"],
                "relevance": result.get("score", 0),
                "created_at": result.get("created_at"),
                "category": result.get("metadata", {}).get("category", "general"),
            })

        return memories

    def _build_system_prompt(
        self,
        memories: List[Dict[str, Any]],
    ) -> str:
        """
        Build a system prompt that incorporates relevant memories.
        """

        base_prompt = """You are a helpful AI assistant with persistent memory.
You remember important information from past conversations and use it to provide
personalized, contextual responses.

Guidelines:
- Reference relevant memories naturally, don't list them
- If a memory contradicts new information, ask for clarification
- Respect user preferences stored in memory
- Be consistent with past interactions
"""

        if memories:
            memory_section = "\n\nRelevant memories from past interactions:\n"
            for i, memory in enumerate(memories, 1):
                memory_section += f"{i}. {memory['content']}\n"
            base_prompt += memory_section

        return base_prompt

    async def _extract_and_store_memories(
        self,
        user_message: str,
        assistant_message: str,
    ) -> None:
        """
        Extract memorable information and store it.

        Memory types:
        - Facts: Objective information about the user
        - Preferences: User likes, dislikes, preferences
        - Context: Ongoing task or project context
        - Relationships: People, places, things mentioned
        """

        # Prepare the conversation for memory extraction
        conversation = f"User: {user_message}\nAssistant: {assistant_message}"

        # Mem0 automatically extracts and stores memories
        self.memory.add(
            messages=[
                {"role": "user", "content": user_message},
                {"role": "assistant", "content": assistant_message},
            ],
            user_id=self.user_id,
            metadata={"source": "conversation"},
        )

    async def get_user_summary(self) -> str:
        """
        Generate a summary of what the agent knows about the user.
        """

        all_memories = self.memory.get_all(user_id=self.user_id)

        if not all_memories.get("results"):
            return "I don't have any stored memories about you yet."

        memory_text = "\n".join([m["memory"] for m in all_memories["results"]])

        summary_prompt = f"""
        Based on these stored memories about the user, provide a brief summary
        of what you know about them:

        {memory_text}

        Write a natural summary, as if describing the user to yourself.
        """

        response = await litellm.acompletion(
            model="claude-3-5-haiku-20241022",
            messages=[{"role": "user", "content": summary_prompt}],
            temperature=0,
        )

        return response.choices[0].message.content

    def clear_session(self) -> None:
        """Clear working memory (conversation history) for new session."""
        self.conversation_history = []

    async def forget(self, memory_id: str) -> bool:
        """Allow user to delete specific memories."""
        try:
            self.memory.delete(memory_id=memory_id)
            return True
        except Exception:
            return False


class MemoryTypes:
    """
    Structured memory type definitions for categorization.
    """

    FACT = "fact"  # Objective information
    PREFERENCE = "preference"  # User preferences
    CONTEXT = "context"  # Task/project context
    RELATIONSHIP = "relationship"  # Entity relationships
    EVENT = "event"  # Past events/occurrences
    INSTRUCTION = "instruction"  # User-provided instructions


# Custom memory extraction prompt
MEMORY_EXTRACTION_PROMPT = """
Analyze this conversation and extract memorable information.

Conversation:
{conversation}

Extract any of the following types of information:
1. FACTS: Objective information about the user (name, occupation, location, etc.)
2. PREFERENCES: Things the user likes, dislikes, or prefers
3. CONTEXT: Ongoing projects, tasks, or situations
4. RELATIONSHIPS: People, companies, or things the user mentions
5. INSTRUCTIONS: Explicit instructions on how to behave

For each piece of information, output in this format:
TYPE: <type>
CONTENT: <the memory to store>
CONFIDENCE: <high/medium/low>

Only extract information that would be useful to remember for future conversations.
If there's nothing worth remembering, respond with "NO_MEMORIES".
"""


# Usage Example
async def main():
    # Create agent for a specific user
    agent = MemoryAugmentedAgent(user_id="frank_123")

    # First conversation
    response1 = await agent.chat(
        "Hi! I'm Frank, I work as an AI architect at Oracle. I prefer concise responses."
    )
    print(f"Response 1: {response1}")

    # Simulate new session
    agent.clear_session()

    # Second conversation - agent should remember
    response2 = await agent.chat(
        "Can you help me with some cloud architecture questions?"
    )
    print(f"Response 2: {response2}")

    # Check what the agent knows
    summary = await agent.get_user_summary()
    print(f"User Summary: {summary}")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## Pattern 4: Multi-Agent Orchestration

### Problem Statement

Complex tasks require:
- Multiple specialized capabilities
- Coordination between steps
- Dynamic decision-making
- Error recovery and adaptation

### Solution Architecture

```
MULTI-AGENT ORCHESTRATION PATTERN
=================================

┌─────────────────────────────────────────────────────────────┐
│                    USER REQUEST                             │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              ORCHESTRATOR AGENT                        │  │
│  │                                                        │  │
│  │  Responsibilities:                                     │  │
│  │  - Task decomposition                                  │  │
│  │  - Agent selection                                     │  │
│  │  - Progress monitoring                                 │  │
│  │  - Result aggregation                                  │  │
│  │  - Error recovery                                      │  │
│  │                                                        │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                   │
│          ┌───────────────┼───────────────┐                  │
│          │               │               │                  │
│          ▼               ▼               ▼                  │
│  ┌───────────────┐ ┌───────────────┐ ┌───────────────┐     │
│  │   RESEARCH    │ │   ANALYSIS    │ │   WRITING     │     │
│  │    AGENT      │ │    AGENT      │ │    AGENT      │     │
│  │               │ │               │ │               │     │
│  │ - Web search  │ │ - Data proc.  │ │ - Drafting    │     │
│  │ - Summarize   │ │ - Reasoning   │ │ - Editing     │     │
│  │ - Cite        │ │ - Compare     │ │ - Formatting  │     │
│  └───────┬───────┘ └───────┬───────┘ └───────┬───────┘     │
│          │               │               │                  │
│          └───────────────┼───────────────┘                  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │                  SHARED STATE                          │  │
│  │  ┌───────────────────────────────────────────────┐    │  │
│  │  │  - Task progress                               │    │  │
│  │  │  - Intermediate results                        │    │  │
│  │  │  - Error logs                                  │    │  │
│  │  │  - Agent communications                        │    │  │
│  │  └───────────────────────────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                   │
└──────────────────────────┼───────────────────────────────────┘
                           │
                           ▼
                    FINAL OUTPUT
```

### Implementation with LangGraph

```python
"""
Multi-Agent Orchestration using LangGraph

This implementation provides:
1. Graph-based workflow definition
2. Typed state management
3. Conditional routing
4. Human-in-the-loop capabilities
5. Checkpointing and recovery
"""

import os
from typing import TypedDict, Annotated, Sequence, Literal
from typing_extensions import TypedDict
import operator

from langgraph.graph import StateGraph, END
from langgraph.checkpoint.memory import MemorySaver
from langgraph.prebuilt import ToolNode
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_core.tools import tool


# Define the state schema
class AgentState(TypedDict):
    """
    Shared state for multi-agent system.

    All agents can read and write to this state.
    The 'messages' field uses operator.add to append new messages.
    """
    messages: Annotated[Sequence[BaseMessage], operator.add]
    current_task: str
    research_results: str
    analysis_results: str
    draft_content: str
    final_output: str
    iteration: int
    status: Literal["in_progress", "needs_review", "completed", "failed"]


# Define tools for agents
@tool
def web_search(query: str) -> str:
    """Search the web for information."""
    # In production, integrate with a real search API
    return f"Search results for: {query}\n[Simulated search results]"


@tool
def analyze_data(data: str, analysis_type: str) -> str:
    """Analyze data using specified analysis type."""
    return f"Analysis of type '{analysis_type}':\n[Simulated analysis of: {data[:100]}...]"


@tool
def format_document(content: str, format_type: str) -> str:
    """Format content into specified document type."""
    return f"Formatted as {format_type}:\n{content}"


class MultiAgentOrchestrator:
    """
    Multi-agent system orchestrator using LangGraph.

    Agents:
    - Orchestrator: Coordinates the workflow
    - Researcher: Gathers information
    - Analyst: Processes and analyzes data
    - Writer: Produces final output
    """

    def __init__(self):
        # Initialize LLM
        self.llm = ChatAnthropic(
            model="claude-3-5-sonnet-20241022",
            api_key=os.getenv("ANTHROPIC_API_KEY"),
        )

        # Create the graph
        self.graph = self._build_graph()

        # Checkpointer for persistence
        self.checkpointer = MemorySaver()

    def _build_graph(self) -> StateGraph:
        """Build the agent workflow graph."""

        # Create graph with state schema
        workflow = StateGraph(AgentState)

        # Add nodes (agents)
        workflow.add_node("orchestrator", self._orchestrator_agent)
        workflow.add_node("researcher", self._researcher_agent)
        workflow.add_node("analyst", self._analyst_agent)
        workflow.add_node("writer", self._writer_agent)
        workflow.add_node("reviewer", self._reviewer_agent)

        # Define edges (transitions)
        workflow.set_entry_point("orchestrator")

        # Conditional routing from orchestrator
        workflow.add_conditional_edges(
            "orchestrator",
            self._route_from_orchestrator,
            {
                "research": "researcher",
                "analyze": "analyst",
                "write": "writer",
                "review": "reviewer",
                "complete": END,
            }
        )

        # Linear flow for specialist agents
        workflow.add_edge("researcher", "orchestrator")
        workflow.add_edge("analyst", "orchestrator")
        workflow.add_edge("writer", "orchestrator")

        # Reviewer can loop back or complete
        workflow.add_conditional_edges(
            "reviewer",
            self._route_from_reviewer,
            {
                "revise": "orchestrator",
                "approve": END,
            }
        )

        return workflow.compile(checkpointer=self.checkpointer)

    async def _orchestrator_agent(self, state: AgentState) -> AgentState:
        """
        Central orchestrator that coordinates the workflow.
        """

        # Build orchestrator prompt
        prompt = f"""You are the orchestrator of a multi-agent system.

Current State:
- Task: {state.get('current_task', 'Not set')}
- Research: {'Completed' if state.get('research_results') else 'Pending'}
- Analysis: {'Completed' if state.get('analysis_results') else 'Pending'}
- Draft: {'Completed' if state.get('draft_content') else 'Pending'}
- Iteration: {state.get('iteration', 0)}

Based on the current state, decide the next action:
1. If no research yet and task requires info gathering -> "research"
2. If research done but no analysis -> "analyze"
3. If analysis done but no draft -> "write"
4. If draft exists and iteration < 3 -> "review"
5. If review approved or iteration >= 3 -> "complete"

Respond with just the action word: research, analyze, write, review, or complete
"""

        messages = [HumanMessage(content=prompt)]
        response = await self.llm.ainvoke(messages)

        return {
            **state,
            "messages": [response],
            "iteration": state.get("iteration", 0) + 1,
        }

    async def _researcher_agent(self, state: AgentState) -> AgentState:
        """
        Research agent that gathers information.
        """

        prompt = f"""You are a research agent. Your task is to gather information.

Task: {state['current_task']}

Use available tools to search for relevant information.
Summarize your findings concisely.
"""

        messages = [HumanMessage(content=prompt)]

        # Bind tools to LLM
        llm_with_tools = self.llm.bind_tools([web_search])
        response = await llm_with_tools.ainvoke(messages)

        return {
            **state,
            "messages": [response],
            "research_results": response.content,
        }

    async def _analyst_agent(self, state: AgentState) -> AgentState:
        """
        Analysis agent that processes information.
        """

        prompt = f"""You are an analysis agent.

Task: {state['current_task']}
Research Data: {state.get('research_results', 'No research available')}

Analyze this information and provide insights.
"""

        messages = [HumanMessage(content=prompt)]
        response = await self.llm.ainvoke(messages)

        return {
            **state,
            "messages": [response],
            "analysis_results": response.content,
        }

    async def _writer_agent(self, state: AgentState) -> AgentState:
        """
        Writing agent that produces output.
        """

        prompt = f"""You are a writing agent.

Task: {state['current_task']}
Research: {state.get('research_results', 'N/A')}
Analysis: {state.get('analysis_results', 'N/A')}

Create a well-written output that addresses the task.
"""

        messages = [HumanMessage(content=prompt)]
        response = await self.llm.ainvoke(messages)

        return {
            **state,
            "messages": [response],
            "draft_content": response.content,
        }

    async def _reviewer_agent(self, state: AgentState) -> AgentState:
        """
        Review agent that evaluates output quality.
        """

        prompt = f"""You are a quality reviewer.

Original Task: {state['current_task']}
Draft Content: {state.get('draft_content', 'No draft')}

Evaluate the draft:
1. Does it address the task?
2. Is it accurate and well-written?
3. Are there any improvements needed?

Respond with either:
- "APPROVE" if the draft is ready
- "REVISE: [specific feedback]" if changes are needed
"""

        messages = [HumanMessage(content=prompt)]
        response = await self.llm.ainvoke(messages)

        status = "completed" if "APPROVE" in response.content else "needs_review"

        return {
            **state,
            "messages": [response],
            "status": status,
            "final_output": state.get('draft_content') if status == "completed" else "",
        }

    def _route_from_orchestrator(self, state: AgentState) -> str:
        """Route based on orchestrator's decision."""
        last_message = state["messages"][-1]
        content = last_message.content.lower().strip()

        if "research" in content:
            return "research"
        elif "analyze" in content:
            return "analyze"
        elif "write" in content:
            return "write"
        elif "review" in content:
            return "review"
        else:
            return "complete"

    def _route_from_reviewer(self, state: AgentState) -> str:
        """Route based on reviewer's decision."""
        if state.get("status") == "completed":
            return "approve"
        return "revise"

    async def run(
        self,
        task: str,
        thread_id: str = "default",
    ) -> str:
        """
        Execute the multi-agent workflow.
        """

        initial_state: AgentState = {
            "messages": [],
            "current_task": task,
            "research_results": "",
            "analysis_results": "",
            "draft_content": "",
            "final_output": "",
            "iteration": 0,
            "status": "in_progress",
        }

        config = {"configurable": {"thread_id": thread_id}}

        # Run the graph
        final_state = await self.graph.ainvoke(initial_state, config)

        return final_state.get("final_output", "No output generated")


# Simpler CrewAI-style implementation
class SimpleMultiAgentCrew:
    """
    Simpler multi-agent pattern using role-based agents.

    This is an alternative to LangGraph for simpler use cases.
    """

    def __init__(self):
        self.llm = ChatAnthropic(
            model="claude-3-5-sonnet-20241022",
            api_key=os.getenv("ANTHROPIC_API_KEY"),
        )

    async def run_crew(self, task: str) -> str:
        """Run a simple sequential crew."""

        # Agent 1: Researcher
        research = await self._run_agent(
            role="Research Specialist",
            goal="Gather comprehensive information",
            task=f"Research: {task}",
        )

        # Agent 2: Analyst
        analysis = await self._run_agent(
            role="Data Analyst",
            goal="Extract insights from research",
            task=f"Analyze this research:\n{research}",
        )

        # Agent 3: Writer
        output = await self._run_agent(
            role="Content Writer",
            goal="Create polished output",
            task=f"Write a response based on:\nAnalysis: {analysis}",
        )

        return output

    async def _run_agent(
        self,
        role: str,
        goal: str,
        task: str,
    ) -> str:
        """Run a single agent with a specific role."""

        prompt = f"""You are a {role}.
Your goal: {goal}

Task: {task}

Complete this task to the best of your ability.
"""

        messages = [HumanMessage(content=prompt)]
        response = await self.llm.ainvoke(messages)
        return response.content


# Usage Example
async def main():
    # LangGraph-based orchestration
    orchestrator = MultiAgentOrchestrator()

    result = await orchestrator.run(
        task="Write a brief analysis of AI Operations trends in 2026",
        thread_id="analysis_001",
    )

    print(f"Final Output:\n{result}")

    # Simple crew-based approach
    crew = SimpleMultiAgentCrew()
    simple_result = await crew.run_crew(
        task="Summarize the key benefits of AI Operations"
    )
    print(f"\nSimple Crew Output:\n{simple_result}")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## Pattern 5: Privacy-Preserving AI

### Problem Statement

Sensitive data cannot be sent to cloud AI providers:
- PII exposure risks
- Regulatory compliance (GDPR, HIPAA)
- Intellectual property concerns
- Data residency requirements

### Solution Architecture

```
PRIVACY-PRESERVING PATTERN
==========================

┌─────────────────────────────────────────────────────────────┐
│                    USER REQUEST                             │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              CLASSIFICATION LAYER                      │  │
│  │                                                        │  │
│  │  Analyze request for:                                  │  │
│  │  - PII (names, emails, SSN, etc.)                     │  │
│  │  - Confidential keywords                              │  │
│  │  - Data classification labels                         │  │
│  │                                                        │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                   │
│              ┌───────────┴───────────┐                      │
│              │                       │                      │
│              ▼                       ▼                      │
│  ┌───────────────────┐   ┌───────────────────────────────┐ │
│  │  SENSITIVE PATH   │   │    STANDARD PATH              │ │
│  │                   │   │                               │ │
│  │  1. PII Masking   │   │    Direct to cloud AI        │ │
│  │  2. Local Model   │   │                               │ │
│  │  3. On-prem AI    │   │                               │ │
│  │                   │   │                               │ │
│  └─────────┬─────────┘   └───────────────┬───────────────┘ │
│            │                             │                  │
│            └─────────────┬───────────────┘                  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              POST-PROCESSING LAYER                     │  │
│  │                                                        │  │
│  │  - Unmask PII if needed                               │  │
│  │  - Validate no data leakage                           │  │
│  │  - Audit logging                                      │  │
│  │                                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                   │
└──────────────────────────┼───────────────────────────────────┘
                           │
                           ▼
                    SAFE RESPONSE
```

### Implementation

```python
"""
Privacy-Preserving AI Implementation

This implementation provides:
1. PII detection and masking
2. Routing to local models for sensitive data
3. Data classification
4. Audit logging
5. Compliance controls
"""

import os
import re
import hashlib
from typing import Optional, Dict, Any, List, Tuple
from dataclasses import dataclass
from enum import Enum
import litellm


class DataClassification(Enum):
    """Data sensitivity classification levels."""
    PUBLIC = "public"
    INTERNAL = "internal"
    CONFIDENTIAL = "confidential"
    RESTRICTED = "restricted"


@dataclass
class PIIEntity:
    """Detected PII entity."""
    type: str
    value: str
    start: int
    end: int
    masked_value: str


class PrivacyPreservingAI:
    """
    AI system with built-in privacy protections.

    Features:
    - Automatic PII detection
    - Data masking before API calls
    - Local model routing for sensitive data
    - Audit trail for compliance
    """

    # PII patterns (simplified - use a proper NER model in production)
    PII_PATTERNS = {
        "email": r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
        "phone": r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b',
        "ssn": r'\b\d{3}-\d{2}-\d{4}\b',
        "credit_card": r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b',
        "ip_address": r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b',
    }

    # Sensitive keywords that trigger local processing
    SENSITIVE_KEYWORDS = [
        "password", "secret", "confidential", "internal only",
        "proprietary", "classified", "restricted",
    ]

    def __init__(self):
        self.audit_log: List[Dict[str, Any]] = []
        self.pii_mapping: Dict[str, str] = {}  # masked -> original

    async def process(
        self,
        prompt: str,
        context: Optional[str] = None,
        force_local: bool = False,
    ) -> Dict[str, Any]:
        """
        Process a request with privacy protection.

        Steps:
        1. Classify data sensitivity
        2. Detect and mask PII
        3. Route to appropriate model
        4. Unmask response if needed
        5. Log for audit
        """

        # Step 1: Classify data
        classification = self._classify_data(prompt, context)

        # Step 2: Detect PII
        pii_entities = self._detect_pii(prompt)
        masked_prompt = self._mask_pii(prompt, pii_entities)

        if context:
            context_pii = self._detect_pii(context)
            masked_context = self._mask_pii(context, context_pii)
        else:
            masked_context = None

        # Step 3: Route to appropriate model
        use_local = (
            force_local or
            classification in [DataClassification.CONFIDENTIAL, DataClassification.RESTRICTED] or
            len(pii_entities) > 0
        )

        if use_local:
            response = await self._call_local_model(masked_prompt, masked_context)
            model_used = "local"
        else:
            response = await self._call_cloud_model(masked_prompt, masked_context)
            model_used = "cloud"

        # Step 4: Unmask response (careful - only for internal use)
        # In most cases, you want the response to remain masked
        unmasked_response = self._unmask_response(response)

        # Step 5: Audit log
        self._log_audit(
            prompt_classification=classification,
            pii_detected=len(pii_entities) > 0,
            model_used=model_used,
            pii_types=[e.type for e in pii_entities],
        )

        return {
            "response": response,  # Keep masked for safety
            "unmasked_response": unmasked_response,  # Only for internal use
            "classification": classification.value,
            "pii_detected": len(pii_entities) > 0,
            "model_used": model_used,
            "pii_entities": [{"type": e.type, "masked": e.masked_value} for e in pii_entities],
        }

    def _classify_data(
        self,
        prompt: str,
        context: Optional[str] = None,
    ) -> DataClassification:
        """Classify the sensitivity of the data."""

        combined = f"{prompt} {context or ''}".lower()

        # Check for sensitive keywords
        for keyword in self.SENSITIVE_KEYWORDS:
            if keyword in combined:
                return DataClassification.CONFIDENTIAL

        # Check for PII indicators
        if any(re.search(pattern, combined) for pattern in self.PII_PATTERNS.values()):
            return DataClassification.CONFIDENTIAL

        # Default classification
        return DataClassification.INTERNAL

    def _detect_pii(self, text: str) -> List[PIIEntity]:
        """Detect PII entities in text."""

        entities = []

        for pii_type, pattern in self.PII_PATTERNS.items():
            for match in re.finditer(pattern, text, re.IGNORECASE):
                # Generate consistent masked value
                masked = self._generate_mask(match.group(), pii_type)

                entities.append(PIIEntity(
                    type=pii_type,
                    value=match.group(),
                    start=match.start(),
                    end=match.end(),
                    masked_value=masked,
                ))

        return entities

    def _generate_mask(self, value: str, pii_type: str) -> str:
        """Generate a consistent mask for a PII value."""

        # Create deterministic hash for consistent masking
        hash_input = f"{value}:{pii_type}"
        hash_value = hashlib.sha256(hash_input.encode()).hexdigest()[:8]

        mask = f"[{pii_type.upper()}_{hash_value}]"

        # Store mapping for potential unmasking
        self.pii_mapping[mask] = value

        return mask

    def _mask_pii(self, text: str, entities: List[PIIEntity]) -> str:
        """Replace PII with masked values."""

        # Sort by position (reverse) to maintain indices
        sorted_entities = sorted(entities, key=lambda e: e.start, reverse=True)

        result = text
        for entity in sorted_entities:
            result = result[:entity.start] + entity.masked_value + result[entity.end:]

        return result

    def _unmask_response(self, response: str) -> str:
        """Restore original values from masks (internal use only)."""

        result = response
        for mask, original in self.pii_mapping.items():
            result = result.replace(mask, original)

        return result

    async def _call_local_model(
        self,
        prompt: str,
        context: Optional[str] = None,
    ) -> str:
        """Call local model for sensitive data."""

        messages = []
        if context:
            messages.append({"role": "system", "content": context})
        messages.append({"role": "user", "content": prompt})

        response = await litellm.acompletion(
            model="ollama/llama3.1",
            messages=messages,
            api_base="http://localhost:11434",
        )

        return response.choices[0].message.content

    async def _call_cloud_model(
        self,
        prompt: str,
        context: Optional[str] = None,
    ) -> str:
        """Call cloud model for non-sensitive data."""

        messages = []
        if context:
            messages.append({"role": "system", "content": context})
        messages.append({"role": "user", "content": prompt})

        response = await litellm.acompletion(
            model="claude-3-5-sonnet-20241022",
            messages=messages,
        )

        return response.choices[0].message.content

    def _log_audit(self, **kwargs) -> None:
        """Log for compliance audit trail."""

        import datetime

        self.audit_log.append({
            "timestamp": datetime.datetime.utcnow().isoformat(),
            **kwargs,
        })

    def get_audit_report(self) -> List[Dict[str, Any]]:
        """Get audit log for compliance reporting."""
        return self.audit_log


# Data Loss Prevention (DLP) rules
DLP_RULES = """
# DLP Rules Configuration

rules:
  - name: "Block SSN"
    pattern: "\\d{3}-\\d{2}-\\d{4}"
    action: "block"
    severity: "critical"

  - name: "Mask Credit Card"
    pattern: "\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}[-\\s]?\\d{4}"
    action: "mask"
    severity: "high"

  - name: "Warn on Password"
    pattern: "password\\s*[:=]\\s*\\S+"
    action: "warn"
    severity: "medium"

  - name: "Route Medical to Local"
    keywords: ["diagnosis", "prescription", "patient", "medical record"]
    action: "route_local"
    severity: "high"
"""


# Usage Example
async def main():
    privacy_ai = PrivacyPreservingAI()

    # Test with PII
    result = await privacy_ai.process(
        prompt="Please send the invoice to john.doe@company.com and call 555-123-4567",
        context="You are a helpful assistant.",
    )

    print(f"Model used: {result['model_used']}")
    print(f"PII detected: {result['pii_detected']}")
    print(f"PII entities: {result['pii_entities']}")
    print(f"Safe response: {result['response']}")

    # Get audit report
    audit = privacy_ai.get_audit_report()
    print(f"\nAudit log: {audit}")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## Pattern 6: Cost-Optimized Operations

### Problem Statement

AI costs can spiral out of control:
- No visibility into spend
- Inefficient model selection
- Repeated queries for same information
- No budget controls

### Solution Architecture

```
COST-OPTIMIZED PATTERN
======================

┌─────────────────────────────────────────────────────────────┐
│                    INCOMING REQUEST                         │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              COST ESTIMATION LAYER                     │  │
│  │                                                        │  │
│  │  - Estimate input tokens                              │  │
│  │  - Predict output tokens                              │  │
│  │  - Calculate expected cost                            │  │
│  │  - Check against budget                               │  │
│  │                                                        │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                   │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │              OPTIMIZATION LAYER                        │  │
│  │                                                        │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │  │
│  │  │   Cache     │ │   Model     │ │   Prompt    │     │  │
│  │  │   Check     │ │  Selection  │ │Optimization │     │  │
│  │  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘     │  │
│  │         │               │               │             │  │
│  │         └───────────────┼───────────────┘             │  │
│  │                         │                              │  │
│  └─────────────────────────┼─────────────────────────────┘  │
│                            │                                 │
│  ┌─────────────────────────▼─────────────────────────────┐  │
│  │              EXECUTION LAYER                           │  │
│  │                                                        │  │
│  │  Execute with chosen model and optimized prompt       │  │
│  │                                                        │  │
│  └─────────────────────────┬─────────────────────────────┘  │
│                            │                                 │
│  ┌─────────────────────────▼─────────────────────────────┐  │
│  │              COST TRACKING LAYER                       │  │
│  │                                                        │  │
│  │  - Record actual tokens and cost                      │  │
│  │  - Update budget tracking                             │  │
│  │  - Generate reports                                   │  │
│  │  - Trigger alerts if needed                           │  │
│  │                                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Implementation

```python
"""
Cost-Optimized AI Operations Implementation

This implementation provides:
1. Cost estimation before execution
2. Intelligent model selection
3. Response caching
4. Prompt optimization
5. Budget controls and alerts
"""

import os
import hashlib
from typing import Optional, Dict, Any, List
from dataclasses import dataclass
from datetime import datetime, timedelta
import tiktoken
import litellm


@dataclass
class CostEstimate:
    """Estimated cost for a request."""
    input_tokens: int
    estimated_output_tokens: int
    model: str
    estimated_cost_usd: float


@dataclass
class UsageRecord:
    """Record of actual usage."""
    timestamp: datetime
    model: str
    input_tokens: int
    output_tokens: int
    cost_usd: float
    cached: bool
    user_id: Optional[str]


class CostOptimizedAI:
    """
    AI system optimized for cost efficiency.

    Strategies:
    1. Model tiering - use cheapest model that meets quality threshold
    2. Response caching - avoid redundant API calls
    3. Prompt compression - reduce input tokens
    4. Budget controls - prevent cost overruns
    """

    # Model cost per 1M tokens (as of 2026)
    MODEL_COSTS = {
        "claude-3-5-sonnet-20241022": {"input": 3.00, "output": 15.00},
        "claude-3-5-haiku-20241022": {"input": 0.80, "output": 4.00},
        "gpt-4-turbo": {"input": 10.00, "output": 30.00},
        "gpt-4o": {"input": 2.50, "output": 10.00},
        "gpt-4o-mini": {"input": 0.15, "output": 0.60},
        "ollama/llama3.1": {"input": 0, "output": 0},  # Local, free
    }

    # Model quality tiers
    MODEL_TIERS = {
        "premium": ["claude-3-5-sonnet-20241022", "gpt-4-turbo"],
        "standard": ["gpt-4o", "claude-3-5-haiku-20241022"],
        "economy": ["gpt-4o-mini"],
        "free": ["ollama/llama3.1"],
    }

    def __init__(
        self,
        daily_budget_usd: float = 100.0,
        cache_ttl_hours: int = 24,
    ):
        self.daily_budget = daily_budget_usd
        self.cache_ttl = timedelta(hours=cache_ttl_hours)
        self.usage_records: List[UsageRecord] = []
        self.cache: Dict[str, Dict[str, Any]] = {}
        self.tokenizer = tiktoken.get_encoding("cl100k_base")

    async def chat(
        self,
        messages: List[Dict[str, str]],
        quality_tier: str = "standard",
        max_cost_usd: Optional[float] = None,
        user_id: Optional[str] = None,
        use_cache: bool = True,
    ) -> Dict[str, Any]:
        """
        Cost-optimized chat completion.

        Args:
            messages: Chat messages
            quality_tier: "premium", "standard", "economy", "free"
            max_cost_usd: Maximum allowed cost for this request
            user_id: User ID for budget tracking
            use_cache: Whether to use response caching
        """

        # Step 1: Check cache
        if use_cache:
            cached = self._check_cache(messages)
            if cached:
                self._record_usage(
                    model="cache",
                    input_tokens=0,
                    output_tokens=0,
                    cost=0,
                    cached=True,
                    user_id=user_id,
                )
                return {
                    "content": cached["content"],
                    "model": cached["model"],
                    "cached": True,
                    "cost_usd": 0,
                }

        # Step 2: Select model based on tier and budget
        model = self._select_model(messages, quality_tier, max_cost_usd)

        # Step 3: Check budget
        estimate = self._estimate_cost(messages, model)
        if not self._check_budget(estimate.estimated_cost_usd, user_id):
            return {
                "error": "Budget exceeded",
                "daily_usage": self._get_daily_usage(user_id),
                "daily_budget": self.daily_budget,
            }

        # Step 4: Optimize prompt if needed
        optimized_messages = self._optimize_prompt(messages, model)

        # Step 5: Execute
        response = await litellm.acompletion(
            model=model,
            messages=optimized_messages,
        )

        content = response.choices[0].message.content
        actual_cost = self._calculate_cost(
            model,
            response.usage.prompt_tokens,
            response.usage.completion_tokens,
        )

        # Step 6: Record usage
        self._record_usage(
            model=model,
            input_tokens=response.usage.prompt_tokens,
            output_tokens=response.usage.completion_tokens,
            cost=actual_cost,
            cached=False,
            user_id=user_id,
        )

        # Step 7: Update cache
        if use_cache:
            self._update_cache(messages, content, model)

        return {
            "content": content,
            "model": model,
            "cached": False,
            "cost_usd": actual_cost,
            "tokens": {
                "input": response.usage.prompt_tokens,
                "output": response.usage.completion_tokens,
            },
        }

    def _check_cache(
        self,
        messages: List[Dict[str, str]],
    ) -> Optional[Dict[str, Any]]:
        """Check if we have a cached response."""

        cache_key = self._generate_cache_key(messages)

        if cache_key in self.cache:
            cached = self.cache[cache_key]
            if datetime.now() - cached["timestamp"] < self.cache_ttl:
                return cached
            else:
                del self.cache[cache_key]

        return None

    def _generate_cache_key(self, messages: List[Dict[str, str]]) -> str:
        """Generate a cache key from messages."""
        content = str(messages)
        return hashlib.sha256(content.encode()).hexdigest()

    def _update_cache(
        self,
        messages: List[Dict[str, str]],
        response: str,
        model: str,
    ) -> None:
        """Update the cache with a new response."""

        cache_key = self._generate_cache_key(messages)
        self.cache[cache_key] = {
            "content": response,
            "model": model,
            "timestamp": datetime.now(),
        }

    def _select_model(
        self,
        messages: List[Dict[str, str]],
        quality_tier: str,
        max_cost: Optional[float],
    ) -> str:
        """Select the optimal model based on requirements."""

        tier_models = self.MODEL_TIERS.get(quality_tier, self.MODEL_TIERS["standard"])

        # If max cost specified, filter models
        if max_cost:
            estimate_tokens = self._count_tokens(messages)
            affordable_models = []

            for model in tier_models:
                cost = self._calculate_cost(model, estimate_tokens, estimate_tokens * 2)
                if cost <= max_cost:
                    affordable_models.append(model)

            if affordable_models:
                return affordable_models[0]

            # Fall back to cheaper tier
            for tier in ["economy", "free"]:
                for model in self.MODEL_TIERS[tier]:
                    cost = self._calculate_cost(model, estimate_tokens, estimate_tokens * 2)
                    if cost <= max_cost:
                        return model

        return tier_models[0]

    def _estimate_cost(
        self,
        messages: List[Dict[str, str]],
        model: str,
    ) -> CostEstimate:
        """Estimate the cost of a request."""

        input_tokens = self._count_tokens(messages)
        estimated_output = input_tokens * 2  # Rough estimate

        cost = self._calculate_cost(model, input_tokens, estimated_output)

        return CostEstimate(
            input_tokens=input_tokens,
            estimated_output_tokens=estimated_output,
            model=model,
            estimated_cost_usd=cost,
        )

    def _count_tokens(self, messages: List[Dict[str, str]]) -> int:
        """Count tokens in messages."""
        total = 0
        for msg in messages:
            total += len(self.tokenizer.encode(msg.get("content", "")))
        return total

    def _calculate_cost(
        self,
        model: str,
        input_tokens: int,
        output_tokens: int,
    ) -> float:
        """Calculate cost for token usage."""

        costs = self.MODEL_COSTS.get(model, {"input": 0, "output": 0})

        input_cost = (input_tokens / 1_000_000) * costs["input"]
        output_cost = (output_tokens / 1_000_000) * costs["output"]

        return input_cost + output_cost

    def _check_budget(
        self,
        estimated_cost: float,
        user_id: Optional[str],
    ) -> bool:
        """Check if request is within budget."""

        daily_usage = self._get_daily_usage(user_id)
        return (daily_usage + estimated_cost) <= self.daily_budget

    def _get_daily_usage(self, user_id: Optional[str] = None) -> float:
        """Get total usage for today."""

        today = datetime.now().date()
        total = 0

        for record in self.usage_records:
            if record.timestamp.date() == today:
                if user_id is None or record.user_id == user_id:
                    total += record.cost_usd

        return total

    def _optimize_prompt(
        self,
        messages: List[Dict[str, str]],
        model: str,
    ) -> List[Dict[str, str]]:
        """Optimize prompt to reduce tokens."""

        optimized = []

        for msg in messages:
            content = msg.get("content", "")

            # Remove excessive whitespace
            content = " ".join(content.split())

            # Truncate very long messages (preserve meaning)
            if len(content) > 10000:
                content = content[:10000] + "... [truncated]"

            optimized.append({
                "role": msg["role"],
                "content": content,
            })

        return optimized

    def _record_usage(
        self,
        model: str,
        input_tokens: int,
        output_tokens: int,
        cost: float,
        cached: bool,
        user_id: Optional[str],
    ) -> None:
        """Record usage for tracking."""

        self.usage_records.append(UsageRecord(
            timestamp=datetime.now(),
            model=model,
            input_tokens=input_tokens,
            output_tokens=output_tokens,
            cost_usd=cost,
            cached=cached,
            user_id=user_id,
        ))

    def get_usage_report(
        self,
        days: int = 7,
        user_id: Optional[str] = None,
    ) -> Dict[str, Any]:
        """Generate usage report."""

        cutoff = datetime.now() - timedelta(days=days)

        filtered = [
            r for r in self.usage_records
            if r.timestamp > cutoff and (user_id is None or r.user_id == user_id)
        ]

        total_cost = sum(r.cost_usd for r in filtered)
        total_tokens = sum(r.input_tokens + r.output_tokens for r in filtered)
        cache_hits = sum(1 for r in filtered if r.cached)
        total_requests = len(filtered)

        by_model = {}
        for r in filtered:
            if r.model not in by_model:
                by_model[r.model] = {"cost": 0, "tokens": 0, "requests": 0}
            by_model[r.model]["cost"] += r.cost_usd
            by_model[r.model]["tokens"] += r.input_tokens + r.output_tokens
            by_model[r.model]["requests"] += 1

        return {
            "period_days": days,
            "total_cost_usd": round(total_cost, 4),
            "total_tokens": total_tokens,
            "total_requests": total_requests,
            "cache_hit_rate": cache_hits / total_requests if total_requests > 0 else 0,
            "avg_cost_per_request": total_cost / total_requests if total_requests > 0 else 0,
            "by_model": by_model,
        }


# Usage Example
async def main():
    ai = CostOptimizedAI(daily_budget_usd=50.0)

    # Standard quality request
    result = await ai.chat(
        messages=[
            {"role": "user", "content": "Explain AI Operations in one sentence."}
        ],
        quality_tier="standard",
        user_id="user_123",
    )

    print(f"Response: {result['content']}")
    print(f"Model: {result['model']}")
    print(f"Cost: ${result['cost_usd']:.6f}")
    print(f"Cached: {result['cached']}")

    # Same request again - should hit cache
    result2 = await ai.chat(
        messages=[
            {"role": "user", "content": "Explain AI Operations in one sentence."}
        ],
        quality_tier="standard",
        user_id="user_123",
    )

    print(f"\nSecond request cached: {result2['cached']}")

    # Usage report
    report = ai.get_usage_report(days=1)
    print(f"\nUsage Report: {report}")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## Anti-Patterns

### Anti-Pattern 1: Direct Provider Coupling

```python
# BAD: Directly coupled to OpenAI
import openai

def get_response(prompt):
    client = openai.OpenAI()
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )
    return response.choices[0].message.content

# Problems:
# - Cannot switch providers without code changes
# - No fallback if OpenAI is down
# - No cost tracking
# - No observability

# GOOD: Use gateway abstraction
async def get_response(prompt):
    return await gateway.chat(
        messages=[{"role": "user", "content": prompt}],
        model="primary",  # Abstract model name
    )
```

### Anti-Pattern 2: Observability Afterthought

```python
# BAD: No observability
async def process_document(doc):
    chunks = split_document(doc)
    embeddings = await get_embeddings(chunks)
    results = await search_similar(embeddings)
    response = await generate_response(results)
    return response

# Problems:
# - Can't debug failures
# - Can't measure quality
# - Can't track costs
# - Can't identify bottlenecks

# GOOD: Observability from the start
@observe(name="document_processing")
async def process_document(doc):
    with trace_span("chunking"):
        chunks = split_document(doc)

    with trace_span("embedding"):
        embeddings = await get_embeddings(chunks)

    with trace_span("search"):
        results = await search_similar(embeddings)

    with trace_span("generation"):
        response = await generate_response(results)

    return response
```

### Anti-Pattern 3: Unbounded Context

```python
# BAD: Stuffing entire history into context
async def chat(user_message, conversation_history):
    messages = [
        {"role": "system", "content": system_prompt},
        *conversation_history,  # Could be thousands of messages!
        {"role": "user", "content": user_message},
    ]
    return await llm.complete(messages)

# Problems:
# - Token costs explode
# - Eventually hits context limits
# - Irrelevant context degrades quality

# GOOD: Smart context management
async def chat(user_message, conversation_history):
    # Get relevant context
    relevant = await memory.search(user_message, limit=5)

    # Recent history only
    recent = conversation_history[-10:]

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "system", "content": f"Relevant context: {relevant}"},
        *recent,
        {"role": "user", "content": user_message},
    ]
    return await llm.complete(messages)
```

### Anti-Pattern 4: Synchronous Everything

```python
# BAD: Blocking calls
def process_batch(items):
    results = []
    for item in items:
        result = llm.complete(item)  # Blocking!
        results.append(result)
    return results

# Problems:
# - Extremely slow for batches
# - Wastes time waiting
# - Poor resource utilization

# GOOD: Async and parallel
async def process_batch(items):
    tasks = [llm.acomplete(item) for item in items]
    results = await asyncio.gather(*tasks)
    return results
```

### Anti-Pattern 5: No Error Handling

```python
# BAD: Assuming success
async def generate(prompt):
    response = await llm.complete(prompt)
    return response.content

# Problems:
# - Crashes on rate limits
# - No retry logic
# - No fallback
# - Poor user experience

# GOOD: Robust error handling
async def generate(prompt, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = await llm.complete(prompt)
            return response.content
        except RateLimitError:
            await asyncio.sleep(2 ** attempt)
        except ProviderError:
            # Try fallback provider
            return await fallback_llm.complete(prompt)

    raise MaxRetriesExceeded()
```

---

## Summary

These implementation patterns provide battle-tested approaches for building production AI systems:

| Pattern | When to Use | Key Benefit |
|---------|-------------|-------------|
| Unified Gateway | Multiple providers | Flexibility, resilience |
| Observability-First | All production systems | Debugging, optimization |
| Memory-Augmented | Personalized assistants | Context continuity |
| Multi-Agent | Complex tasks | Specialization, scale |
| Privacy-Preserving | Sensitive data | Compliance, trust |
| Cost-Optimized | Budget-conscious | Efficiency, control |

**Key Takeaways:**
1. Always abstract provider dependencies
2. Instrument from day one
3. Design for failure and recovery
4. Optimize for cost without sacrificing quality
5. Protect sensitive data by default

---

**Next:** [AI_OPS_MATURITY_MODEL.md](./AI_OPS_MATURITY_MODEL.md)
