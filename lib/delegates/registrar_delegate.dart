import 'package:globo/Screens/Screens_View/registro_screen.dart';
import 'package:globo/Screens/Screens_View/registro_unidad_economica.dart';
import 'package:globo/login/login.dart';
import 'package:globo/widget/interfaz_decoration_vertical.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';

class RegisterSearchDelegate extends StatefulWidget {
  final String textUsuario;
  final String textRFC;
  const RegisterSearchDelegate({
    super.key,
    required this.textUsuario,
    required this.textRFC,
  });

  @override
  State<RegisterSearchDelegate> createState() => _RegisterSearchDelegateState();
}

class _RegisterSearchDelegateState extends State<RegisterSearchDelegate> {
  late Query databaseReference;
  bool botonExit = true;

  @override
  void initState() {
    databaseReference =
        FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        botonExit
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Login();
                }),
              )
            : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF202A53), // Color del AppBar
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Login();
                }),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: Colors.white, // Cambia el color del icono a blanco
            ),
          ),
          title: Text(
            widget.textUsuario, // Aquí se imprime el nombre del usuario
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          centerTitle: true, // Centra el nombre del usuario
        ),
        body: StreamBuilder(
          stream: databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != snapshot) {
              return widget.textUsuario != '' && widget.textRFC != ''
                  ? FirebaseAnimatedList(
                      query: databaseReference,
                      shrinkWrap: true,
                      itemBuilder: (context, snapshot, animation, index) {
                        return buildListTile(context, snapshot);
                      },
                    )
                  : const Center(
                      child: Text(
                        'Porfavor Ingresar Nombre y RFC correctos',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, DataSnapshot snapshot) {
    final nombrePropietario =
        snapshot.child('NombrePropietario').value.toString();
    final rfc = snapshot.child('RFC').value.toString();

    if (nombrePropietario.startsWith(widget.textUsuario.trim()) &&
        rfc.startsWith(widget.textRFC.trim())) {
      Map contact = snapshot.value as Map;
      contact['key'] = snapshot.key;

      return CustomImagenVertical(
        url: snapshot.child('Url').value.toString(),
        imagen: 'assets/logoBaner.png',
        text: snapshot.child('NombreNegocio').value.toString(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RegistroScreen(
                contactKey: contact['key'],
                title: snapshot.child('NombreNegocio').value.toString(),
                imagen: 'assets/logoBaner.png',
                descripcion:
                    snapshot.child('DescripcionNegocio').value.toString(),
                direccion: snapshot.child('Domicilio').value.toString(),
                horarioEntrada: snapshot.child('HoraApertura').value.toString(),
                horarioSalida: snapshot.child('HoraCierre').value.toString(),
                numeroTelefonico:
                    snapshot.child('NumeroTelefonico').value.toString(),
                url: snapshot.child('Url').value.toString(),
                galeriaUrl: snapshot.child('GaleriaUrl').value.toString(),
                instagram: snapshot.child('Instagram').value.toString(),
                facebook: snapshot.child('Facebook').value.toString(),
                whatsApp: snapshot.child('WhatsApps').value.toString(),
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
