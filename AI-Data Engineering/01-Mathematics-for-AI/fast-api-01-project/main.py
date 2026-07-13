from fastapi import FastAPI
from src.mathematics.router import router as mathematics_router

app = FastAPI()

app.include_router(mathematics_router, prefix='/mathematics', tags=['mathematics'])
