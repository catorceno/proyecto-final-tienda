import base64
from pymongo import MongoClient
from PIL import Image
from io import BytesIO

# Conexión con MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['miDB']
coleccion = db['imagenes']

# Obtener el documento (suponiendo que hay solo uno)
documento = coleccion.find_one()

# Convertir base64 a imagen
if documento:
    imagen_base64 = documento['imagen']
    imagen_bytes = base64.b64decode(imagen_base64)
    imagen = Image.open(BytesIO(imagen_bytes))
    imagen.save('recuperada.jpg')
    print("✅ Imagen guardada como 'recuperada.jpg'")
    imagen.show()
else:
    print("⚠️ No se encontró ninguna imagen en la base de datos.")

