import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:globo/providers/favoritos_provider.dart';
import 'package:globo/services/firebase_list.dart';
import 'package:globo/widget/custom_navigatorbar.dart';
import 'package:provider/provider.dart';

class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    final List<String> unidadesFavoritas = favoritosProvider.favoritos;

    Query databaseReference =
        FirebaseDatabase.instance.ref().child('UnidadesEconomicas');

    final textStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Colors.black, fontSize: 19);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favoritos",
          style: const TextStyle(
            fontFamily: "Heiti TC",
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF202A53), // Cambia el color del AppBar
        centerTitle: true, // Centra el título
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          color: Colors.white,
        ),
      ),
      body: unidadesFavoritas.isEmpty
          ? Center(
              child: Text(
                'Sin Favoritos',
                style: textStyle,
              ),
            )
          : FirebaseAnimatedList(
              query: databaseReference,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final String unidadEconomica =
                    snapshot.child('NombreNegocio').value.toString();

                if (unidadesFavoritas.contains(unidadEconomica)) {
                  return CustomFirebaseList(snapshot: snapshot);
                } else {
                  return Container();
                }
              },
            ),
      bottomNavigationBar: CostomBottonNavigatorBar(currentIndex: 1),
    );
  }
}
