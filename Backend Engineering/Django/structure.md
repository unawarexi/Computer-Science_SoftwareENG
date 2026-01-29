/ai
  /agents
    main_agent.py          # LangGraph definition
    planner.py             # Task decomposition logic
    policies.py            # Guardrails, permissions
  /tools
    search.py              # Tavily wrapper
    db.py                  # DB tools
    blockchain.py          # Web3 tools
    external_apis.py
  /rag
    ingest.py              # Chunking, embedding
    retriever.py           # Vector search
    reranker.py
    prompts.py
  /memory
    short_term.py
    long_term.py           # Vector DB / SQL
    schemas.py
  /models
    llm_router.py          # OpenAI vs HF vs Claude
    embeddings.py
  /eval
    metrics.py
    traces.py
/config
  settings.py
  secrets.py
/app
  api.py                   # FastAPI / backend entry
  ui_hooks.py
