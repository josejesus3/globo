import 'package:globo/Screens/Screens_View/unidades_screen.dart';
import 'package:globo/widget/interfaz_decoration_vertical.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

/// Widget personalizado para mostrar una lista de elementos desde Firebase.
class CustomFirebaseList extends StatefulWidget {
  final DataSnapshot snapshot;

  const CustomFirebaseList({super.key, required this.snapshot});

  @override
  CustomFirebaseListState createState() => CustomFirebaseListState();
}

class CustomFirebaseListState extends State<CustomFirebaseList> {
  @override
  Widget build(BuildContext context) {
    return CustomImagenVertical(
      url: widget.snapshot.child('Url').value.toString(),
      imagen: 'assets/logo.png',
      text: widget.snapshot.child('NombreNegocio').value.toString(),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => UnidadesScreen(
              title: widget.snapshot.child('NombreNegocio').value.toString(),
              imagen: 'assets/logoBaner.png',
              descripcion:
                  widget.snapshot.child('DescripcionNegocio').value.toString(),
              direccion: widget.snapshot.child('Domicilio').value.toString(),
              horario:
                  '${widget.snapshot.child('HoraApertura').value.toString()}'
                  ' ${widget.snapshot.child('HoraCierre').value.toString()}',
              numeroTelefonico:
                  widget.snapshot.child('NumeroTelefonico').value.toString(),
              url: widget.snapshot.child('Url').value.toString(),
              galeriaUrl: widget.snapshot.child('GaleriaUrl').value.toString(),
              instagram: widget.snapshot.child('Instagram').value.toString(),
              facebook: widget.snapshot.child('Facebook').value.toString(),
              numeroWhatsApp:
                  widget.snapshot.child('WhatsApps').value.toString(),
            ),
          ),
        );
      },
    );
  }
}
