-- Initialize databases for AI Ops stack

-- Create database for LiteLLM
CREATE DATABASE litellm;

-- Create database for Langfuse
CREATE DATABASE langfuse;

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE litellm TO aiops;
GRANT ALL PRIVILEGES ON DATABASE langfuse TO aiops;
