import datetime
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config


def create_activity_history(
    user_id: str,
    company_name: str = None,
    account_type: str = None,
    account_number: str = None,
    balance: float = 0,
    is_transfer_from: bool = True,  # True = transfer from, False = transfer to
    status: str = "pending",  # pending, accept, declined
    description: str = None,
    transaction_id: str = None,
):
    """
    Membuat record history aktivitas untuk user
    
    Parameters:
    - user_id: ID user yang melakukan aktivitas
    - company_name: Nama perusahaan/akun yang terlibat
    - account_type: Tipe akun (e.g., "Savings", "Checking")
    - account_number: Nomor akun
    - balance: Jumlah balance yang ditransfer
    - is_transfer_from: Boolean, True jika transfer dari akun ini, False jika transfer ke akun ini
    - status: Status aktivitas (pending, accept, declined)
    - description: Deskripsi aktivitas
    - transaction_id: ID transaksi yang terkait (opsional)
    """
    try:
        activity_col = config.db.collection("activity_history")
        doc_ref = activity_col.document()
        activity_id = doc_ref.id
        now = datetime.datetime.utcnow().isoformat() + "Z"

        activity_doc = {
            "activity_id": activity_id,
            "user_id": user_id,
            "company_name": company_name,
            "account_type": account_type,
            "account_number": account_number,
            "balance": balance,
            "is_transfer_from": is_transfer_from,
            "status": status,
            "description": description,
            "transaction_id": transaction_id,
            "modified_date": now,
            "created_date": now,
            "is_active": True,
        }

        doc_ref.set(activity_doc)

        return {
            "status": "success",
            "activity_id": activity_id,
            "msg": "Activity history berhasil dicatat",
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal membuat activity history: {error_msg}"},
        )


def get_activity_history(user_id: str):
    """
    Mendapatkan semua activity history untuk user tertentu
    
    Parameters:
    - user_id: ID user
    """
    try:
        activity_col = config.db.collection("activity_history")
        query = activity_col.where("user_id", "==", user_id).where("is_active", "==", True).order_by("modified_date", direction=-1)
        
        docs = query.stream()
        activities = []
        
        for doc in docs:
            activity = doc.to_dict()
            activities.append(activity)
        
        if not activities:
            return {
                "status": "success",
                "msg": "Tidak ada activity history",
                "data": [],
                "total": 0,
            }
        
        return {
            "status": "success",
            "msg": "Activity history berhasil diambil",
            "data": activities,
            "total": len(activities),
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil activity history: {error_msg}"},
        )



def update_activity_status(user_id: str, new_status: str):
    """
    Update status activity history terbaru (pending -> accept/declined)
    
    Parameters:
    - user_id: ID user yang melakukan update
    - new_status: Status baru (accept, declined, pending)
    """
    if new_status not in ["pending", "accept", "declined"]:
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": "Status harus: pending, accept, atau declined"},
        )
    
    try:
        activity_col = config.db.collection("activity_history")
        
        # Get latest activity untuk user ini
        query = activity_col.where("user_id", "==", user_id).where("is_active", "==", True).order_by("modified_date", direction=-1).limit(1)
        docs = query.stream()
        
        activity_id = None
        for doc in docs:
            activity_id = doc.id
        
        if not activity_id:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Activity history tidak ditemukan untuk user ini"},
            )
        
        now = datetime.datetime.utcnow().isoformat() + "Z"
        activity_ref = activity_col.document(activity_id)
        activity_ref.update({
            "status": new_status,
            "modified_date": now,
        })
        
        return {
            "status": "success",
            "msg": f"Status activity berhasil diubah menjadi {new_status}",
            "activity_id": activity_id,
            "new_status": new_status,
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengupdate activity status: {error_msg}"},
        )


def get_activity_stats(user_id: str):
    """
    Mendapatkan statistik aktivitas user (jumlah transfer, total balance, dll)
    """
    try:
        activity_col = config.db.collection("activity_history")
        query = activity_col.where("user_id", "==", user_id).where("is_active", "==", True)
        
        docs = query.stream()
        activities = [doc.to_dict() for doc in docs]
        
        if not activities:
            return {
                "status": "success",
                "data": {
                    "total_activities": 0,
                    "total_transfer_from": 0,
                    "total_transfer_to": 0,
                    "total_balance_transferred": 0,
                    "status_breakdown": {
                        "pending": 0,
                        "accept": 0,
                        "declined": 0,
                    }
                }
            }
        
        total_balance_transferred = sum(activity.get("balance", 0) for activity in activities)
        transfer_from_count = sum(1 for a in activities if a.get("is_transfer_from", False))
        transfer_to_count = sum(1 for a in activities if not a.get("is_transfer_from", False))
        
        status_breakdown = {
            "pending": sum(1 for a in activities if a.get("status") == "pending"),
            "accept": sum(1 for a in activities if a.get("status") == "accept"),
            "declined": sum(1 for a in activities if a.get("status") == "declined"),
        }
        
        return {
            "status": "success",
            "data": {
                "total_activities": len(activities),
                "total_transfer_from": transfer_from_count,
                "total_transfer_to": transfer_to_count,
                "total_balance_transferred": total_balance_transferred,
                "status_breakdown": status_breakdown,
            }
        }

    except Exception as e:
        error_msg = str(e)
        return JSONResponse(
            status_code=400,
            content={"status": "error", "msg": f"Gagal mengambil activity stats: {error_msg}"},
        )
