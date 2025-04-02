#!/usr/bin/env python3
"""
Visualizador de resultados del análisis de la Santa Biblia con Hadoop.
Este script crea visualizaciones de los resultados del conteo de palabras.
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os

def read_word_count_data(file_path):
    """Lee los datos del conteo de palabras y devuelve un DataFrame."""
    words = []
    counts = []
    
    with open(file_path, 'r') as file:
        for line in file:
            parts = line.strip().split('\t')
            if len(parts) == 2:
                word, count = parts
                words.append(word)
                counts.append(int(count))
    
    return pd.DataFrame({'word': words, 'count': counts})

def filter_common_words(df, min_count=10):
    """Filtra palabras comunes y poco frecuentes."""
    # Filtrar palabras con frecuencia baja
    df = df[df['count'] >= min_count]
    
    # Filtrar palabras comunes en inglés
    common_words = ['the', 'and', 'of', 'to', 'a', 'in', 'that', 'I', 'he', 'his', 
                   'for', 'with', 'as', 'not', 'is', 'be', 'by', 'on', 'thou', 'thy',
                   'but', 'had', 'me', 'which', 'have', 'from', 'you', 'her', 'at',
                   'it', 'an', 'they', 'were', 'are', 'been', 'would', 'their',
                   'will', 'all', 'no', 'when', 'one', 'your', 'could', 'them',
                   'shall', 'unto', 'was', 'said', 'upon', 'ye', 'thee', 'hath',
                   'this', 'my', 'out', 'up', 'so', 'then', 'into', 'there', 'them',
                   'we', 'who', 'if', 'or', 'what', 'did', 'were', 'am', 'us']
    
    return df[~df['word'].str.lower().isin(common_words)]

def create_bar_chart(df, title, output_file, top_n=20):
    """Crea un gráfico de barras con las palabras más frecuentes."""
    plt.figure(figsize=(12, 8))
    
    # Ordenar por frecuencia y tomar las top_n palabras
    top_words = df.sort_values(by='count', ascending=False).head(top_n)
    
    # Crear el gráfico de barras
    bars = plt.bar(np.arange(len(top_words)), top_words['count'], color='skyblue')
    plt.xticks(np.arange(len(top_words)), top_words['word'], rotation=45, ha='right')
    
    # Añadir etiquetas y título
    plt.xlabel('Palabras')
    plt.ylabel('Frecuencia')
    plt.title(title)
    
    # Añadir los valores sobre las barras
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height + 0.1,
                 f'{height}', ha='center', va='bottom')
    
    plt.tight_layout()
    plt.savefig(output_file)
    print(f"Gráfico guardado como {output_file}")

def create_word_cloud(df, title, output_file):
    """Crea una nube de palabras."""
    try:
        from wordcloud import WordCloud
        
        # Crear un diccionario de palabras y frecuencias
        word_freq = dict(zip(df['word'], df['count']))
        
        # Crear la nube de palabras
        wordcloud = WordCloud(width=800, height=400, background_color='white',
                              max_words=150, contour_width=3, contour_color='steelblue')
        wordcloud.generate_from_frequencies(word_freq)
        
        # Mostrar la nube de palabras
        plt.figure(figsize=(10, 8))
        plt.imshow(wordcloud, interpolation='bilinear')
        plt.axis('off')
        plt.title(title)
        plt.tight_layout()
        plt.savefig(output_file)
        print(f"Nube de palabras guardada como {output_file}")
    except ImportError:
        print("La biblioteca wordcloud no está instalada. Instálala con: pip install wordcloud")

def create_comparison_chart(df, title, output_file):
    """Crea un gráfico comparando términos teológicos importantes."""
    # Términos de interés
    theological_terms = ['God', 'Jesus', 'Christ', 'love', 'faith', 'hope', 
                         'sin', 'heaven', 'hell', 'holy', 'angel', 'Moses',
                         'David', 'prophet', 'blessing', 'pray', 'worship']
    
    # Filtrar el dataframe para incluir solo estos términos
    terms_df = df[df['word'].isin(theological_terms)]
    
    # Si no se encuentran algunos términos, mostrar un mensaje
    missing_terms = set(theological_terms) - set(terms_df['word'].values)
    if missing_terms:
        print(f"Aviso: Los siguientes términos no se encontraron en el texto: {', '.join(missing_terms)}")
    
    # Ordenar por frecuencia
    terms_df = terms_df.sort_values(by='count', ascending=False)
    
    plt.figure(figsize=(12, 8))
    bars = plt.bar(terms_df['word'], terms_df['count'], color='coral')
    
    # Añadir etiquetas y título
    plt.xlabel('Términos Teológicos')
    plt.ylabel('Frecuencia')
    plt.title(title)
    plt.xticks(rotation=45, ha='right')
    
    # Añadir los valores sobre las barras
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height + 0.1,
                 f'{height}', ha='center', va='bottom')
    
    plt.tight_layout()
    plt.savefig(output_file)
    print(f"Gráfico de términos teológicos guardado como {output_file}")

def main():
    """Función principal."""
    # Verificar si el archivo de resultados existe
    results_file = './tmp/bible_word_count.txt'
    if not os.path.exists(results_file):
        print(f"Error: No se encontró el archivo {results_file}")
        print("Ejecuta primero el análisis con: ./scripts/run_analysis.sh")
        return
    
    # Crear directorio para las visualizaciones
    viz_dir = './visualizations'
    os.makedirs(viz_dir, exist_ok=True)
    
    # Leer y procesar los datos
    print("Leyendo resultados del análisis bíblico...")
    df = read_word_count_data(results_file)
    print(f"Total de palabras únicas: {len(df)}")
    
    # Filtrar palabras
    filtered_df = filter_common_words(df)
    print(f"Palabras significativas después del filtrado: {len(filtered_df)}")
    
    # Crear visualizaciones
    create_bar_chart(
        filtered_df, 
        'Las 20 palabras más frecuentes en la Santa Biblia', 
        f'{viz_dir}/top_bible_words.png'
    )
    
    create_comparison_chart(
        df,
        'Frecuencia de Términos Teológicos en la Biblia',
        f'{viz_dir}/theological_terms.png'
    )
    
    try:
        create_word_cloud(
            filtered_df, 
            'Nube de palabras de la Santa Biblia', 
            f'{viz_dir}/bible_word_cloud.png'
        )
    except Exception as e:
        print(f"No se pudo crear la nube de palabras: {e}")
    
    print("\nVisualización completada. Revisa el directorio 'visualizations'.")

if __name__ == "__main__":
    main()