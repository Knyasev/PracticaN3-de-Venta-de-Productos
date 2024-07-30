from flask import Blueprint, jsonify, make_response, request
from controllers.sucursalController import SucursalController
api_sucursal = Blueprint('api_sucursal', __name__)


sucursal = SucursalController()

@api_sucursal.route('/sucursal', methods=["GET"])
def listarSucursal():
    return make_response(
        jsonify({"msg":"OK", "code":200, "datos":([i.serialize for i in sucursal.listar()])}),
        200
    )


@api_sucursal.route('/sucursal/guardar', methods=["POST"])
def save():
    data = request.json
    sucursal_id = sucursal.save(data)
    return make_response(
        jsonify({"msg":"OK", "code":200, "data": sucursal_id}),
        200
    )       
