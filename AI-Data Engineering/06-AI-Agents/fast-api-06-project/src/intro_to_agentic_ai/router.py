from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_intro_to_agentic_ai():
    return {'message': 'Welcome to intro_to_agentic_ai module'}
