from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_decision_making_planning():
    return {'message': 'Welcome to decision_making_planning module'}
