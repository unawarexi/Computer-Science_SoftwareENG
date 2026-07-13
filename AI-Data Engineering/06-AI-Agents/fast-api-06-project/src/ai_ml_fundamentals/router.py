from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_ai_ml_fundamentals():
    return {'message': 'Welcome to ai_ml_fundamentals module'}
