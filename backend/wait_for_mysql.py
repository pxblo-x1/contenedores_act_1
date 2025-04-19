import time
import pymysql

print("⏳ Esperando a que MySQL esté listo...")

while True:
    try:
        conn = pymysql.connect(
            host="mysql",
            user="root",
            password="secret",
            database="fintech"
        )
        print("✅ Conectado a MySQL")
        conn.close()
        break
    except pymysql.err.OperationalError:
        time.sleep(2)
