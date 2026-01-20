import datetime
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config

def process_get_notifications(Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        user_email = user_data.get("email", "")
        
        notifications_col = config.db.collection("notifications")
        
        query = notifications_col.where("user_id", "==", user_id).where("status", "==", "pending")
        docs = query.stream()
        
        notifications = []
        for doc in docs:
            notification_data = doc.to_dict()
            notifications.append({
                "notification_id": doc.id,
                "schedule_id": notification_data.get("schedule_id"),
                "schedule_name": notification_data.get("schedule_name"),
                "created_by": notification_data.get("created_by"),
                "description": notification_data.get("description"),
                "assigned_users": notification_data.get("assigned_users", []),
                "status": notification_data.get("status"),
                "created_date": notification_data.get("created_date"),
            })
        
        if not notifications:
            return JSONResponse(
                status_code=200,
                content={
                    "status": "success",
                    "msg": "Tidak ada notifikasi pending",
                    "total": 0,
                    "notifications": []
                },
            )
        
        return {
            "status": "success",
            "msg": "Berhasil mengambil notifikasi",
            "total": len(notifications),
            "notifications": notifications,
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil notifikasi: {error_msg}"},
        )

def process_get_notification_detail(notification_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        notifications_col = config.db.collection("notifications")
        doc = notifications_col.document(notification_id).get()
        
        if not doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Notifikasi tidak ditemukan"},
            )
        
        notification_data = doc.to_dict()
        
        if notification_data.get("user_id") != user_id:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Akses ditolak"},
            )
        
        schedule_id = notification_data.get("schedule_id")
        schedules_col = config.db.collection("schedules")
        schedule_doc = schedules_col.document(schedule_id).get()
        
        schedule_data = schedule_doc.to_dict() if schedule_doc.exists else {}
        
        return {
            "status": "success",
            "msg": "Berhasil mengambil detail notifikasi",
            "notification_id": notification_id,
            "schedule_id": schedule_id,
            "schedule_name": notification_data.get("schedule_name"),
            "created_by": notification_data.get("created_by"),
            "description": notification_data.get("description"),
            "assigned_users": notification_data.get("assigned_users", []),
            "remind_date": schedule_data.get("remind_date"),
            "remind_hours": schedule_data.get("remind_hours"),
            "status": notification_data.get("status"),
            "created_date": notification_data.get("created_date"),
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil detail notifikasi: {error_msg}"},
        )

def process_approve_schedule(notification_id, schedule_id, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        user_name = user_data.get("usernm", user_id)
        
        notifications_col = config.db.collection("notifications")
        notification_doc = notifications_col.document(notification_id).get()
        
        if not notification_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Notifikasi tidak ditemukan"},
            )
        
        notification_data = notification_doc.to_dict()
        
        if notification_data.get("user_id") != user_id:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Akses ditolak"},
            )
        
        now = datetime.datetime.utcnow().isoformat() + "Z"
        notifications_col.document(notification_id).update({
            "status": "approved",
            "updated_date": now,
            "updated_by": user_name,
            "approval_reason": "Disetujui"
        })
        
        schedules_col = config.db.collection("schedules")
        schedule_doc = schedules_col.document(schedule_id).get()
        
        if schedule_doc.exists:
            schedule_data = schedule_doc.to_dict()
            assigned_users = schedule_data.get("assigned_users", [])
            
            for user_info in assigned_users:
                if user_info.get("user_id") == user_id:
                    user_info["approval_status"] = "approved"
                    user_info["approved_date"] = now
                    break
            
            schedules_col.document(schedule_id).update({
                "assigned_users": assigned_users,
                "updateddate": now,
                "updatedby": user_name,
            })
        
        return {
            "status": "success",
            "msg": "Berhasil menyetujui schedule",
            "notification_id": notification_id,
            "schedule_id": schedule_id,
            "approval_status": "approved",
            "approved_date": now,
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menyetujui schedule: {error_msg}"},
        )

def process_reject_schedule(notification_id, schedule_id, reason, Authorize):
    try:
        Authorize.jwt_required()
        user_id = Authorize.get_jwt_subject()
        
        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        user_name = user_data.get("usernm", user_id)
        
        notifications_col = config.db.collection("notifications")
        notification_doc = notifications_col.document(notification_id).get()
        
        if not notification_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Notifikasi tidak ditemukan"},
            )
        
        notification_data = notification_doc.to_dict()
        
        if notification_data.get("user_id") != user_id:
            return JSONResponse(
                status_code=403,
                content={"status": "error", "msg": "Akses ditolak"},
            )
        
        now = datetime.datetime.utcnow().isoformat() + "Z"
        notifications_col.document(notification_id).update({
            "status": "rejected",
            "updated_date": now,
            "updated_by": user_name,
            "rejection_reason": reason if reason.strip() else "Ditolak tanpa alasan"
        })
        
        schedules_col = config.db.collection("schedules")
        schedule_doc = schedules_col.document(schedule_id).get()
        
        if schedule_doc.exists:
            schedule_data = schedule_doc.to_dict()
            assigned_users = schedule_data.get("assigned_users", [])
            
            for user_info in assigned_users:
                if user_info.get("user_id") == user_id:
                    user_info["approval_status"] = "rejected"
                    user_info["rejected_date"] = now
                    user_info["rejection_reason"] = reason if reason.strip() else "Ditolak tanpa alasan"
                    break
            
            schedules_col.document(schedule_id).update({
                "assigned_users": assigned_users,
                "updateddate": now,
                "updatedby": user_name,
            })
        
        return {
            "status": "success",
            "msg": "Berhasil menolak schedule",
            "notification_id": notification_id,
            "schedule_id": schedule_id,
            "approval_status": "rejected",
            "rejection_reason": reason if reason.strip() else "Ditolak tanpa alasan",
            "rejected_date": now,
        }
    
    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal menolak schedule: {error_msg}"},
        )
