from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_reinforcement_learning_agents():
    return {'message': 'Welcome to reinforcement_learning_agents module'}
