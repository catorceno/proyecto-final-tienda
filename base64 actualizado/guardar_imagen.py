import base64
from pymongo import MongoClient
from datetime import datetime, timezone


def guardar_imagen_marketplace(ruta_imagen, nombre_imagen, usuario, descripcion, precio, categoria,
                                uri='mongodb://localhost:27017/', db_name='miDB', coleccion_nombre='imagenes'):
    cliente = MongoClient(uri)  ##crea una conexión al servidor MongoDB
    db = cliente[db_name] ##selecciona la base de datos 
    coleccion = db[coleccion_nombre] ## selecciona la colecciones dentro de la base de datos 

    with open(ruta_imagen, 'rb') as img_file: ##abre el archivo de imagen en modo binari
        encoded_string = base64.b64encode(img_file.read()).decode('utf-8')##codifica en base 64 la image

    documento = {
        "nombre": nombre_imagen,
        "imagen": encoded_string,
        "usuario": usuario,
        "descripcion": descripcion,
        "precio": float(precio),
        "categoria": categoria,
        "fecha_subida": datetime.now(timezone.utc) ##agrega la fecha y hora actual en formato UTC

    }

    coleccion.insert_one(documento)
    print("✅ Imagen y datos del producto guardados en MongoDB.")

if __name__ == "__main__":
    guardar_imagen_marketplace(
        ruta_imagen='miImagen.jpg',
        nombre_imagen='foto_zapatos_rojos',
        usuario='camila123',
        descripcion='Zapatos rojos de cuero, talla 38',
        precio=120.0,
        categoria='calzado'
    )

