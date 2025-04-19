# Fintech App

Este proyecto es una aplicación fintech compuesta por tres servicios principales: una base de datos MySQL, un backend desarrollado en Python con FastAPI y un frontend construido con Vite y Vue.js. La aplicación está diseñada para ejecutarse en un entorno Docker utilizando `docker-compose`.


## Servicios

### MySQL
- Imagen: `pablopin92/fintech-mysql:1.0.0`
- Puerto: `3306`
- Variables de entorno:
  - `MYSQL_ROOT_PASSWORD`: Contraseña del usuario root.
  - `MYSQL_DATABASE`: Nombre de la base de datos.
- Volumenes:
  - `mysql_data`: Persistencia de datos.

### Backend
- Imagen: `pablopin92/fintech-backend:1.0.0`
- Puerto: `8000`
- Depende del servicio MySQL y espera a que esté saludable antes de iniciar.

### Frontend
- Imagen: `pablopin92/fintech-frontend:1.0.0`
- Puerto: `80`
- Depende del servicio Backend.

## Requisitos Previos

- Docker
- Docker Compose

## Configuración

1. Clona este repositorio:
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd fintech-app
   ```

2. Asegúrate de que Docker y Docker Compose estén instalados en tu sistema.

3. Construye y levanta los servicios:
   ```bash
   docker-compose up --build
   ```

4. Accede a la aplicación:
   - Frontend: [http://localhost](http://localhost)
   - Backend: [http://localhost:8000](http://localhost:8000)

## Scripts Útiles

- Para detener los servicios:
  ```bash
  docker-compose down
  ```

- Para limpiar los volúmenes:
  ```bash
  docker-compose down -v
  ```

## Notas

- El archivo `init.sql` en `database/initdb/` contiene el script de inicialización para la base de datos MySQL.
- El backend utiliza FastAPI y está configurado para interactuar con la base de datos MySQL.
- El frontend está construido con Vite y Vue.js, y utiliza Tailwind CSS para el diseño.

## Autor

Pablo Pin - devidence.dev 

