from fastapi import FastAPI
from src.machine_learning.router import router as machine_learning_router

app = FastAPI()

app.include_router(machine_learning_router, prefix='/machine_learning', tags=['machine_learning'])
