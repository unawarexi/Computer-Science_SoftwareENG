from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_agent_tools_functions():
    return {'message': 'Welcome to agent_tools_functions module'}
