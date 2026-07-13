from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_generative_ai_and_gans():
    return {'message': 'Welcome to generative_ai_and_gans module'}
