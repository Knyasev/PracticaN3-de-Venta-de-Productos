import 'package:app_freemarket/views/perfilView.dart';
import 'package:app_freemarket/views/sucursales.dart';
import 'package:flutter/material.dart';
import 'package:app_freemarket/views/dashboardView.dart'; // Asegúrate de importar correctamente DashboardView
import 'package:app_freemarket/views/mapView.dart'; // Importa tu vista de mapa aquí

class Menubar extends StatefulWidget {
  const Menubar({Key? key}) : super(key: key);

  @override
  _MenubarState createState() => _MenubarState();
}

class _MenubarState extends State<Menubar> {
  // Variable para almacenar el widget actual
  Widget _currentWidget =
      DashboardView(); // Inicializa con DashboardView o cualquier otra vista inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sucursales"), // Título de la barra de navegación
      ),
      drawer: Drawer(
        // Menú lateral con opciones
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Opciones del Menú'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),

            ListTile(
              title: Text('Mapa'),
              onTap: () {
                // Actualiza el widget actual a MapView
                setState(() {
                  _currentWidget =
                      MapView(); // Asegúrate de que MapView sea el nombre correcto de tu vista de mapa
                });
                // Cierra el drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sucursales'),
              onTap: () {
                // Actualiza el widget actual a MapView
                setState(() {
                  _currentWidget =
                      Sucursales(); // Asegúrate de que MapView sea el nombre correcto de tu vista de mapa
                });
                // Cierra el drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                // Actualiza el widget actual a MapView
                setState(() {
                  _currentWidget =
                      PerfilView(); // Asegúrate de que MapView sea el nombre correcto de tu vista de mapa
                });
                // Cierra el drawer
                Navigator.pop(context);
              },
            ),
            // Agrega más opciones aquí si es necesario
          ],
        ),
      ),
      body: Center(
        child: _currentWidget, // Muestra el widget actual
      ),
    );
  }
}
