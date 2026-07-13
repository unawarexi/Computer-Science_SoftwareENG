from fastapi import FastAPI
from src.reinforcement_learning.router import router as reinforcement_learning_router

app = FastAPI()

app.include_router(reinforcement_learning_router, prefix='/reinforcement_learning', tags=['reinforcement_learning'])
