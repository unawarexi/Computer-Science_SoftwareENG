from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_deployment_and_cloud():
    return {'message': 'Welcome to deployment_and_cloud module'}
