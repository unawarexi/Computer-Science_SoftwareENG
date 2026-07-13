from fastapi import FastAPI
from src.nlp_and_transformers.router import router as nlp_and_transformers_router
from src.computer_vision.router import router as computer_vision_router
from src.generative_ai_and_gans.router import router as generative_ai_and_gans_router
from src.time_series_forecasting.router import router as time_series_forecasting_router
from src.ai_research_and_trends.router import router as ai_research_and_trends_router

app = FastAPI()

app.include_router(nlp_and_transformers_router, prefix='/nlp_and_transformers', tags=['nlp_and_transformers'])
app.include_router(computer_vision_router, prefix='/computer_vision', tags=['computer_vision'])
app.include_router(generative_ai_and_gans_router, prefix='/generative_ai_and_gans', tags=['generative_ai_and_gans'])
app.include_router(time_series_forecasting_router, prefix='/time_series_forecasting', tags=['time_series_forecasting'])
app.include_router(ai_research_and_trends_router, prefix='/ai_research_and_trends', tags=['ai_research_and_trends'])
