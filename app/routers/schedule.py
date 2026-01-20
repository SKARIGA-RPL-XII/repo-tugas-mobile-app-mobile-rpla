from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.schedule_service import process_add_schedule, process_get_schedule_detail, process_delete_schedule
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.post("/add-schedule")
def add_schedule(
    schedule_name: str = Form(...),
    description: str = Form(...),
    user_ids: str = Form(...),
    remind_date: str = Form(...),
    remind_hours: int = Form(...),
    remind_active: bool = Form(True),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_add_schedule(schedule_name, description, user_ids, remind_date, remind_hours, remind_active, Authorize)

@router.get("/schedule-detail/{schedule_id}")
def get_schedule_detail(
    schedule_id: str,
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_schedule_detail(schedule_id, Authorize)

@router.delete("/delete-schedule")
def delete_schedule(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_delete_schedule(Authorize)