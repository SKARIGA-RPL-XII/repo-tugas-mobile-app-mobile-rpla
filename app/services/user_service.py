import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config
from uuid import uuid4 
import os
import shutil

denylist = set()

@AuthJWT.token_in_denylist_loader
def check_in_token_denylist(decrypted_token):
    jti = decrypted_token["jti"]
    return jti in denylist

def process_profile(Authorize):
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

def process_update_password(old_password, new_password, confirm_password, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()

        if not user_id:
            return JSONResponse(status_code=401, content={"status": "error", "msg": "Unauthorized"})

        users_ref = config.db.collection("users")
        user_doc = users_ref.document(user_id).get()

        if not user_doc.exists:
            return JSONResponse(status_code=404, content={"status": "error", "msg": "User not found"})

        user_data = user_doc.to_dict()
        stored_password = user_data.get("password")

        if not bcrypt.checkpw(
            old_password.encode("utf-8"),
            stored_password.encode("utf-8")
        ):
            return JSONResponse(status_code=400, content={"status": "error", "msg": "Password lama salah"})

        if new_password != confirm_password:
            return JSONResponse(status_code=400, content={"status": "error", "msg": "Konfirmasi password tidak sama"})

        new_hashed = bcrypt.hashpw(
            new_password.encode("utf-8"),
            bcrypt.gensalt()
        ).decode("utf-8")

        users_ref.document(user_id).update({
            "password": new_hashed
        })

        return {
            "status": "success",
            "msg": "Password berhasil diperbarui"
        }

    except Exception as e:
        print("Error updating password:", str(e))
        return JSONResponse(
            status_code=500,
            content={"status": "error", "msg": "Internal Server Error"}
        )

def process_update_profile(
    fullname: str,
    name: str,
    email: str,
    userimg: str,
    Authorize
):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        if user_id is None:
            return JSONResponse(status_code=401, content={"msg": "Unauthorized"})
        if userimg.content_type not in ["image/png", "image/jpg", "image/jpeg"]:
            return JSONResponse(status_code=400, content={"status": "error", "msg": "File harus berformat png jpg dan jpeg"})
        users_ref = config.db.collection("users")
        users_doc = users_ref.document(user_id)

        if not users_doc.get().exists:
            return JSONResponse(status_code=404, content={"msg": "User not found"})
        
        UPLOAD_DIR = "app/assets/img"
        os.makedirs(UPLOAD_DIR, exist_ok=True)

        ext = userimg.filename.split(".")[-1].lower()
        if ext not in ["png", "jpg", "jpeg"]:
            return JSONResponse(
                status_code=400,
                content={"msg": "File harus berformat png, jpg, atau jpeg"}
            )

        filename = f"{uuid4()}.{ext}"
        filepath = os.path.join(UPLOAD_DIR, filename)

        with open(filepath, "wb") as buffer:
            shutil.copyfileobj(userimg.file, buffer)

        update_data = {
            "fullname": fullname,
            "usernm": name,
            "email": email,
            "userimg": f"/assets/img/{filename}",
        }
        users_doc.update(update_data)
        return {"status":"success", "msg":"Profile updated successfully", "data":update_data}
            
    except Exception as e:
        print("Error updating profile:", str(e))
        return JSONResponse(status_code=401, content={"msg": "Internal Server Error"})

def process_logout(Authorize):
    Authorize.jwt_required()
    jti = Authorize.get_raw_jwt()["jti"]
    denylist.add(jti)
    return {"status":"success", "content":"berhasil logout"}
