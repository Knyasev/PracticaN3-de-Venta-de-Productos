import 'package:flutter/material.dart';
import 'package:app_freemarket/controller/Services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Sucursales extends StatefulWidget {
  const Sucursales({Key? key}) : super(key: key);

  @override
  _SucursalesState createState() => _SucursalesState();
}

class _SucursalesState extends State<Sucursales> {
  String? _selectedSucursal;
  List<Map<String, dynamic>> _sucursales = [];
  Map<String, dynamic>? _selectedSucursalData;
  List<Map<String, dynamic>> _productos = [];
  LatLng markerPosition =
      LatLng(51.509364, -0.128928); // Posición inicial del marcador
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    cargarSucursales();
  }

  void cargarSucursales() async {
    try {
      Services sucursal = Services();
      final value = await sucursal.getSucursales();
      print(value.datos);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> sucursales = value.datos;

        setState(() {
          _sucursales = sucursales
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            var sucursal = element as Map<String, dynamic>;
            return {
              'external_id': sucursal['external_id'],
              'nombre': sucursal['nombre'],
              'direccion': sucursal['direccion'],
              'latitud': sucursal['latitud'], // Add latitude
              'longitud': sucursal['longitud'], // Add longitude
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar sucursales: $e");
    }
  }

  void cargarProductos(String key) async {
    try {
      Services sucursal = Services();
      final value = await sucursal.getProductos(key);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> productos = value.datos;

        setState(() {
          _productos = productos
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            var producto = element as Map<String, dynamic>;
            return {
              'nombre': producto['nombre'],
              'precio': producto['precio'],
              'estado': producto['estado']['name'],
              'stock': producto['stock'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  void cargarProductoPorCaducar(String key) async {
    try {
      Services sucursal = Services();
      final value = await sucursal.getProductosPorCaducar(key);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> productos = value.datos;

        setState(() {
          _productos = productos
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            var producto = element as Map<String, dynamic>;
            return {
              'nombre': producto['nombre'],
              'precio': producto['precio'],
              'estado': producto['estado']['name'],
              'stock': producto['stock'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  void cargarProductosCaducados(String key) async {
    try {
      Services sucursal = Services();
      final value = await sucursal.getProductosCaducados(key);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> productos = value.datos;

        setState(() {
          _productos = productos
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            var producto = element as Map<String, dynamic>;
            return {
              'nombre': producto['nombre'],
              'precio': producto['precio'],
              'estado': producto['estado']['name'],
              'stock': producto['stock'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  void cargarProductosBuenos(String key) async {
    try {
      Services sucursal = Services();
      final value = await sucursal.getProductosBueno(key);
      if (value.code == '200' && value.datos != null) {
        List<dynamic> productos = value.datos;

        setState(() {
          _productos = productos
              .where((element) =>
                  element != null && element is Map<String, dynamic>)
              .map((element) {
            var producto = element as Map<String, dynamic>;
            return {
              'nombre': producto['nombre'],
              'precio': producto['precio'],
              'estado': producto['estado']['name'],
              'stock': producto['stock'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: Text('Seleccione una sucursal'),
              value: _selectedSucursal,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSucursal = newValue;
                  _selectedSucursalData = _sucursales.firstWhere((sucursal) =>
                      sucursal['external_id'].toString() == newValue);
                  markerPosition = LatLng(
                    _selectedSucursalData!['latitud'],
                    _selectedSucursalData!['longitud'],
                  );
                  // Mueve el mapa después de un breve retraso
                  Future.delayed(Duration(milliseconds: 300), () {
                    _mapController.move(markerPosition, 9.2);
                  });
                  cargarProductos(newValue!);
                });
              },
              items: _sucursales.map<DropdownMenuItem<String>>((sucursal) {
                return DropdownMenuItem<String>(
                  value: sucursal['external_id'].toString(),
                  child: Text(sucursal['nombre']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _selectedSucursalData != null
                ? Column(
                    children: [
                      Container(
                        height: 300,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: markerPosition,
                            zoom: 9.2,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () => Uri.parse(
                                      'https://openstreetmap.org/copyright'),
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: markerPosition,
                                  child: Column(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.red),
                                      Text(
                                        _selectedSucursalData!['nombre'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Text('Productos', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSucursal != null) {
                        cargarProductoPorCaducar(_selectedSucursal!);
                      }
                    },
                    child: Text('Por caducar'),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSucursal != null) {
                        cargarProductosCaducados(_selectedSucursal!);
                      }
                    },
                    child: Text('Caducados'),
                  ),
                ),
                SizedBox(width: 5), // Add some space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSucursal != null) {
                        cargarProductos(_selectedSucursal!);
                      }
                    },
                    child: Text('Todos los productos'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _productos.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _productos.length,
                      itemBuilder: (context, index) {
                        final producto = _productos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto['nombre'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text('Precio: \$${producto['precio']}'),
                                Text('Estado: ${producto['estado']}'),
                                Text('Stock: ${producto['stock']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
