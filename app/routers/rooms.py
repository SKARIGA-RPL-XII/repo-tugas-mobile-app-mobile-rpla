from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.room_service import (
    process_add_room, 
    process_get_users, 
    process_assign_room_users, 
    process_get_room_details,
    process_generate_invite_code,
    process_join_room_with_code,
    process_get_room_users,
    process_remove_user_from_room
)
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.post("/add-room")
def add_room(
    room_name: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_add_room(room_name, Authorize)

@router.get("/users")
def get_users(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_users(Authorize)

@router.post("/assign-room-users")
def assign_room_users(
    room_id: str = Form(...),
    user_ids: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_assign_room_users(room_id, user_ids, Authorize)

@router.get("/room-detail")
def get_room_detail(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_room_details(Authorize)

@router.post("/generate-invite-code")
def generate_invite_code(
    room_id: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_generate_invite_code(room_id, Authorize)

@router.post("/join-room")
def join_room(
    invite_code: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_join_room_with_code(invite_code, Authorize)

@router.get("/room-users/{room_id}")
def get_room_users(
    room_id: str,
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_room_users(room_id, Authorize)

@router.delete("/remove-user/{room_id}/{user_id}")
def remove_user_from_room(
    room_id: str,
    user_id: str,
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_remove_user_from_room(room_id, user_id, Authorize)
    