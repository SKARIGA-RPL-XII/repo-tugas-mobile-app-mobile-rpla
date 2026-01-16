import sys
import os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(BASE_DIR)
import bcrypt
import datetime
# sementara untuk testing
from fastapi.security import HTTPBearer

from fastapi import FastAPI, Form, Depends
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from app.core import config

app = FastAPI()
# untuk testing
security = HTTPBearer()

# ================= JWT CONFIG =================
class Settings(BaseModel):
    authjwt_secret_key: str = "o7XJcV8Z8Jm9dP0C5eH0zP3rZJZ3u6s4m0XxYy2H8LkPqTnBvA1D"
    authjwt_denylist_enabled: bool = True
    authjwt_denylist_token_checks: set = {"access"}
    authjwt_denylist_enabled: bool = True
    authjwt_denylist_token_checks: set ={"access"}

denylist = set()

denylist = set()
@AuthJWT.token_in_denylist_loader
def check_in_token_denylist(decrypted_token):
    jti = decrypted_token["jti"]
    return jti in denylist

@AuthJWT.load_config
def get_config():
    return Settings()

@AuthJWT.token_in_denylist_loader
def check_if_token_in_denylist(decrypted_token):
    jti = decrypted_token["jti"]
    return jti in denylist
    
# ================= ROOT =================
@app.get("/")
def read_root():
    return {"status": "API running"}

# ================= REGISTER =================
@app.post("/registrasi")
def registrasi(
    fullname: str = Form(...),
    name: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    confirm_password: str = Form(...),
):
    if not fullname.strip() or not name.strip() or not email.strip() or not password:
        return {"status": "error", "msg": "Isi semua form"}
    if password != confirm_password:
        return {"status": "error", "msg": "Password harus sama"}
    if "@" not in email or "." not in email:
        return {"status": "error", "msg": "Format email tidak valid"}

    if config.db is None:
        return JSONResponse(
            status_code=500, content={"status": "error", "msg": "Internal server error"}
        )

    try:
        pwd = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
        stored = pwd.decode("utf-8")

        users_col = config.db.collection("users")
        doc_ref = users_col.document()
        uid = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"

        user_doc = {
            "id": uid,
            "fullname": fullname,
            "usernm": name,
            "password": stored,
            "email": email,
            "createddate": now,
            "createdby": fullname,
            "updateddate": now,
            "updatedby": fullname,
            "isactive": True,
        }

        doc_ref.set(user_doc)

        return {"status": "success", "msg": "Berhasil registrasi"}

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menyimpan user: {error_msg}"},
        )


# ================= LOGIN =================
@app.post("/login")
def login(
    email: str = Form(...),
    password: str = Form(...),
    Authorize: AuthJWT = Depends(),
):
    users_ref = config.db.collection("users")
    docs = users_ref.where("email", "==", email).limit(1).stream()

    user = None
    for doc in docs:
        user = doc.to_dict()

    if not user:
        return JSONResponse(status_code=401, content={"msg": "Email tidak terdaftar"})

    hashed = user["password"].encode()

    if not bcrypt.checkpw(password.encode(), hashed):
        return JSONResponse(status_code=401, content={"msg": "Password salah"})

    token = Authorize.create_access_token(
        subject=str(user["id"]), expires_time=datetime.timedelta(hours=2)
    )

    return {"status": "success", "access_token": token, "token_type": "bearer"}

# ================= ADD ROOM (SLIDE 1) =================
@app.post("/add-room")
def add_room(
    room_name: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()
        rooms_col = config.db.collection("rooms")
        doc_ref = rooms_col.document()
        room_id = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"

        room_doc = {
            "companyid": room_id,
            "companynm": room_name,
            "createddate": now,
            "createdby": user_id,
            "updateddate": now,
            "updatedby": user_id,
            "isactive": True,
            "users": [],
        }

        doc_ref.set(room_doc)

        return {
            "status": "success",
            "msg": "Berhasil menambahkan room",
            "room_id": room_id,
            "company_name": room_name,
        }
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan room: {error_msg}"},
        )


# ================= GET USERS (SLIDE 2) =================
@app.get("/users")
def get_users(Authorize: AuthJWT = Depends(), token: str = Depends(security)):
    try:
        Authorize.jwt_required()

        users_col = config.db.collection("users")
        docs = users_col.stream()

        users_list = []
        for doc in docs:
            user_data = doc.to_dict()
            users_list.append({
                "user_id": user_data.get("id"),
                "nickname": user_data.get("usernm"),
                "email": user_data.get("email"),
                "fullname": user_data.get("fullname"),
            })

        if not users_list:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Tidak ada user"}
            )

        return {
            "status": "success",
            "msg": "Berhasil mengambil daftar user",
            "data": users_list,
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil user: {error_msg}"},
        )


# ================= ASSIGN USERS TO ROOM (SLIDE 3) =================
@app.post("/assign-room-users")
def assign_room_users(
    room_id: str = Form(...),
    user_ids: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    try:
        Authorize.jwt_required()

        current_user = Authorize.get_jwt_subject()

        if user_ids.startswith("["):
            import json
            selected_user_ids = json.loads(user_ids)
        else:
            selected_user_ids = [uid.strip() for uid in user_ids.split(",")]

        if not selected_user_ids:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Pilih minimal satu user"},
            )

        rooms_col = config.db.collection("rooms")
        room_ref = rooms_col.document(room_id)
        room_doc = room_ref.get()

        if not room_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan"},
            )

        users_col = config.db.collection("users")
        assigned_users = []

        for user_id in selected_user_ids:
            user_doc = users_col.document(user_id).get()
            if user_doc.exists:
                user_data = user_doc.to_dict()
                assigned_users.append({
                    "user_id": user_id,
                    "nickname": user_data.get("usernm"),
                    "email": user_data.get("email"),
                    "fullname": user_data.get("fullname"),
                })

        now = datetime.datetime.utcnow().isoformat() + "Z"
        room_ref.update({
            "users": assigned_users,
            "updateddate": now,
            "updatedby": current_user,
        })

        updated_room = room_ref.get().to_dict()

        return {
            "status": "success",
            "msg": "Berhasil menambahkan user ke room",
            "room_id": room_id,
            "company_name": updated_room.get("companynm"),
            "assigned_users": assigned_users,
            "total_users": len(assigned_users),
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan user ke room: {error_msg}"},
        )


# ================= GET ROOM DETAIL (REVIEW SLIDE 3) =================
@app.get("/room-detail")
def get_room_detail(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()

        rooms_col = config.db.collection("rooms")
        query = rooms_col.where("createdby", "==", user_id).limit(1)
        docs = query.stream()

        room_id = None
        room_data = None

        for doc in docs:
            room_id = doc.id
            room_data = doc.to_dict()

        if not room_id or not room_data:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan untuk user ini"},
            )

        return {
            "status": "success",
            "msg": "Berhasil mengambil detail room",
            "room_id": room_id,
            "company_name": room_data.get("companynm"),
            "users": room_data.get("users", []),
            "total_users": len(room_data.get("users", [])),
            "created_date": room_data.get("createddate"),
            "created_by": room_data.get("createdby"),
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil detail room: {error_msg}"},
        )
# ================= ADD TRANSACTION =================
@app.post("/add-transaction")
def add_transaction(
    room_id: str = Form(...),
    balance: float = Form(...),
    income: float = Form(...),
    expense: float = Form(...),
    description: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    try:
        Authorize.jwt_required()

        current_user = Authorize.get_jwt_subject()

        if not room_id.strip():
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Room ID tidak boleh kosong"},
            )

        if balance < 0 or income < 0 or expense < 0:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Nilai balance, income, dan expense tidak boleh negatif"},
            )

        rooms_col = config.db.collection("rooms")
        room_ref = rooms_col.document(room_id)
        room_doc = room_ref.get()

        if not room_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan"},
            )

        room_data = room_doc.to_dict()
        company_name = room_data.get("companynm")

        users_col = config.db.collection("users")
        user_doc = users_col.document(current_user).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        created_by_name = user_data.get("usernm", current_user)

        transactions_col = config.db.collection("transactions")
        doc_ref = transactions_col.document()
        transaction_id = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"

        transaction_doc = {
            "transaction_id": transaction_id,
            "room_id": room_id,
            "company_name": company_name,
            "balance": balance,
            "income": income,
            "expense": expense,
            "description": description,
            "createddate": now,
            "createdby": created_by_name,
            "datemodified": now,
            "modifiedby": created_by_name,
            "isactive": True,
        }

        doc_ref.set(transaction_doc)

        return {
            "status": "success",
            "msg": "Berhasil menambahkan transaction",
            "transaction_id": transaction_id,
            "room_id": room_id,
            "company_name": company_name,
            "balance": balance,
            "income": income,
            "expense": expense,
            "description": description,
            "createddate": now,
            "createdby": created_by_name,
        }

    except ValueError:
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": "Format nilai balance, income, dan expense harus berupa angka"},
        )
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan transaction: {error_msg}"},
        )


# ================= GET TRANSACTIONS BY ROOM =================
@app.get("/transactions")
def get_transactions(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security),
):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()

        rooms_col = config.db.collection("rooms")
        query = rooms_col.where("createdby", "==", user_id).limit(1)
        docs = query.stream()

        room_id = None
        room_data = None

        for doc in docs:
            room_id = doc.id
            room_data = doc.to_dict()

        if not room_id or not room_data:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan untuk user ini"},
            )

        company_name = room_data.get("companynm")

        transactions_col = config.db.collection("transactions")
        trans_docs = transactions_col.where("room_id", "==", room_id).stream()

        transactions_list = []
        for doc in trans_docs:
            trans_data = doc.to_dict()
            transactions_list.append({
                "transaction_id": trans_data.get("transaction_id"),
                "balance": trans_data.get("balance"),
                "income": trans_data.get("income"),
                "expense": trans_data.get("expense"),
                "description": trans_data.get("description"),
                "company_name": trans_data.get("company_name"),
                "createddate": trans_data.get("createddate"),
                "createdby": trans_data.get("createdby"),
                "datemodified": trans_data.get("datemodified"),
                "modifiedby": trans_data.get("modifiedby"),
            })

        transactions_list.sort(
            key=lambda x: x["createddate"],
            reverse=True
        )

        return {
            "status": "success",
            "msg": "Berhasil mengambil transaction",
            "room_id": room_id,
            "company_name": company_name,
            "total_transactions": len(transactions_list),
            "data": transactions_list,
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil transaction: {error_msg}"},
        )


# ================= UPDATE TRANSACTION =================
@app.put("/update-transaction")
def update_transaction(
    balance: float = Form(None),
    income: float = Form(None),
    expense: float = Form(None),
    description: str = Form(None),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()

        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        modified_by_name = user_data.get("usernm", user_id)

        transactions_col = config.db.collection("transactions")
        query = transactions_col.where("createdby", "==", modified_by_name).order_by("createddate", direction=1).limit(1)
        docs = query.stream()

        transaction_id = None
        trans_data = None
        
        for doc in docs:
            transaction_id = doc.id
            trans_data = doc.to_dict()

        if not transaction_id or not trans_data:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Transaction tidak ditemukan untuk user ini"},
            )

        update_data = {
            "datemodified": datetime.datetime.utcnow().isoformat() + "Z",
            "modifiedby": modified_by_name,
        }

        if balance is not None:
            if balance < 0:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": "Balance tidak boleh negatif"},
                )
            update_data["balance"] = balance

        if income is not None:
            if income < 0:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": "Income tidak boleh negatif"},
                )
            update_data["income"] = income

        if expense is not None:
            if expense < 0:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": "Expense tidak boleh negatif"},
                )
            update_data["expense"] = expense

        trans_ref = transactions_col.document(transaction_id)
        trans_ref.update(update_data)

        updated_trans = trans_ref.get().to_dict()

        return {
            "status": "success",
            "msg": "Berhasil mengupdate transaction",
            "transaction_id": transaction_id,
            "room_id": updated_trans.get("room_id"),
            "company_name": updated_trans.get("company_name"),
            "balance": updated_trans.get("balance"),
            "income": updated_trans.get("income"),
            "expense": updated_trans.get("expense"),
            "description": updated_trans.get("description"),
            "datemodified": updated_trans.get("datemodified"),
            "modifiedby": modified_by_name,
        }

    except ValueError:
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": "Format nilai harus berupa angka"},
        )
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengupdate transaction: {error_msg}"},
        )
    
# ================= PROFILE =================
@app.get('/profile')
def profile(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        if user_id is None:
            return JSONResponse(status_code=401, content={"msg": "Unauthorized"})
        users_ref = config.db.collection("users")
        doc = users_ref.document(user_id).get()
        if not doc.exists:
            return JSONResponse(status_code=404, content={"msg": "User not found"})

        user_data = doc.to_dict()
        return {"status": "success", "data": user_data}
    except Exception as e:
        print("Error fetching profile:", str(e))
        return JSONResponse(status_code=401, content={"msg": "Internal Server Error"})

# ================= UPDATE PROFIL =================
@app.put('/update_profile')
def update_profile(
    fullname: str = Form(...),
    name: str = Form(...),
    email: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:    
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        if user_id is None:
            return JSONResponse(status_code=401, content={"msg": "Unauthorized"})
        users_ref = config.db.collection("users")
        users_doc = users_ref.document(user_id)

        if not users_doc.get().exists:
            return JSONResponse(status_code=404, content={"msg": "User not found"})
        
        update_data = {
            "fullname": fullname,
            "usernm": name,
            "email": email,
            "updateddate": datetime.datetime.utcnow().isoformat() + "Z",
        }
        users_doc.update(update_data)
        return {"status":"success", "msg":"Profile updated successfully", "user_id": user_id, "data":update_data}
            
    except Exception as e:
        print("Error updating profile:", str(e))
        return JSONResponse(status_code=401, content={"msg": "Internal Server Error"})

# ================= UPDATE PASSWORD =================
@app.put('/update_password')
def update_password(
    password: str = Form(...),
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        if user_id is None:
            return JSONResponse(status_code=401, content={"msg": "Unauthorized"})
        users_ref = config.db.collection("users")
        users_doc = users_ref.document(user_id)

        if not users_doc.get().exists:
            return JSONResponse(status_code=404, content={"msg": "User not found"})
        
        pwd = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
        stored = pwd.decode("utf-8")
        
        update_data = {
            "password": stored,
            "updateddate": datetime.datetime.utcnow().isoformat() + "Z",
        }
        users_doc.update(update_data)
        return {"status":"success", "msg":"Password updated successfully", "user_id": user_id, "data":update_data}

    except Exception as e:
        print("Error updating password:", str(e))
        return JSONResponse(status_code=401, content={"msg": "Internal Server Error"})

# ================= ADD SCHEDULE =================
@app.post("/add-schedule")
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
    try:
        Authorize.jwt_required()
        
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        created_by_name = user_data.get("usernm", user_id)
        
        if not schedule_name.strip():
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Schedule name tidak boleh kosong"},
            )
        
        if not description.strip():
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Description tidak boleh kosong"},
            )
        
        if user_ids.startswith("["):
            import json
            selected_user_ids = json.loads(user_ids)
        else:
            selected_user_ids = [uid.strip() for uid in user_ids.split(",")]
        
        if not selected_user_ids:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Pilih minimal satu user"},
            )
        
        if remind_hours < 0 or remind_hours > 23:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Hours harus antara 0-23"},
            )
        
        scheduled_users = []
        for uid in selected_user_ids:
            user_doc = users_col.document(uid).get()
            if user_doc.exists:
                user_data = user_doc.to_dict()
                scheduled_users.append({
                    "user_id": uid,
                    "nickname": user_data.get("usernm"),
                    "email": user_data.get("email"),
                    "fullname": user_data.get("fullname"),
                })
        
        if not scheduled_users:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "User yang dipilih tidak ditemukan"},
            )
        
        schedules_col = config.db.collection("schedules")
        doc_ref = schedules_col.document()
        schedule_id = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"
        
        schedule_doc = {
            "schedule_id": schedule_id,
            "schedule_name": schedule_name,
            "description": description,
            "assigned_users": scheduled_users,
            "remind_date": remind_date,
            "remind_hours": remind_hours,
            "remind_active": remind_active,
            "createddate": now,
            "createdby": created_by_name,
            "updateddate": now,
            "updatedby": created_by_name,
            "isactive": True,
        }
        
        doc_ref.set(schedule_doc)
        
        return {
            "status": "success",
            "msg": "Berhasil menambahkan schedule",
            "schedule_id": schedule_id,
            "schedule_name": schedule_name,
            "description": description,
            "assigned_users": scheduled_users,
            "remind_date": remind_date,
            "remind_hours": remind_hours,
            "remind_active": remind_active,
            "createddate": now,
            "createdby": created_by_name,
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan schedule: {error_msg}"},
        )

# ================= GET SCHEDULE DETAIL =================
@app.get("/schedule-detail")
def get_schedule_detail(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        schedules_col = config.db.collection("schedules")
        query = schedules_col.where("createdby", "==", user_id).limit(1)
        docs = query.stream()
        
        schedule_id = None
        schedule_data = None
        
        for doc in docs:
            schedule_id = doc.id
            schedule_data = doc.to_dict()
        
        if not schedule_id or not schedule_data:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Schedule tidak ditemukan untuk user ini"},
            )
        
        return {
            "status": "success",
            "msg": "Berhasil mengambil detail schedule",
            "schedule_id": schedule_id,
            "schedule_name": schedule_data.get("schedule_name"),
            "description": schedule_data.get("description"),
            "assigned_users": schedule_data.get("assigned_users", []),
            "total_users": len(schedule_data.get("assigned_users", [])),
            "remind_date": schedule_data.get("remind_date"),
            "remind_hours": schedule_data.get("remind_hours"),
            "remind_active": schedule_data.get("remind_active"),
            "created_date": schedule_data.get("createddate"),
            "created_by": schedule_data.get("createdby"),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil schedule: {error_msg}"},
        )

# ================= DELETE SCHEDULE =================
@app.delete("/delete-schedule")
def delete_schedule(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    try:
        Authorize.jwt_required()
        
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        deleted_by_name = user_data.get("usernm", user_id)
        
        schedules_col = config.db.collection("schedules")
        query = schedules_col.where("createdby", "==", deleted_by_name).limit(1)
        docs = query.stream()
        
        schedule_id = None
        schedule_data = None
        
        for doc in docs:
            schedule_id = doc.id
            schedule_data = doc.to_dict()
        
        if not schedule_id or not schedule_data:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Schedule tidak ditemukan untuk user ini"},
            )
        
        schedules_col.document(schedule_id).delete()
        
        return {
            "status": "success",
            "msg": "Berhasil menghapus schedule",
            "schedule_id": schedule_id,
            "schedule_name": schedule_data.get("schedule_name"),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menghapus schedule: {error_msg}"},
        )

# ================= LOG OUT =================
@app.post("/logout")
def logout(
    Authorize: AuthJWT = Depends(),
    token: str = Depends(security)
):
    Authorize.jwt_required()
    jti = Authorize.get_raw_jwt()["jti"]
    denylist.add(jti)
    return {"status":"success", "content":"berhasil logout"}

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
