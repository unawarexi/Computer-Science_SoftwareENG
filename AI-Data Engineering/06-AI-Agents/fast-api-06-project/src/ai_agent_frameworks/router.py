from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_ai_agent_frameworks():
    return {'message': 'Welcome to ai_agent_frameworks module'}
