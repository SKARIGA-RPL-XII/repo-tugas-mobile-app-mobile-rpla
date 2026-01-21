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
    transaction_date: str = Form(...),
    amount: float = Form(...),
    transaction_type: str = Form(...),
    account_type: str = Form(...),
    description: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_add_transaction(room_id, transaction_date, amount, transaction_type, account_type, description, Authorize)

@router.get("/transactions")
def get_transactions(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    return process_get_transaction(Authorize)


@router.put("/update-transaction")
def update_transaction(
    transaction_id: str = Form(...),
    transaction_date: str = Form(None),
    amount: float = Form(None),
    transaction_type: str = Form(None),
    account_type: str = Form(None),
    description: str = Form(None),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    return process_update_transaction(transaction_id, transaction_date, amount, transaction_type, account_type, description, Authorize)