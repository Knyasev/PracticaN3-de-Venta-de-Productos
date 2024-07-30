import 'package:app_freemarket/views/dashboardView.dart';
import 'package:app_freemarket/views/loginview.dart';
import 'package:flutter/material.dart';
import 'package:app_freemarket/views/menubar.dart';
import 'package:app_freemarket/views/mapView.dart';
import 'package:app_freemarket/views/sucursales.dart';
import 'package:app_freemarket/views/perfilView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const LoginView(), // Asegúrate de
        '/Dashboard': (context) => _dashboard(),
        '/Menubar': (context) => const Menubar(), // Ruta a Menubar
        '/map': (context) => const MapView(), // Ruta a MapView
        '/sucursales': (context) => const Sucursales(), // Ruta a Sucursales
        '/perfil': (context) => const PerfilView(), // Ruta a PerfilView
      },
      home: const LoginView(),
    );
  }

  Widget _dashboard() {
    return DashboardView();
  }
}
