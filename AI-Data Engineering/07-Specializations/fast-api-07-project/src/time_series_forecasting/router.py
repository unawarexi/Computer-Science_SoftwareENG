from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_time_series_forecasting():
    return {'message': 'Welcome to time_series_forecasting module'}
