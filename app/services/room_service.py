import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config

def process_add_room(room_name, Authorize):
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