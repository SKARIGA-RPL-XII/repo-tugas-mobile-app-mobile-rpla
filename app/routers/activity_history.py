from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.activity_history_service import (
    get_activity_history,
    update_activity_status,
    get_activity_stats,
)
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()


@router.get("/activity-history")
def get_activity_histories(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    """
    Mendapatkan semua activity history untuk user yang sedang login
    """
    Authorize.jwt_required()
    user_id = Authorize.get_jwt_subject()
    
    return get_activity_history(user_id)


@router.put("/activity-history")
def update_activity_history(
    status: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    """
    Update status activity history terbaru (pending -> accept/declined)
    
    Form Parameters:
    - status: Status baru (accept, declined, pending)
    """
    Authorize.jwt_required()
    user_id = Authorize.get_jwt_subject()
    
    return update_activity_status(user_id, status)


@router.get("/activity-history/stats/summary")
def get_my_activity_stats(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    """
    Mendapatkan statistik aktivitas user yang sedang login
    """
    Authorize.jwt_required()
    user_id = Authorize.get_jwt_subject()
    
    return get_activity_stats(user_id)
