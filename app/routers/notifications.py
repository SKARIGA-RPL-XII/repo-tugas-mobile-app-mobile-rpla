from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.notification_service import (
    process_get_notifications,
    process_approve_schedule,
    process_reject_schedule,
    process_get_notification_detail
)
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.get("/notifications")
def get_notifications(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_notifications(Authorize)

@router.get("/notification-detail/{notification_id}")
def get_notification_detail(
    notification_id: str,
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_get_notification_detail(notification_id, Authorize)

@router.post("/approve-schedule")
def approve_schedule(
    notification_id: str = Form(...),
    schedule_id: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_approve_schedule(notification_id, schedule_id, Authorize)

@router.post("/reject-schedule")
def reject_schedule(
    notification_id: str = Form(...),
    schedule_id: str = Form(...),
    reason: str = Form(""),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_reject_schedule(notification_id, schedule_id, reason, Authorize)
