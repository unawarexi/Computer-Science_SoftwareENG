from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_computer_vision():
    return {'message': 'Welcome to computer_vision module'}
