import sys
import os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(BASE_DIR)
import bcrypt
import datetime
from fastapi.security import HTTPBearer
from fastapi import FastAPI, Form, Depends
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from app.core import config
from app.routers import transaction, users, rooms, schedule, auth, activity_history, notifications

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

# ================= AKSES FILE =================
app.mount(
    "/assets",
    StaticFiles(directory="app/assets"),
    name="assets"
)

app.include_router(auth.router, tags=["Authentikasi"])
app.include_router(users.router, tags=["Users"])
app.include_router(rooms.router, tags=["Rooms"])
app.include_router(schedule.router, tags=["Schedule"])
app.include_router(transaction.router, tags=["Transactions"])
app.include_router(notifications.router, tags=["Notifications"])
app.include_router(activity_history.router, tags=["Activity History"])

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        # ssl_certfile="cert.pem",
        # ssl_keyfile="key.pem",
        reload=True,
    )
