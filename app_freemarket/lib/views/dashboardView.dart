import 'package:flutter/material.dart';
import 'package:app_freemarket/views/mapView.dart';
import 'package:app_freemarket/views/perfilView.dart';
import 'package:app_freemarket/views/sucursales.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0; // Variable para el índice seleccionado

  void _onItemTapped(int index) {
    // Maneja el cambio de índice
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lista de vistas para el IndexedStack
    final List<Widget> _views = [
      MapView(),
      Sucursales(),
      PerfilView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Sucursales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(
            255, 8, 147, 228), // Estilo para el ítem seleccionado
        onTap: _onItemTapped,
      ),
    );
  }
}
