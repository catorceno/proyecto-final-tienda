from pymongo import MongoClient
from PIL import Image ##para manejar imágenes
from io import BytesIO
import base64

def mostrar_imagen_marketplace(nombre_imagen, uri='mongodb://localhost:27017/', db_name='miDB', coleccion_nombre='imagenes'):
    client = MongoClient(uri)
    db = client[db_name]
    coleccion = db[coleccion_nombre]

    documento = coleccion.find_one({"nombre": nombre_imagen}) ##busco el documento por nombre de imagen

    if documento: ##verifica si encontro el docuemnto si es asi entonces se ejcuta todo el bloque
        print("📦 Datos del producto:")
        print(f"👤 Usuario: {documento.get('usuario', 'N/A')}")
        print(f"📝 Descripción: {documento.get('descripcion', 'N/A')}")
        print(f"💰 Precio: {documento.get('precio', 'N/A')} Bs")
        print(f"🏷️ Categoría: {documento.get('categoria', 'N/A')}")
        print(f"🗓️ Fecha de subida: {documento.get('fecha_subida', 'N/A')}")

        imagen_base64 = documento['imagen'] ##extrae la imagen en formato base64
        imagen_bytes = base64.b64decode(imagen_base64) ##decodifica la imagen de base64 a bytes
        imagen = Image.open(BytesIO(imagen_bytes)) ##abre la imagen desde los bytes decodificados
        imagen.save('recuperada.jpg')## guarda la imagen recuperada en un archivo
        print("✅ Imagen recuperada como 'recuperada.jpg'")## mensaje de confirmación
        imagen.show()## muestra la imagen en una ventana emergente
    else:
        print("⚠️ Imagen no encontrada.") ##mensaje de error si no se encuentra el documento

if __name__ == "__main__":## verifica si el script se está ejecutando directament
    mostrar_imagen_marketplace('foto_zapatos_rojos')

