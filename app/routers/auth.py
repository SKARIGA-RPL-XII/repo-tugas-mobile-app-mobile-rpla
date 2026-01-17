from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.auth_services import process_register, process_login
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.post('/register')
def registrasi(
    fullname: str = Form(...),
    name: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    confirm_password: str = Form(...),
):
    return process_register(fullname, name, email, password, confirm_password)

@router.post("/login")
def login(
    email: str = Form(...),
    password: str = Form(...),
    Authorize: AuthJWT = Depends(),
):
    return process_login(email, password, Authorize)