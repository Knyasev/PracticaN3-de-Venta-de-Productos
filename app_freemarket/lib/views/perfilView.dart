import 'package:flutter/material.dart';
import 'package:app_freemarket/controller/Services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({Key? key}) : super(key: key);

  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController claveController = TextEditingController();
  List<Map<String, dynamic>> cuentas = [];

  @override
  void initState() {
    super.initState();
    cargarPersona(); // Reemplaza "external_id" con el ID real
  }

  void cargarPersona() async {
    try {
      Services service = Services();
      final value = await service.getPersona();
      if (value.code == '200' && value.datos != null) {
        Map<String, dynamic> persona = value.datos;
        setState(() {
          nombreController.text = persona['nombre'];
          apellidoController.text = persona['apellido'];
          cuentas = List<Map<String, dynamic>>.from(persona['cuenta']);
          if (cuentas.isNotEmpty) {
            usuarioController.text = cuentas[0]['usuario'];
          }
        });
      }
    } catch (e) {
      print("Error al cargar la persona: $e");
    }
  }

  void guardarPersona(BuildContext context) async {
    FToast fToast = FToast();
    fToast.init(context);

    try {
      Services service = Services();
      Services personaService = Services();
      final persona = await personaService.getPersona();
      print(persona.datos);

      // Obtener el external_id de la cuenta
      String cuentaExternalId = '';
      if (persona.datos != null &&
          persona.datos['cuenta'] != null &&
          persona.datos['cuenta'].isNotEmpty) {
        cuentaExternalId = persona.datos['cuenta'][0]['external_id'];
      }

      Map<String, dynamic> data = {
        "nombre": nombreController.text,
        "apellido": apellidoController.text,
        "correo": usuarioController.text,
        "clave": claveController.text,
      };
      print(cuentaExternalId);

      final value = await service.guardarPersona(cuentaExternalId, data);
      print(value.code);
      if (value.code == '200') {
        fToast.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text("Datos guardados correctamente",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/Menubar');
        });
      } else {
        fToast.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade600,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 0), // Cambios de posición de la sombra
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text("Error al guardar los datos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade600,
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 0), // Cambios de posición de la sombra
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text("Error al guardar la persona",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
      print("Error al guardar la persona: $e");
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    usuarioController.dispose();
    claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: claveController,
              decoration: InputDecoration(labelText: 'Clave'),
              obscureText: true,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => guardarPersona(context),
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
