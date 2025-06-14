from fastapi import FastAPI, Depends
from sqlalchemy import create_engine, Column, Integer, String, Numeric, TIMESTAMP, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from pydantic import BaseModel
from typing import List
from fastapi.middleware.cors import CORSMiddleware
import os


# Usar variables de entorno para la configuración de la base de datos
MYSQL_HOST = os.getenv("MYSQL_HOST", "mysql-service")
MYSQL_PORT = os.getenv("MYSQL_PORT", "3306")
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "secret")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "fintech")

DATABASE_URL = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

app = FastAPI()

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Puedes cambiar esto a ["http://ubuntu-srv:5173"] si prefieres ser más estricto
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MODELO SQLAlchemy
class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    description = Column(String(255), nullable=False)
    amount = Column(Numeric(10, 2), nullable=False)
    created_at = Column(TIMESTAMP, server_default=text("CURRENT_TIMESTAMP"))

# MODELO Pydantic
class TransactionCreate(BaseModel):
    description: str
    amount: float

class TransactionRead(TransactionCreate):
    id: int

    class Config:
        orm_mode = True

# INICIALIZACIÓN de DB (solo si tabla no existe)
@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)

# Dependencia para obtener sesión de DB
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def root():
    return {"message": "API FastAPI con SQLAlchemy"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/transactions", response_model=List[TransactionRead])
def get_transactions(db: Session = Depends(get_db)):
    return db.query(Transaction).all()

@app.post("/transactions", response_model=TransactionRead)
def create_transaction(tx: TransactionCreate, db: Session = Depends(get_db)):
    new_tx = Transaction(**tx.dict())
    db.add(new_tx)
    db.commit()
    db.refresh(new_tx)
    return new_tx
