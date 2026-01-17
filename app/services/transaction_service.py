import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config

def process_add_transaction(room_id, balance, income, expense, description, Authorize):
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

def process_get_transaction(Authorize):
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

def process_update_transaction(balance, income, expense, description, Authorize):
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