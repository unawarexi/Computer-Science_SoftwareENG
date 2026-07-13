from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_deep_learning():
    return {'message': 'Welcome to deep_learning module'}
