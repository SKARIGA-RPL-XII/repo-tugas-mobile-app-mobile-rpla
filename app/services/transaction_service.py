import datetime, bcrypt
from fastapi.responses import JSONResponse
from fastapi_jwt_auth import AuthJWT
from app.core import config
from app.services.activity_history_service import create_activity_history

def process_add_transaction(room_id, transaction_date, amount, transaction_type, account_type, description, Authorize):
    try:
        Authorize.jwt_required()

        current_user = Authorize.get_jwt_subject()

        if not room_id.strip():
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Room ID tidak boleh kosong"},
            )

        # Validasi transaction_type
        valid_types = ["income", "expense"]
        if transaction_type.lower() not in valid_types:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": f"Transaction type harus berupa: {', '.join(valid_types)}"},
            )

        # Validasi account_type
        valid_accounts = ["checking account", "savings account", "virtual account", "petty cash", "bank account"]
        if account_type.lower() not in valid_accounts:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": f"Account type harus berupa: {', '.join(valid_accounts)}"},
            )

        if amount <= 0:
            return JSONResponse(
                status_code=400,
                content={"status": "error", "msg": "Amount harus lebih dari 0"},
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
            "transaction_date": transaction_date,
            "amount": amount,
            "transaction_type": transaction_type.lower(),
            "account_type": account_type.lower(),
            "description": description,
            "createddate": now,
            "createdby": created_by_name,
            "datemodified": now,
            "modifiedby": created_by_name,
            "isactive": True,
        }

        doc_ref.set(transaction_doc)

        # Log aktivitas ke activity_history
        create_activity_history(
            user_id=current_user,
            company_name=company_name,
            account_type=account_type,
            account_number="",
            balance=amount,
            is_transfer_from=(transaction_type.lower() == "expense"),
            status="pending",
            description=description,
            transaction_id=transaction_id,
        )

        return {
            "status": "success",
            "msg": "Berhasil menambahkan transaction",
            "transaction_id": transaction_id,
            "room_id": room_id,
            "company_name": company_name,
            "transaction_date": transaction_date,
            "amount": amount,
            "transaction_type": transaction_type.lower(),
            "account_type": account_type.lower(),
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
                "transaction_date": trans_data.get("transaction_date"),
                "amount": trans_data.get("amount"),
                "transaction_type": trans_data.get("transaction_type"),
                "account_type": trans_data.get("account_type"),
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

def process_update_transaction(transaction_id, transaction_date, amount, transaction_type, account_type, description, Authorize):
    try:
        Authorize.jwt_required()

        user_id = Authorize.get_jwt_subject()

        users_col = config.db.collection("users")
        user_doc = users_col.document(user_id).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        modified_by_name = user_data.get("usernm", user_id)

        transactions_col = config.db.collection("transactions")
        trans_ref = transactions_col.document(transaction_id)
        trans_doc = trans_ref.get()

        if not trans_doc.exists:
            return JSONResponse(
                status_code=404,
                content={"status": "error", "msg": "Transaction tidak ditemukan"},
            )

        trans_data = trans_doc.to_dict()

        update_data = {
            "datemodified": datetime.datetime.utcnow().isoformat() + "Z",
            "modifiedby": modified_by_name,
        }

        if transaction_date is not None:
            update_data["transaction_date"] = transaction_date

        if amount is not None:
            if amount <= 0:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": "Amount harus lebih dari 0"},
                )
            update_data["amount"] = amount

        if transaction_type is not None:
            valid_types = ["income", "expense"]
            if transaction_type.lower() not in valid_types:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": f"Transaction type harus berupa: {', '.join(valid_types)}"},
                )
            update_data["transaction_type"] = transaction_type.lower()

        if account_type is not None:
            valid_accounts = ["checking account", "savings account", "virtual account", "petty cash", "bank account"]
            if account_type.lower() not in valid_accounts:
                return JSONResponse(
                    status_code=400,
                    content={"status": "error", "msg": f"Account type harus berupa: {', '.join(valid_accounts)}"},
                )
            update_data["account_type"] = account_type.lower()

        if description is not None:
            update_data["description"] = description

        trans_ref.update(update_data)

        updated_trans = trans_ref.get().to_dict()

        create_activity_history(
            user_id=user_id,
            company_name=updated_trans.get("company_name"),
            account_type=updated_trans.get("account_type", ""),
            account_number="",
            balance=updated_trans.get("amount", 0),
            is_transfer_from=(updated_trans.get("transaction_type") == "expense"),
            status="accept",
            description=f"Updated transaction: {description or updated_trans.get('description', '')}",
            transaction_id=transaction_id,
        )

        return {
            "status": "success",
            "msg": "Berhasil mengupdate transaction",
            "transaction_id": transaction_id,
            "room_id": updated_trans.get("room_id"),
            "company_name": updated_trans.get("company_name"),
            "transaction_date": updated_trans.get("transaction_date"),
            "amount": updated_trans.get("amount"),
            "transaction_type": updated_trans.get("transaction_type"),
            "account_type": updated_trans.get("account_type"),
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