#!/bin/bash

# Descargar la Santa Biblia en inglés (King James Version) desde Project Gutenberg
echo "Descargando la Santa Biblia (King James Version)..."
curl -s https://www.gutenberg.org/files/10/10-0.txt -o data/bible.txt

# Verificar que se descargó correctamente
if [ -f "data/bible.txt" ]; then
    echo "✓ Biblia descargada correctamente."
    echo "Tamaño del archivo: $(du -h data/bible.txt | cut -f1)"
else
    echo "✗ Error: No se pudo descargar la Biblia."
    exit 1
fi