from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_nlp_and_transformers():
    return {'message': 'Welcome to nlp_and_transformers module'}
