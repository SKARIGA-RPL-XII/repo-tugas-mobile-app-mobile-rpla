import os
import firebase_admin
from firebase_admin import credentials, firestore

CREDENTIALS_PATH = os.environ.get(
    "GOOGLE_APPLICATION_CREDENTIALS",
    "fintrack-ae370-firebase-adminsdk-fbsvc-93da5e53e0.json",
)

def init_firebase():
    if not firebase_admin._apps:
        cred = credentials.Certificate(CREDENTIALS_PATH)
        firebase_admin.initialize_app(cred)

init_firebase()
db = firestore.client()
