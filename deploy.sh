#!/bin/bash

echo "🚀 Desplegando aplicacion"
echo "📦 Creando namespace..."
microk8s kubectl apply -f k8s/namespace.yaml > /dev/null || error_exit "Fallo al crear namespace"

echo "🔐 Creando secretos..."
microk8s kubectl apply -f k8s/mysql-secret.yaml > /dev/null || error_exit "Fallo al crear secretos"

echo "💾 Creando PVC para MySQL..."
microk8s kubectl apply -f k8s/mysql-pvc.yaml > /dev/null || error_exit "Fallo al crear PVC"

echo "🗄️ Desplegando MySQL..."
microk8s kubectl apply -f k8s/mysql-deployment.yaml > /dev/null || error_exit "Fallo al desplegar MySQL"
microk8s kubectl apply -f k8s/mysql-service.yaml > /dev/null || error_exit "Fallo al crear servicio MySQL"
microk8s kubectl apply -f k8s/mysql-alias-service.yaml > /dev/null || error_exit "Fallo al crear alias MySQL en Kubernetes..."

# Función para mostrar errores y salir
error_exit() {
    echo "❌ Error: $1" >&2
    exit 1
}

# Verificar que microk8s esté disponible
if ! command -v microk8s &> /dev/null; then
    error_exit "microk8s no está instalado o no está en el PATH"
fi

echo "🔨 Construyendo imágenes Docker..."

# Construir imagen del backend
echo "📦 Construyendo imagen del backend..."
cd backend
docker build --quiet -t fintech-backend:latest . || error_exit "Fallo al construir imagen del backend"
cd ..

# Construir imagen del frontend
echo "🎨 Construyendo imagen del frontend..."
cd frontend
docker build --quiet -t fintech-frontend:latest . || error_exit "Fallo al construir imagen del frontend"
cd ..

echo "📥 Importando imágenes a microk8s..."

docker save fintech-backend:latest | microk8s ctr image import - || error_exit "Fallo al importar imagen del backend"
docker save fintech-frontend:latest | microk8s ctr image import - || error_exit "Fallo al importar imagen del frontend"

echo "� Creando namespace..."
microk8s kubectl apply -f k8s/namespace.yaml || error_exit "Fallo al crear namespace"

echo "🔐 Creando secretos..."
microk8s kubectl apply -f k8s/mysql-secret.yaml || error_exit "Fallo al crear secretos"

echo "💾 Creando PVC para MySQL..."
microk8s kubectl apply -f k8s/mysql-pvc.yaml || error_exit "Fallo al crear PVC"

echo "🗄️ Desplegando MySQL..."
microk8s kubectl apply -f k8s/mysql-deployment.yaml || error_exit "Fallo al desplegar MySQL"
microk8s kubectl apply -f k8s/mysql-service.yaml || error_exit "Fallo al crear servicio MySQL"
microk8s kubectl apply -f k8s/mysql-alias-service.yaml || error_exit "Fallo al crear alias MySQL"

echo "⏳ Esperando a que MySQL esté listo..."
microk8s kubectl wait --for=condition=ready pod -l app=mysql -n fintech --timeout=120s || error_exit "MySQL no se inició correctamente"

echo "🔧 Desplegando Backend..."
microk8s kubectl apply -f k8s/backend-deployment.yaml || error_exit "Fallo al desplegar Backend"
microk8s kubectl apply -f k8s/backend-service.yaml || error_exit "Fallo al crear servicio Backend"

echo "⏳ Esperando a que el Backend esté listo..."
microk8s kubectl wait --for=condition=ready pod -l app=backend -n fintech --timeout=120s || error_exit "Backend no se inició correctamente"

echo "🌐 Desplegando Frontend..."
microk8s kubectl apply -f k8s/frontend-deployment.yaml || error_exit "Fallo al desplegar Frontend"
microk8s kubectl apply -f k8s/frontend-service.yaml || error_exit "Fallo al crear servicio Frontend"

echo "� Configurando Ingress..."
microk8s kubectl apply -f k8s/ingress.yaml || error_exit "Fallo al configurar Ingress"

echo "� Aplicando Network Policies..."
microk8s kubectl apply -f k8s/mysql-network-policy.yaml || error_exit "Fallo al aplicar network policy MySQL"
microk8s kubectl apply -f k8s/backend-network-policy.yaml || error_exit "Fallo al aplicar network policy Backend"

echo "⏳ Esperando a que todos los pods estén listos..."
microk8s kubectl wait --for=condition=ready pod -l app=frontend -n fintech --timeout=120s || error_exit "Frontend no se inició correctamente"

echo "✅ Despliegue completado!"
echo "🌍 La aplicación estará disponible en: http://fintech.local"
echo "� Para verificar el estado: microk8s kubectl get pods -n fintech"
echo ""
echo "🔧 Para verificar que todo funciona:"
echo "   curl http://fintech.local/api/transactions"
echo "   curl -X POST http://fintech.local/api/transactions -H 'Content-Type: application/json' -d '{\"amount\": 100, \"description\": \"Test\", \"type\": \"credit\"}'"