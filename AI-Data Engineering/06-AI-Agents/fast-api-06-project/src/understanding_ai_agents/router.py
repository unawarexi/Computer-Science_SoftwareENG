from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_understanding_ai_agents():
    return {'message': 'Welcome to understanding_ai_agents module'}
