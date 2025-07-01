import os

# Este script espera una variable de entorno que no estará configurada por defecto.
secret_value = os.environ['MY_APP_SECRET']

if secret_value:
    print("Secreto encontrado y procesado exitosamente.")
else:
    print("Error: No se encontró el secreto.")
    # El script no falla con un código de salida distinto de cero, ocultando el problema.
