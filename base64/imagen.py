##import base64
##import pymongo

##convertimos nuestra imagen a base64

##with open("miImagen.jpg", "rb") as img_file:
    ##base64_string = base64.b64encode(img_file.read()).decode('utf-8')
    ##print(base64_string)

##insertamos la imagen en MongoDB
##from pymongo import MongoClient

##client = MongoClient("mongodb://localhost:27017/")
##db = client["miDB"]

##print("Conexión exitosa a MongoDB")

##recuoeramos la ingen desde mongoDB
#import base64
#from pymongo import MongoClient

#client = MongoClient("mongodb://localhost:27017/")
#db = client["miDB"]
#collection = db["imagenes"]

#doc = collection.find_one({"nombre": "miImagen"})
#img_data = base64.b64decode(doc["datos"]["$binary"]["base64"])

#with open("recuperada.jpg", "wb") as img_file:
#    img_file.write(img_data)

#print("Imagen guardada como recuperada.jpg 🎉")

##para abriri la imagen en un navegador webrecuperda sin salir de python

import base64
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["miDB"]
collection = db["imagenes"]

doc = collection.find_one({"nombre": "miImagen"})

if doc and "datos" in doc:
    img_data = base64.b64decode(doc["datos"]["$binary"]["base64"])

    with open("C:/Users/user23/Documents/SQL Server Management Studio/Base de datos ll/base64/recuperada.jpg", "wb") as img_file:
        img_file.write(img_data)

    print("Imagen guardada correctamente ✅")
else:
    print("No se encontraron datos de imagen en la base de datos ❌")


from PIL import Image
import io

# Abrir la imagen guardada correctamente
image = Image.open("C:/Users/user23/Documents/SQL Server Management Studio/Base de datos ll/base64/recuperada.jpg")
image.show()