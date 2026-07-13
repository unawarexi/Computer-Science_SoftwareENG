from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_multi_agent_systems():
    return {'message': 'Welcome to multi_agent_systems module'}
