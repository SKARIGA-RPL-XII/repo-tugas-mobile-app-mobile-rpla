import os
import sys
import bcrypt
import datetime
from fastapi import FastAPI, Form, Depends
from fastapi.responses import JSONResponse
from fastapi.security import HTTPBearer
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from app.core import config
from app.routers import users, rooms, schedule, auth
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(BASE_DIR)

app = FastAPI()
security = HTTPBearer()

# ================= JWT CONFIG =================
class Settings(BaseModel):
    authjwt_secret_key: str = "o7XJcV8Z8Jm9dP0C5eH0zP3rZJZ3u6s4m0XxYy2H8LkPqTnBvA1D"
    authjwt_denylist_enabled: bool = True
    authjwt_denylist_token_checks: set ={"access"}

@AuthJWT.load_config
def get_config():
    return Settings()

# ================= ROOT =================
@app.get("/")
def read_root():
    return {"status": "API running"}


app.include_router(users.router, tags=["Users"])
app.include_router(rooms.router, tags=["Rooms"])
app.include_router(schedule.router, tags=["Schedule"])
app.include_router(auth.router, tags=["Authentikasi"])

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        ssl_certfile="cert.pem",
        ssl_keyfile="key.pem",
        reload=True,
    )
