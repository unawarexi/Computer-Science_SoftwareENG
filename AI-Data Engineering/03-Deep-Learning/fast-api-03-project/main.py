from fastapi import FastAPI
from src.deep_learning.router import router as deep_learning_router

app = FastAPI()

app.include_router(deep_learning_router, prefix='/deep_learning', tags=['deep_learning'])
