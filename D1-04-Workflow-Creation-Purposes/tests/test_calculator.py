# tests/test_calculator.py
# Pruebas unitarias para la calculadora.
# Nota: Este archivo requiere pytest para ejecutarse.
import sys
import os

# Añadir el directorio src al path para poder importar el módulo
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../src')))

from calculator import add, subtract

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_subtract():
    assert subtract(5, 3) == 2
    assert subtract(10, 5) == 5
