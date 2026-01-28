# Agent Memory Systems Research

> Long-term memory for AI agents and assistants

## Overview

Memory systems enable AI agents to:
- Remember past conversations
- Learn user preferences
- Build knowledge over time
- Maintain context across sessions

---

## Types of Memory

### 1. Short-Term / Working Memory
- Current conversation context
- Within token window
- Automatic (part of prompt)

### 2. Long-Term Memory
- Persists across sessions
- Needs explicit storage
- Retrieval on demand

### 3. Episodic Memory
- Specific events/interactions
- Timestamped
- "Remember when we discussed X"

### 4. Semantic Memory
- Facts and knowledge
- User preferences
- Domain expertise

### 5. Procedural Memory
- How to do things
- Learned workflows
- Custom behaviors

---

## Memory Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    AI AGENT                              │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │              Working Memory                      │   │
│  │         (Current conversation)                   │   │
│  └─────────────────────────────────────────────────┘   │
│                         │                               │
│  ┌─────────────────────▼───────────────────────────┐   │
│  │           Memory Manager                         │   │
│  │  • Extract important info                        │   │
│  │  • Decide what to store                          │   │
│  │  • Retrieve relevant memories                    │   │
│  └─────────────────────┬───────────────────────────┘   │
│                        │                                │
└────────────────────────┼────────────────────────────────┘
                         │
    ┌────────────────────┼────────────────────┐
    │                    │                    │
    ▼                    ▼                    ▼
┌─────────┐       ┌─────────────┐      ┌──────────┐
│ Vector  │       │ Relational  │      │ Graph    │
│   DB    │       │     DB      │      │   DB     │
│(Qdrant) │       │(PostgreSQL) │      │ (Neo4j)  │
└─────────┘       └─────────────┘      └──────────┘
 Semantic          Structured          Relationships
```

---

## Solutions Comparison

| Platform | Type | Self-Hosted | Open Source | Integration |
|----------|------|-------------|-------------|-------------|
| **Mem0** | All-in-one | Yes | Yes | Easy |
| **Zep** | Long-term | Yes | Yes | LangChain |
| **Motorhead** | Session | Yes | Yes | Simple |
| **LangGraph Memory** | Graph-based | Yes | Yes | LangChain |
| **Custom (Vector DB)** | Flexible | Yes | Yes | DIY |

---

## Mem0 (Recommended)

**Why:** Purpose-built for AI memory, easy to integrate.

### Features
- Automatic memory extraction
- Multi-user support
- Hybrid search (vector + graph)
- Self-hosted option
- Simple API

### Installation
```bash
pip install mem0ai
```

### Usage
```python
from mem0 import Memory

# Initialize
m = Memory()

# Add memories
m.add("I prefer Python over JavaScript", user_id="frank")
m.add("My daughter's name is Emma", user_id="frank")

# Search memories
results = m.search("What programming language do I like?", user_id="frank")
# Returns: "User prefers Python over JavaScript"

# Get all memories for user
memories = m.get_all(user_id="frank")
```

### Self-Hosted Config
```python
from mem0 import Memory

config = {
    "vector_store": {
        "provider": "qdrant",
        "config": {
            "host": "localhost",
            "port": 6333,
        }
    },
    "llm": {
        "provider": "litellm",
        "config": {
            "model": "claude-sonnet",
            "api_base": "http://localhost:4000"
        }
    },
    "embedder": {
        "provider": "litellm",
        "config": {
            "model": "text-embedding-3-small",
            "api_base": "http://localhost:4000"
        }
    }
}

m = Memory.from_config(config)
```

### Links
- [GitHub](https://github.com/mem0ai/mem0)
- [Docs](https://docs.mem0.ai/)

---

## Custom Memory with Vector DB

### Architecture
```python
# memory/core.py

from qdrant_client import QdrantClient
from datetime import datetime
import json

class AgentMemory:
    def __init__(self, user_id: str):
        self.user_id = user_id
        self.qdrant = QdrantClient(host="localhost", port=6333)
        self.collection = f"memories_{user_id}"

    def add(self, content: str, memory_type: str = "general"):
        # Generate embedding
        embedding = self.get_embedding(content)

        # Store in Qdrant
        self.qdrant.upsert(
            collection_name=self.collection,
            points=[{
                "id": str(uuid4()),
                "vector": embedding,
                "payload": {
                    "content": content,
                    "type": memory_type,
                    "timestamp": datetime.now().isoformat(),
                    "user_id": self.user_id
                }
            }]
        )

    def search(self, query: str, limit: int = 5):
        query_embedding = self.get_embedding(query)

        results = self.qdrant.search(
            collection_name=self.collection,
            query_vector=query_embedding,
            limit=limit
        )

        return [r.payload["content"] for r in results]

    def get_embedding(self, text: str):
        # Via LiteLLM
        response = litellm.embedding(
            model="text-embedding-3-small",
            input=text
        )
        return response.data[0].embedding
```

---

## Use Cases in AI Ops

### Family Intelligence
```python
# Remember family preferences
memory.add("Emma likes dinosaurs", user_id="emma")
memory.add("Dad prefers no sugar in coffee", user_id="family")
memory.add("We usually vacation in August", user_id="family")

# Later...
results = memory.search("What does Emma like?")
# → "Emma likes dinosaurs"
```

### GenCreator
```python
# Remember brand voice
memory.add("FrankX tone: professional but approachable", user_id="frankx")
memory.add("Avoid jargon, prefer simple explanations", user_id="frankx")

# Remember content preferences
memory.add("Newsletter format: intro → 3 points → CTA", user_id="frankx")
```

### ACOS Agents
```python
# Agent learns from corrections
memory.add("User prefers bullet points over paragraphs", agent_id="writer")
memory.add("Always include code examples in explanations", agent_id="coder")
```

---

## Memory Integration with LiteLLM

### Pre-request Memory Injection
```python
async def chat_with_memory(user_id: str, message: str):
    # Retrieve relevant memories
    memories = memory.search(message, user_id=user_id)

    # Build system prompt with memories
    system_prompt = f"""You are a helpful assistant.

## User Context (from memory)
{chr(10).join(f'- {m}' for m in memories)}

Use this context to personalize your responses."""

    # Call LLM
    response = await litellm.acompletion(
        model="claude-sonnet",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": message}
        ]
    )

    # Extract and store new memories from conversation
    new_memories = extract_memories(message, response)
    for mem in new_memories:
        memory.add(mem, user_id=user_id)

    return response
```

---

## Implementation Plan

### Phase 1: Basic Memory
- [ ] Deploy Qdrant
- [ ] Implement simple memory class
- [ ] Integrate with Open WebUI

### Phase 2: Multi-User
- [ ] User isolation
- [ ] Family shared memories
- [ ] Privacy controls

### Phase 3: Advanced
- [ ] Memory summarization
- [ ] Forgetting (privacy)
- [ ] Memory importance scoring

---

## Resources

- [Mem0](https://github.com/mem0ai/mem0)
- [Zep](https://github.com/getzep/zep)
- [Qdrant](https://qdrant.tech/)

---

*Last Updated: January 2026*
