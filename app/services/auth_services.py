import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config
import os

def process_register(fullname, name, email, password, confirm_password):
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
        image = f"/assets/img/default.png"

        user_doc = {
            "id": uid,
            "fullname": fullname,
            "usernm": name,
            "userimg": image,
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

def process_login(email, password, Authorize):
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