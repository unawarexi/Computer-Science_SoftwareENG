from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_large_language_models():
    return {'message': 'Welcome to large_language_models module'}
