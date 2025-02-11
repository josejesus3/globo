import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globo/widget/custom_navigatorbar.dart';
import '../../delegates/buscador_delegate.dart';
import '../../widget/popup_menu.dart';
import 'contenido.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  double u = 0;
  Future<bool> onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Desea salir de la aplicación?'),
            content:
                const Text('Presione "Aceptar" para salir de la aplicación'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarGrullo(context),
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: const SingleChildScrollView(
          child: Contenido(),
        ),
      ),
      bottomNavigationBar: CostomBottonNavigatorBar(currentIndex: 0),
    );
  }
}

AppBar appBarGrullo(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false, // Mantiene el botón de "volver" oculto
    titleSpacing: 0, // Espaciado predeterminado
    backgroundColor: const Color(0xFF202A53), // Color sólido para el AppBar

    title: ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16), // Ajusta el espacio en torno al contenido
      title: Container(
        height: 38,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          color: Colors.white,
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 25,
              ),
            ),
            Text(
              'Buscar',
              style: TextStyle(
                  fontFamily: "Heiti TC",
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          //Que sea de color rojo
          colors: [Color(0xFF202A53), Color(0xFF202A53)],
        ),
      ),
    ),
    actions: const [
      PopupMenu(),
    ],
  );
}
