import base64
from pymongo import MongoClient

# Conexión a MongoDB
cliente = MongoClient('mongodb://localhost:27017/')
db = cliente['miDB']
coleccion = db['imagenes']

# Ruta de la imagen original que quieres guardar
with open('miImagen.jpg', 'rb') as img_file:
    encoded_string = base64.b64encode(img_file.read()).decode('utf-8')

# Guardar en MongoDB
documento = {"nombre": "foto1", "imagen": encoded_string}
coleccion.insert_one(documento)
print("✅ Imagen guardada en MongoDB.")

