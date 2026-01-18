from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class ActivityHistoryCreate(BaseModel):
    """Model untuk membuat activity history"""
    company_name: Optional[str] = Field(None, description="Nama perusahaan/akun")
    account_type: Optional[str] = Field(None, description="Tipe akun (e.g., Savings, Checking)")
    account_number: Optional[str] = Field(None, description="Nomor akun")
    balance: float = Field(0, description="Jumlah balance yang ditransfer")
    is_transfer_from: bool = Field(True, description="True = transfer dari akun ini, False = transfer ke akun ini")
    status: str = Field("pending", description="Status aktivitas (pending, accept, declined)")
    description: Optional[str] = Field(None, description="Deskripsi aktivitas")
    transaction_id: Optional[str] = Field(None, description="ID transaksi yang terkait")


class ActivityHistory(BaseModel):
    """Model untuk response activity history"""
    activity_id: str
    user_id: str
    company_name: Optional[str]
    account_type: Optional[str]
    account_number: Optional[str]
    balance: float
    is_transfer_from: bool
    status: str
    description: Optional[str]
    transaction_id: Optional[str]
    modified_date: str
    created_date: str
    is_active: bool


class ActivityHistoryList(BaseModel):
    """Model untuk list activity history"""
    status: str
    msg: str
    data: List[ActivityHistory]
    total: int


class ActivityHistoryDetail(BaseModel):
    """Model untuk detail activity history"""
    status: str
    data: ActivityHistory


class ActivityStats(BaseModel):
    """Model untuk statistik aktivitas"""
    total_activities: int
    total_transfer_from: int
    total_transfer_to: int
    total_balance_transferred: float
    status_breakdown: dict


class ActivityStatsResponse(BaseModel):
    """Response untuk statistik aktivitas"""
    status: str
    data: ActivityStats
