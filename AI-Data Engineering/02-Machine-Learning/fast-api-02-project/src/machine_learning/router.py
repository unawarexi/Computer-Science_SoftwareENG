from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_machine_learning():
    return {'message': 'Welcome to machine_learning module'}
