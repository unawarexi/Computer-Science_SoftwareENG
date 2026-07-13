from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_reinforcement_learning():
    return {'message': 'Welcome to reinforcement_learning module'}
