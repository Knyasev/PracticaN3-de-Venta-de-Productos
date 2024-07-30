from models.sucursal import Sucursal
from app import db
import uuid

class SucursalController:
    def listar(self):
        return Sucursal.query.all()
    
    def save(self, data):
        sucursal = Sucursal()
        sucursal.nombre = data.get("nombre")
        sucursal.direccion = data.get("direccion")
        sucursal.latitud = data.get("latitud")
        sucursal.longitud = data.get("longitud")
        sucursal.external_id = uuid.uuid4()
        db.session.add(sucursal)
        db.session.commit()
        return sucursal.id
    
    def update(self, data):
        sucursal = Sucursal.query.filter_by(external_id=data.get("external_id")).first()
        sucursal.nombre = data.get("nombre")
        sucursal.direccion = data.get("direccion")
        db.session.commit()
        return sucursal.id
    
        
    