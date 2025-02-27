import 'package:flutter/material.dart';

class NewTitulo extends ChangeNotifier {
  String? titulo;
  void actualizacion(String originalTitulo) {
    titulo = originalTitulo;

    print(titulo);
  }
}
