# Análisis de la Santa Biblia con Hadoop y Docker

Este proyecto implementa un entorno de Hadoop con Docker para analizar la Santa Biblia utilizando MapReduce. El análisis realiza un conteo de frecuencia de palabras para descubrir patrones lingüísticos y la importancia relativa de diferentes términos en el texto sagrado.

## Requisitos Previos

- Docker Engine (versión 20.10.x o superior)
- Docker Compose (versión 2.x o superior)
- Sistema Operativo: Linux, Windows con WSL2, o macOS
- Memoria RAM: Mínimo 8GB recomendado
- Espacio en Disco: Mínimo 10GB libre

## Estructura del Proyecto

```
hadoop-bible-analysis/
├── docker-compose.yml    # Configuración de los contenedores Docker para Hadoop
├── hadoop.env            # Variables de entorno para Hadoop
├── data/                 # Directorio para almacenar textos
│   └── bible.txt         # La Santa Biblia a analizar
├── scripts/              # Scripts de utilidad
│   ├── download_bible.sh   # Descarga la Santa Biblia
│   ├── setup.sh            # Configura el entorno Hadoop
│   ├── run_analysis.sh     # Ejecuta el análisis MapReduce
│   └── visualize_results.py # Visualiza los resultados del análisis
├── tmp/                  # Almacenamiento temporal de resultados
│   └── bible_word_count.txt # Resultados del análisis de conteo de palabras
├── visualizations/       # Gráficos y visualizaciones generados
│   ├── top_bible_words.png  # Gráfico de barras con las palabras más frecuentes
│   ├── theological_terms.png # Comparación de términos teológicos importantes
│   └── bible_word_cloud.png  # Nube de palabras generada a partir del análisis
└── README.md             # Documentación del proyecto
```

## Componentes Hadoop

El proyecto incluye los siguientes componentes de Hadoop:

- **NameNode**: Servidor maestro que gestiona el sistema de archivos HDFS
- **DataNode**: Nodos de almacenamiento que guardan los bloques de datos
- **ResourceManager**: Gestor de recursos para YARN
- **NodeManager**: Gestores de nodos para procesamiento
- **HistoryServer**: Servidor para visualizar el historial de aplicaciones

## Cómo Usar

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/hadoop-bible-analysis.git
cd hadoop-bible-analysis
```

### 2. Preparar el entorno

Primero, descarga la Santa Biblia:

```bash
chmod +x scripts/download_bible.sh
./scripts/download_bible.sh
```

Luego, configura el entorno Hadoop:

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 3. Ejecutar el análisis

```bash
chmod +x scripts/run_analysis.sh
./scripts/run_analysis.sh
```

### 4. Visualizar los resultados

Para generar visualizaciones de los resultados:

```bash
pip install matplotlib pandas numpy wordcloud
python scripts/visualize_results.py
```

## Interfaces de Hadoop

Una vez que los contenedores estén en ejecución, puedes acceder a las siguientes interfaces web:

- **NameNode**: http://localhost:9870
- **ResourceManager**: http://localhost:8088
- **HistoryServer**: http://localhost:8188

## Resultados

El análisis generará:

1. Un archivo de texto con el conteo de palabras (`tmp/bible_word_count.txt`)
2. Gráficos de las palabras más frecuentes (`visualizations/top_bible_words.png`)
3. Un gráfico comparativo de términos teológicos (`visualizations/theological_terms.png`)
4. Una nube de palabras (`visualizations/bible_word_cloud.png`)

## Análisis de Interés

Este análisis permite estudiar aspectos como:

- Frecuencia de nombres divinos (Dios, Señor, Jesús, Cristo)
- Prevalencia de conceptos teológicos (amor, fe, esperanza, pecado)
- Menciones de personajes bíblicos (Moisés, David, Abraham)
- Diferencias lingüísticas entre el Antiguo y Nuevo Testamento (si se separan)

## Limpieza

Para detener y eliminar los contenedores:

```bash
docker-compose down
```

Para eliminar también los volúmenes y comenzar desde cero:

```bash
docker-compose down -v
```

## Personalización

Puedes analizar otros textos religiosos colocándolos en el directorio `data/` y modificando los scripts según sea necesario:

1. Coloca tu archivo de texto en `data/`
2. Modifica `setup.sh` para cambiar la ruta del archivo en HDFS
3. Ajusta los scripts según sea necesario para adaptarlos al nuevo texto

## Licencia

Este proyecto se distribuye bajo la licencia MIT.

## Agradecimientos

- [Proyecto Gutenberg](https://www.gutenberg.org/) por proporcionar textos de dominio público
- [big-data-europe/docker-hadoop](https://github.com/big-data-europe/docker-hadoop) por las imágenes Docker de Hadoop