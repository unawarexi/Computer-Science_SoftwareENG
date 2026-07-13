from fastapi import FastAPI
from src.intro_to_agentic_ai.router import router as intro_to_agentic_ai_router
from src.ai_ml_fundamentals.router import router as ai_ml_fundamentals_router
from src.ai_agent_frameworks.router import router as ai_agent_frameworks_router
from src.large_language_models.router import router as large_language_models_router
from src.understanding_ai_agents.router import router as understanding_ai_agents_router
from src.memory_and_knowledge.router import router as memory_and_knowledge_router
from src.decision_making_planning.router import router as decision_making_planning_router
from src.prompt_engineering.router import router as prompt_engineering_router
from src.reinforcement_learning_agents.router import router as reinforcement_learning_agents_router
from src.multi_agent_systems.router import router as multi_agent_systems_router
from src.rag.router import router as rag_router
from src.agent_tools_functions.router import router as agent_tools_functions_router
from src.deploying_ai_agents.router import router as deploying_ai_agents_router
from src.model_context_protocol.router import router as model_context_protocol_router

app = FastAPI()

app.include_router(intro_to_agentic_ai_router, prefix='/intro_to_agentic_ai', tags=['intro_to_agentic_ai'])
app.include_router(ai_ml_fundamentals_router, prefix='/ai_ml_fundamentals', tags=['ai_ml_fundamentals'])
app.include_router(ai_agent_frameworks_router, prefix='/ai_agent_frameworks', tags=['ai_agent_frameworks'])
app.include_router(large_language_models_router, prefix='/large_language_models', tags=['large_language_models'])
app.include_router(understanding_ai_agents_router, prefix='/understanding_ai_agents', tags=['understanding_ai_agents'])
app.include_router(memory_and_knowledge_router, prefix='/memory_and_knowledge', tags=['memory_and_knowledge'])
app.include_router(decision_making_planning_router, prefix='/decision_making_planning', tags=['decision_making_planning'])
app.include_router(prompt_engineering_router, prefix='/prompt_engineering', tags=['prompt_engineering'])
app.include_router(reinforcement_learning_agents_router, prefix='/reinforcement_learning_agents', tags=['reinforcement_learning_agents'])
app.include_router(multi_agent_systems_router, prefix='/multi_agent_systems', tags=['multi_agent_systems'])
app.include_router(rag_router, prefix='/rag', tags=['rag'])
app.include_router(agent_tools_functions_router, prefix='/agent_tools_functions', tags=['agent_tools_functions'])
app.include_router(deploying_ai_agents_router, prefix='/deploying_ai_agents', tags=['deploying_ai_agents'])
app.include_router(model_context_protocol_router, prefix='/model_context_protocol', tags=['model_context_protocol'])
