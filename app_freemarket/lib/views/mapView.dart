import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_freemarket/controller/Services.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  LatLng markerPosition =
      LatLng(51.509364, -0.128928); // Posición inicial del marcador
  List<Map<String, dynamic>> _sucursales = []; // Lista de sucursales
  List<Marker> _markers = [];
  MapController _mapController = MapController();
  List<Map<String, dynamic>> productosCaducados = [];
  String sucursalNombre = '';
  String sucursalDireccion = '';

  @override
  void initState() {
    super.initState();
    cargarSucursales(); // Cargar sucursales al iniciar
  }

  void cargarSucursales() async {
    try {
      Services sucursal = Services();
      print("Llamando al método para obtener sucursales...");
      final value = await sucursal.getSucursales();
      print("Código de respuesta: ${value.code}");
      if (value.code == '200' && value.datos != null) {
        List<dynamic> sucursales = value.datos;
        print("Datos de sucursales recibidos: $sucursales");

        setState(() {
          _sucursales = sucursales
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            return {
              'nombre': element['nombre'],
              'latitud': element['latitud'],
              'longitud': element['longitud'],
              'direccion': element['direccion'], // Agrega la dirección
              'external_id': element['external_id'], // Agrega el externalId
              'tiene_caducados':
                  false, // Inicialmente no sabemos si tiene caducados
            };
          }).toList();
          _addMarkers(); // Llama a _addMarkers para agregar los marcadores al mapa
          _centerMapOnAllSucursales(); // Centra el mapa para ver todas las sucursales
        });

        // Verificar productos caducados para cada sucursal
        for (var sucursal in _sucursales) {
          await verificarProductosCaducados(sucursal['external_id']);
        }
      }
    } catch (e) {
      print("Error al cargar sucursales: $e");
    }
  }

  Future<void> verificarProductosCaducados(String key) async {
    try {
      Services productos = Services();
      final value = await productos.getProductosCaducados(key);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> producto = value.datos;
        bool tieneCaducados = producto.any((element) =>
            element != null &&
            element is Map<String, dynamic> &&
            element['estado']?['name'] == 'CADUCADO');

        setState(() {
          _sucursales = _sucursales.map((sucursal) {
            if (sucursal['external_id'] == key) {
              sucursal['tiene_caducados'] = tieneCaducados;
            }
            return sucursal;
          }).toList();
          _addMarkers(); // Actualizar los marcadores
        });
      }
    } catch (e) {
      print("Error al verificar productos caducados: $e");
    }
  }

  void _addMarkers() {
    _markers = _sucursales.map((sucursal) {
      print("Agregando marcador para sucursal: ${sucursal['nombre']}");
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(sucursal['latitud'], sucursal['longitud']),
        child: GestureDetector(
          onTap: () => _onMarkerTapped(
              sucursal['external_id'], sucursal['tiene_caducados']),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  sucursal['nombre'] ?? 'Nombre no disponible',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.location_on,
                color: sucursal['tiene_caducados'] ? Colors.red : Colors.green,
                size: 40,
              ),
            ],
          ),
        ),
      );
    }).toList();
    print("Total de marcadores agregados: ${_markers.length}");
  }

  void _onMarkerTapped(String externalId, bool tieneCaducados) {
    print("Marcador con externalId $externalId clicado");
    if (tieneCaducados) {
      cargarProductosCaducados(externalId);
    }
  }

  void cargarProductosCaducados(String key) async {
    try {
      Services productos = Services();
      print("Llamando al método para obtener productos caducados...");
      final value = await productos.getProductosCaducados(key);
      print("Código de respuesta: ${value.code}");
      if (value.code == '200' && value.datos != null) {
        List<dynamic> producto = value.datos;
        print("Datos de productos caducados recibidos: $producto");

        setState(() {
          productosCaducados = producto
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            return {
              'nombre': element['nombre'] ?? 'Nombre no disponible',
              'precio': element['precio'] ?? 0.0,
              'estado': element['estado']?['name'] ?? 'Estado no disponible',
              'stock': element['stock'] ?? 0,
            };
          }).toList();

          // Obtener la sucursal correspondiente
          var sucursal = _sucursales.firstWhere((s) => s['external_id'] == key);
          sucursalNombre = sucursal['nombre'];
          sucursalDireccion = sucursal['direccion'];
        });

        // Mostrar el panel con los productos caducados
        _showProductosCaducadosPanel();
      }
    } catch (e) {
      print("Error al cargar productos caducados: $e");
    }
  }

  void _centerMapOnAllSucursales() {
    if (_sucursales.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLon = double.infinity;
    double maxLon = double.negativeInfinity;

    for (var sucursal in _sucursales) {
      double lat = sucursal['latitud'];
      double lon = sucursal['longitud'];

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lon < minLon) minLon = lon;
      if (lon > maxLon) maxLon = lon;
    }

    LatLngBounds bounds = LatLngBounds(
      LatLng(minLat, minLon),
      LatLng(maxLat, maxLon),
    );

    _mapController.fitBounds(bounds,
        options: FitBoundsOptions(padding: EdgeInsets.all(20)));
  }

  void _showProductosCaducadosPanel() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sucursal: $sucursalNombre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Dirección: $sucursalDireccion',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ...productosCaducados.map((producto) {
                return ListTile(
                  title: Text(producto['nombre']),
                  subtitle: Text('Estado: ${producto['estado']}'),
                  trailing: Text('\$${producto['precio']}'),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: markerPosition,
              zoom: 9.2,
              onTap: (tapPosition, point) {
                setState(() {
                  markerPosition = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () =>
                        Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ],
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.8), // More transparent background
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 8),
                      Text('No tiene productos caducados'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Tiene productos caducados'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cargarSucursales, // Llama a cargarSucursales al presionar
        tooltip: 'Cargar Sucursales',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
