import os
import bcrypt
import datetime
from fastapi import FastAPI, Form, Depends
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from app.core import config

app = FastAPI()


# ================= JWT CONFIG =================
class Settings(BaseModel):
    authjwt_secret_key: str = "o7XJcV8Z8Jm9dP0C5eH0zP3rZJZ3u6s4m0XxYy2H8LkPqTnBvA1D"


@AuthJWT.load_config
def get_config():
    return Settings()


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
