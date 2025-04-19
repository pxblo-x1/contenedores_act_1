FROM mysql:8

# Copia scripts SQL de inicialización si los tienes
# (coloca archivos .sql o .sh en el mismo directorio)
COPY ./initdb /docker-entrypoint-initdb.d

# Configuración opcional adicional (puedes agregar my.cnf si lo necesitas)
