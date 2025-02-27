import 'package:globo/Screens/home/fondo_pantalla.dart';
import 'package:globo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:globo/providers/new_titulo.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/favoritos_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => NewTitulo()), // Proveedor para el título
        ChangeNotifierProvider(
            create: (_) =>
                FavoritosProvider()), // Otro proveedor (ejemplo para otro estado)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectColors: 1).theme(),
        title: 'El Globo',
        home: const FondoPantalla());
  }
}
