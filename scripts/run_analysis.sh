#!/bin/bash

# Mostrar el banner
echo "========================================================="
echo "   ANÁLISIS DE LA SANTA BIBLIA CON HADOOP MAPREDUCE     "
echo "========================================================="

# Verificar que los contenedores estén ejecutándose
if ! [ "$(docker ps -q -f name=namenode)" ]; then
    echo "Error: El contenedor namenode no está ejecutándose." >&2
    echo "Ejecuta primero: ./scripts/setup.sh" >&2
    exit 1
fi

# Eliminar el directorio de salida si ya existe
echo "Preparando el entorno para el análisis..."
docker exec -it namenode bash -c "hdfs dfs -rm -r -f /user/root/output"

# Ejecutar el trabajo MapReduce para contar palabras
echo "Ejecutando análisis de frecuencia de palabras en la Biblia..."
docker exec -it namenode bash -c "hadoop jar /tmp/hadoop-mapreduce-examples.jar wordcount /user/root/input/bible.txt /user/root/output"

# Verificar si el trabajo se completó correctamente
if [ $? -eq 0 ]; then
    echo "✓ Análisis completado exitosamente."
else
    echo "✗ Error: El análisis no se completó correctamente."
    exit 1
fi

# Crear un directorio temporal para los resultados
mkdir -p tmp

# Exportar los resultados desde HDFS
echo "Exportando resultados..."
docker exec -it namenode bash -c "hdfs dfs -cat /user/root/output/part-r-00000 > /tmp/bible_word_count.txt"
docker cp namenode:/tmp/bible_word_count.txt ./tmp/

# Mostrar estadísticas del análisis
echo "========================================================="
echo "   ESTADÍSTICAS DEL ANÁLISIS BÍBLICO                    "
echo "========================================================="

# Calcular total de palabras únicas
TOTAL_UNIQUE_WORDS=$(wc -l < ./tmp/bible_word_count.txt)
echo "Total de palabras únicas encontradas: $TOTAL_UNIQUE_WORDS"

# Buscar algunas palabras clave de interés teológico
echo ""
echo "Frecuencia de términos bíblicos importantes:"
echo "------------------------------------------"
grep -w "God" ./tmp/bible_word_count.txt
grep -w "Jesus" ./tmp/bible_word_count.txt
grep -w "Christ" ./tmp/bible_word_count.txt
grep -w "love" ./tmp/bible_word_count.txt
grep -w "faith" ./tmp/bible_word_count.txt
grep -w "hope" ./tmp/bible_word_count.txt
grep -w "sin" ./tmp/bible_word_count.txt
grep -w "heaven" ./tmp/bible_word_count.txt
grep -w "hell" ./tmp/bible_word_count.txt

# Mostrar las 10 palabras más frecuentes (excluyendo artículos y preposiciones comunes)
echo ""
echo "Las 10 palabras más frecuentes en la Biblia:"
echo "-------------------------------------------"
grep -v -E "^(the|and|of|to|a|in|that|I|for|with|as|not)" ./tmp/bible_word_count.txt | sort -k2 -nr | head -10

echo ""
echo "Los resultados completos están disponibles en: ./tmp/bible_word_count.txt"
echo ""
echo "Para visualizar los resultados en formato gráfico, ejecuta:"
echo "python scripts/visualize_results.py"