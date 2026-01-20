import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config

def process_add_schedule(schedule_name, description, user_ids, remind_date, remind_hours, remind_active, Authorize):
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
        
        notifications_col = config.db.collection("notifications")
        for user_info in scheduled_users:
            notification_doc = {
                "user_id": user_info.get("user_id"),
                "schedule_id": schedule_id,
                "schedule_name": schedule_name,
                "description": description,
                "assigned_users": scheduled_users,
                "created_by": created_by_name,
                "status": "pending",
                "created_date": now,
                "updated_date": now,
            }
            notifications_col.add(notification_doc)
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menambahkan schedule: {error_msg}"},
        )

def process_get_schedule_detail(schedule_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        schedules_col = config.db.collection("schedules")
        doc = schedules_col.document(schedule_id).get()
        
        if not doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Schedule tidak ditemukan"},
            )
        
        schedule_data = doc.to_dict()
        
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

def process_delete_schedule(Authorize):
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
