from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_prompt_engineering():
    return {'message': 'Welcome to prompt_engineering module'}
