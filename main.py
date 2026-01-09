import os
import bcrypt
import datetime
from fastapi import FastAPI, Form
# from fastapi_jwt_auth import AuthJWT
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse, JSONResponse
from app.core import config

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

PG_TIMEZONE = 'Asia/jakarta'

@app.get("/")
def read_root():
    return {"Hello": "World"}

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
            status_code=500,
            content={"status": "error", "msg": "Internal server error"}
        )

    try:
        pwd = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        stored = pwd.decode('utf-8')

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
        
        return RedirectResponse(url="/login", msg="Berhasil registrasi", status_code=302)
        
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menyimpan user: {error_msg}"}
        )
@app.get("/login")
def login_page():
    return {"msg": "Silakan login"}

@app.post("/login")
def login(email: str = Form(...), password: str = Form(...)):
    return {"status": "success", "msg": "Login berhasil"}
    
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, ssl_certfile="cert.pem", ssl_keyfile="key.pem", reload=True)
