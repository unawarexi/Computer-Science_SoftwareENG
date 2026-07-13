from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_model_context_protocol():
    return {'message': 'Welcome to model_context_protocol module'}
