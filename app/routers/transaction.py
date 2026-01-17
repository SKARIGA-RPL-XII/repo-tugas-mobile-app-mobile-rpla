from fastapi import APIRouter, Depends, Form
from fastapi.responses import JSONResponse
from app.services.transaction_service import process_add_transaction, process_get_transaction, process_update_transaction
from fastapi_jwt_auth import AuthJWT
from fastapi.security import HTTPBearer

router = APIRouter()
security = HTTPBearer()

@router.post("/add-transaction")
def add_transaction(
    room_id: str = Form(...),
    balance: float = Form(...),
    income: float = Form(...),
    expense: float = Form(...),
    description: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_add_transaction(room_id, balance, income, expense, description, Authorize)

@router.get("/transactions")
def get_transactions(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_get_transaction(Authorize)


@router.put("/update-transaction")
def update_transaction(
    balance: float = Form(None),
    income: float = Form(None),
    expense: float = Form(None),
    description: str = Form(None),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_update_transaction(balance, income, expense, description, Authorize)