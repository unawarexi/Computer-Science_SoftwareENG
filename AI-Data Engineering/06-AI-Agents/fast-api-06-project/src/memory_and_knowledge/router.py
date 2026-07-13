from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_memory_and_knowledge():
    return {'message': 'Welcome to memory_and_knowledge module'}
