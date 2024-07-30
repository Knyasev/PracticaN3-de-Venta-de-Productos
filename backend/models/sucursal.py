from app import db 
import uuid

class Sucursal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(60), nullable=False)
    direccion = db.Column(db.String(60), nullable=False)
    latitud= db.Column(db.Double, nullable=False)
    longitud= db.Column(db.Double, nullable=False)
    external_id = db.Column(db.String(60), default=str(uuid.uuid4()),nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())
    updated_at = db.Column(db.DateTime, server_default=db.func.now(), server_onupdate=db.func.now())
    
    @property
    def serialize(self):
        return {
            'nombre': self.nombre,
            'direccion': self.direccion,
            'external_id': self.external_id,
            'latitud': self.latitud,
            'longitud': self.longitud,
        }