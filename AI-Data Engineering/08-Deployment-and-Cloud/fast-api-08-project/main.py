from fastapi import FastAPI
from src.deployment_and_cloud.router import router as deployment_and_cloud_router

app = FastAPI()

app.include_router(deployment_and_cloud_router, prefix='/deployment_and_cloud', tags=['deployment_and_cloud'])
