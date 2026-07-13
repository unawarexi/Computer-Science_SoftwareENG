from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_mathematics():
    return {'message': 'Welcome to mathematics module'}
