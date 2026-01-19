from fastapi import APIRouter, Depends, Form, File, UploadFile
from fastapi.responses import JSONResponse
from app.services.user_service import process_update_password, process_profile, process_update_profile, process_logout
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.post("/logout")
def logout(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_logout(Authorize)

@router.get('/profile')
def profile(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_profile(Authorize)

@router.post('/update_profile')
def update_profile(
    fullname: str = Form(...),
    name: str = Form(...),
    email: str = Form(...),
    userimg: UploadFile = File(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_update_profile(fullname, name, email, userimg, Authorize)

@router.post('/update_password')
def update_password(
    old_password: str = Form(...),
    new_password: str = Form(...),
    confirm_password: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_update_password(old_password, new_password, confirm_password, Authorize)