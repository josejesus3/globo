import 'package:globo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  Query databaseReference =
      FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
  bool isLoading = true;

  @override
  String get searchFieldLabel => 'Escribe qué deseas buscar';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.white, // Asegúrate de que el texto al escribir sea blanco
        fontWeight: FontWeight.w400,
      );

  // Cambiar la apariencia del AppBar
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      // Cambia el color de fondo del AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF202A53), // El color de fondo del AppBar
        elevation: 0,
      ),
      // Cambia el color de los íconos
      iconTheme: const IconThemeData(
        color: Colors.white, // Cambia el color de los íconos (volver y tachita)
      ),
      // Cambia el estilo del campo de texto de búsqueda
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          // Estilo del texto cuando se escribe
          color: Colors.white, // Mantén el texto en blanco
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white54, // Cambia el color del placeholder
        ),
        border: InputBorder.none, // Elimina el borde inferior
      ),
    );
  }

  // Botón de volver atrás
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color:
            Colors.white, // Cambia el color del ícono de volver atrás a blanco
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Botón de acción para limpiar la búsqueda (tachita)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
          color: Colors.white, // Cambia el color de la tachita a blanco
        ),
      )
    ];
  }

  // Resultados de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return buscador(query: query, databaseReference: databaseReference);
  }

  // Sugerencias de búsqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? const Text('')
        : buscador(query: query, databaseReference: databaseReference);
  }

  // Función para manejar los resultados del buscador
  Widget buscador({required String query, required Query databaseReference}) {
    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.snapshot.value != snapshot) {
          // Verifica si hay datos y si los datos son diferentes a los anteriores
          return query != ''
              ? FirebaseAnimatedList(
                  query: databaseReference,
                  shrinkWrap: true,
                  itemBuilder: (context, snapshot, animation, index) {
                    final unidadEco =
                        snapshot.child('NombreNegocio').value.toString();

                    if (unidadEco
                            .toLowerCase()
                            .trim()
                            .startsWith(query.toLowerCase().trim()) ||
                        unidadEco
                            .toLowerCase()
                            .trim()
                            .contains(query.toLowerCase().trim())) {
                      // Filtra la lista basándose en la consulta
                      return CustomFirebaseList(
                        snapshot: snapshot,
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : const Center(
                  child: Text(
                    'Por favor Ingresar Unidad económica a buscar',
                    style: TextStyle(fontSize: 15),
                  ),
                );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras espera los datos
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          // Puedes mostrar un mensaje de carga más largo aquí si lo deseas
          return Container();
        }
      },
    );
  }
}
