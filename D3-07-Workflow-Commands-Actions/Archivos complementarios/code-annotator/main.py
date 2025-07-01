# code-annotator/main.py
import os

file = os.getenv('INPUT_FILE')
line = os.getenv('INPUT_LINE')

# El comando de workflow tiene un error sutil.
print(f"::warning file={file},line={line}::Este es un método obsoleto.")