from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_rag():
    return {'message': 'Welcome to rag module'}
