import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:globo/Screens/home/principal.dart';
import 'package:globo/providers/favoritos_provider.dart';
import 'package:globo/services/firebase_list.dart';
import 'package:globo/widget/custom_navigatorbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  Query databaseReference =
      FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
  late FavoritosProvider favoritosProvider;

  List<String> unidadesFavoritas = [];

  @override
  void initState() {
    super.initState();
    favoritosProvider = context.read<FavoritosProvider>();
    _cargarUnidadesFavoritas();
    _cargarFavoritas();
  }

  void _cargarUnidadesFavoritas() {
    // Obtén la lista de unidades favoritas del FavoritosProvider
    setState(() {
      unidadesFavoritas = favoritosProvider.favoritos;
    });
  }

  void _cargarFavoritas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtén la lista de unidades favoritas del SharedPreferences
    List<String>? storedFavoritos = prefs.getStringList('favoritos');

    if (storedFavoritos != null) {
      setState(() {
        unidadesFavoritas = storedFavoritos;
      });
    }
  }

  // Función para guardar la lista en SharedPreferences
  void _guardarUnidadesFavoritas(List<String> favoritos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritos', favoritos);
  }

  void _eliminarFavorito(String favorito) async {
    setState(() {
      unidadesFavoritas.remove(favorito);
    });

    // Guardar la lista de favoritos actualizada en SharedPreferences
    _guardarUnidadesFavoritas(unidadesFavoritas);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextTheme.of(context).titleLarge!.copyWith(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19);
    return Scaffold(
      appBar: appBarGrullo(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            unidadesFavoritas.isEmpty
                ? Center(
                    child: Text('Sin Favoritos', style: textStyle),
                  )
                : FirebaseAnimatedList(
                    query: databaseReference,
                    shrinkWrap:
                        true, // Permite que la lista se ajuste a su contenido
                    physics:
                        const NeverScrollableScrollPhysics(), // Deshabilita el scroll independiente
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      final String unidadEconomica =
                          snapshot.child('NombreNegocio').value.toString();
                      if (unidadesFavoritas.contains(unidadEconomica)) {
                        return GestureDetector(
                          onLongPress: () => _eliminarFavorito(
                              unidadEconomica), // Eliminamos el favorito al mantener presionado
                          child: CustomFirebaseList(snapshot: snapshot),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CostomBottonNavigatorBar(currentIndex: 1),
    );
  }
}
