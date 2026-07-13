from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_deploying_ai_agents():
    return {'message': 'Welcome to deploying_ai_agents module'}
