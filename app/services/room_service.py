import datetime
import bcrypt
import random
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config

def process_add_room(room_name, Authorize):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        user_name = user_data.get("usernm", user_id)
        
        rooms_col = config.db.collection("rooms")
        doc_ref = rooms_col.document()
        room_id = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"
        
        invite_code = str(random.randint(100000, 999999))
        code_expiry = (datetime.datetime.utcnow() + datetime.timedelta(minutes=5)).isoformat() + "Z"

        room_doc = {
            "companyid": room_id,
            "companynm": room_name,
            "createddate": now,
            "createdby": user_id,
            "created_by_name": user_name,
            "updateddate": now,
            "updatedby": user_id,
            "isactive": True,
            "users": [
                {
                    "user_id": user_id,
                    "nickname": user_name,
                    "email": user_data.get("email"),
                    "fullname": user_data.get("fullname"),
                    "status": "owner",
                    "joined_date": now,
                }
            ],
            "invite_code": invite_code,
            "code_expiry": code_expiry,
            "code_created_date": now,
        }

        doc_ref.set(room_doc)

        return {
            "status": "success",
            "msg": "Berhasil menambahkan room",
            "room_id": room_id,
            "company_name": room_name,
            "invite_code": invite_code,
            "code_expiry": code_expiry,
        }
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan room: {error_msg}"},
        )

def process_get_users(Authorize):
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

def process_assign_room_users(room_id, user_ids, Authorize):
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

def process_get_room_details(Authorize):
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

def process_generate_invite_code(room_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        rooms_col = config.db.collection("rooms")
        room_doc = rooms_col.document(room_id).get()
        
        if not room_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan"},
            )
        
        room_data = room_doc.to_dict()
        
        if room_data.get("createdby") != user_id:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Hanya owner yang bisa generate code"},
            )
        
        invite_code = str(random.randint(100000, 999999))
        now = datetime.datetime.utcnow().isoformat() + "Z"
        code_expiry = (datetime.datetime.utcnow() + datetime.timedelta(minutes=5)).isoformat() + "Z"
        
        rooms_col.document(room_id).update({
            "invite_code": invite_code,
            "code_expiry": code_expiry,
            "code_created_date": now,
        })
        
        return {
            "status": "success",
            "msg": "Berhasil generate code baru",
            "invite_code": invite_code,
            "code_expiry": code_expiry,
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal generate code: {error_msg}"},
        )

def process_join_room_with_code(invite_code, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        user_name = user_data.get("usernm", user_id)
        
        rooms_col = config.db.collection("rooms")
        query = rooms_col.where("invite_code", "==", invite_code)
        docs = query.stream()
        
        room_id = None
        room_data = None
        
        for doc in docs:
            room_id = doc.id
            room_data = doc.to_dict()
            break
        
        if not room_id:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Code tidak valid"},
            )
        
        code_expiry = room_data.get("code_expiry", "")
        expiry_time = datetime.datetime.fromisoformat(code_expiry.replace("Z", ""))
        current_time = datetime.datetime.utcnow()
        
        if current_time > expiry_time:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Code sudah expired"},
            )
        
        existing_users = room_data.get("users", [])
        for existing_user in existing_users:
            if existing_user.get("user_id") == user_id:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": "Anda sudah bergabung dengan room ini"},
                )
        
        now = datetime.datetime.utcnow().isoformat() + "Z"
        new_user = {
            "user_id": user_id,
            "nickname": user_name,
            "email": user_data.get("email"),
            "fullname": user_data.get("fullname"),
            "status": "user",
            "joined_date": now,
        }
        
        existing_users.append(new_user)
        
        rooms_col.document(room_id).update({
            "users": existing_users,
            "updateddate": now,
        })
        
        return {
            "status": "success",
            "msg": "Berhasil bergabung dengan room",
            "room_id": room_id,
            "company_name": room_data.get("companynm"),
            "users": existing_users,
            "total_users": len(existing_users),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal bergabung ke room: {error_msg}"},
        )

def process_get_room_users(room_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        rooms_col = config.db.collection("rooms")
        room_doc = rooms_col.document(room_id).get()
        
        if not room_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan"},
            )
        
        room_data = room_doc.to_dict()
        
        users = room_data.get("users", [])
        user_in_room = False
        for user_info in users:
            if user_info.get("user_id") == user_id:
                user_in_room = True
                break
        
        if not user_in_room:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Anda bukan member dari room ini"},
            )
        
        return {
            "status": "success",
            "msg": "Berhasil mengambil daftar user",
            "room_id": room_id,
            "company_name": room_data.get("companynm"),
            "users": users,
            "total_users": len(users),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil daftar user: {error_msg}"},
        )

def process_remove_user_from_room(room_id, target_user_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        rooms_col = config.db.collection("rooms")
        room_doc = rooms_col.document(room_id).get()
        
        if not room_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Room tidak ditemukan"},
            )
        
        room_data = room_doc.to_dict()
        
        if room_data.get("createdby") != user_id:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Hanya owner yang bisa menghapus user"},
            )
        
        if target_user_id == room_data.get("createdby"):
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Tidak bisa menghapus owner"},
            )
        
        users = room_data.get("users", [])
        updated_users = [u for u in users if u.get("user_id") != target_user_id]
        
        if len(updated_users) == len(users):
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "User tidak ditemukan di room"},
            )
        
        now = datetime.datetime.utcnow().isoformat() + "Z"
        rooms_col.document(room_id).update({
            "users": updated_users,
            "updateddate": now,
        })
        
        return {
            "status": "success",
            "msg": "Berhasil menghapus user dari room",
            "room_id": room_id,
            "removed_user_id": target_user_id,
            "users": updated_users,
            "total_users": len(updated_users),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menghapus user: {error_msg}"},
        )