import 'package:globo/providers/favoritos_provider.dart';
import 'package:globo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/categorias.dart';
import '../../widget/imagen_categorias.dart';

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  Query databaseReference =
      FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
  late FavoritosProvider favoritosProvider;

  List<String> unidadesFavoritas = [];

  @override
  void initState() {
    super.initState();
    favoritosProvider = context.read<FavoritosProvider>();
  }

  // Función para guardar la lista en SharedPreferences

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 5, right: 5, bottom: 5), // Reducido el padding inferior
            child: GridView.count(
              crossAxisCount: 2, // 2 categorías por fila
              crossAxisSpacing: 2, // Espaciado horizontal reducido
              mainAxisSpacing: 2, // Espaciado vertical reducido
              childAspectRatio:
                  1.4, // Ajusta la proporción para hacerlas más compactas
              shrinkWrap:
                  true, // Permite que el GridView se ajuste a su contenido
              physics:
                  const NeverScrollableScrollPhysics(), // Deshabilita el scroll independiente
              children: [
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Alimentos y Bebidas',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 1.jpeg',
                  text: 'Alimentos \ny \nBebidas',
                  starRating: 4.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Comercios Minoristas',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 2.jpeg',
                  text: 'Comercios \n \n Minoristas',
                  starRating: 5.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Servicios Personales',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 3.jpeg',
                  text: 'Servicios \nPersonales',
                  starRating: 0.0,
                ),
                // Agrega aquí las categorías adicionales
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Talleres y Reparaciones',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 4.jpeg',
                  text: 'Talleres \ny \nReparaciones',
                  starRating: 0.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Salud y Farmacéutico',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 5.jpeg',
                  text: 'Salud \ny \nFarmacéuticos',
                  starRating: 0.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Educación y Cultura',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 6.jpeg',
                  text: 'Educación \ny \nCultura',
                  starRating: 0.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Servicios Profesionales',
                          //'',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 7.jpeg',
                  text: 'Servicios \nProfesionales',
                  starRating: 0.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Entretenimiento y Recreación',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/Categoria 8.jpeg',
                  text: 'Entretenimiento \ny \nRecreación',
                  starRating: 0.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
