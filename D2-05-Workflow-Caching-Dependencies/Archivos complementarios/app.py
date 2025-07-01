import pandas as pd
import numpy as np

print("Librerías importadas correctamente.")
print(f"Versión de pandas: {pd.__version__}")
print(f"Versión de numpy: {np.__version__}")

df = pd.DataFrame(np.random.randint(0,100,size=(5, 4)), columns=list('ABCD'))
print("DataFrame creado:")
print(df.head())
