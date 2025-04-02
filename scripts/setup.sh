#!/bin/bash

# Mostrar el banner
echo "========================================================="
echo "   CONFIGURACIÓN DEL ENTORNO HADOOP PARA ANÁLISIS BÍBLICO"
echo "========================================================="

# Verificar que Docker esté instalado
if ! [ -x "$(command -v docker)" ]; then
  echo "Error: Docker no está instalado." >&2
  exit 1
fi

# Verificar que Docker Compose esté instalado
if ! [ -x "$(command -v docker-compose)" ]; then
  echo "Error: Docker Compose no está instalado." >&2
  exit 1
fi

# Iniciar los contenedores con Docker Compose
echo "Iniciando los contenedores de Hadoop..."
docker-compose up -d

# Esperar a que los servicios estén listos
echo "Esperando a que los servicios estén disponibles..."
sleep 10

# Verificar que los contenedores estén ejecutándose
if [ "$(docker ps -q -f name=namenode)" ] && [ "$(docker ps -q -f name=datanode)" ]; then
    echo "✓ Contenedores de Hadoop iniciados correctamente."
else
    echo "✗ Error: Los contenedores no se iniciaron correctamente."
    exit 1
fi

# Crear directorio de entrada en HDFS
echo "Creando estructura de directorios en HDFS..."
docker exec -it namenode bash -c "hdfs dfs -mkdir -p /user/root/input"

# Verificar que el directorio se haya creado correctamente
if docker exec -it namenode bash -c "hdfs dfs -ls /user/root" | grep -q "input"; then
    echo "✓ Directorio en HDFS creado correctamente."
else
    echo "✗ Error: No se pudo crear el directorio en HDFS."
    exit 1
fi

# Copiar la Santa Biblia a HDFS
echo "Copiando la Santa Biblia a HDFS..."

# Primero verificar que el archivo existe
docker exec -it namenode bash -c "ls -la /data"

# Si el archivo no existe en /data, copiarlo desde el host al contenedor
if ! docker exec -it namenode bash -c "test -f /data/bible.txt && echo exists"; then
    echo "Copiando bible.txt al contenedor..."
    docker cp ./data/bible.txt namenode:/tmp/bible.txt
    docker exec -it namenode bash -c "hdfs dfs -put /tmp/bible.txt /user/root/input/"
else
    docker exec -it namenode bash -c "hdfs dfs -put /data/bible.txt /user/root/input/"
fi

# Verificar que el archivo se haya copiado correctamente
if docker exec -it namenode bash -c "hdfs dfs -ls /user/root/input" | grep -q "bible.txt"; then
    echo "✓ Biblia copiada a HDFS correctamente."
else
    echo "✗ Error: No se pudo copiar la Biblia a HDFS."
    exit 1
fi

echo "========================================================="
echo "   CONFIGURACIÓN COMPLETADA EXITOSAMENTE                 "
echo "========================================================="
echo ""
echo "Para acceder al panel de administración de Hadoop, visita:"
echo "- NameNode: http://localhost:9870"
echo "- ResourceManager: http://localhost:8088"
echo ""
echo "Para ejecutar el análisis de la Biblia, ejecuta:"
echo "./scripts/run_analysis.sh"