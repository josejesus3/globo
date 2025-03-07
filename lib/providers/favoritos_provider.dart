import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosProvider extends ChangeNotifier {
  // Lista de favoritos
  var favoritos = <String>[];

  FavoritosProvider() {
    _cargarFavoritos();
  }

  // Método para marcar o desmarcar favoritos
  void marcaFavoritos(String unidadEconomica) {
    if (favoritos.contains(unidadEconomica)) {
      favoritos.remove(unidadEconomica); // Eliminar favorito
    } else {
      favoritos.add(unidadEconomica); // Agregar favorito
    }
    _guardarFavoritos(); // Guardar la lista actualizada en SharedPreferences
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  // Método para verificar si una unidad es favorita
  bool esFavorito(String unidadEconomica) {
    return favoritos
        .contains(unidadEconomica); // Retorna si está en la lista de favoritos
  }

  // Método para guardar los favoritos en SharedPreferences
  Future<void> _guardarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritos', favoritos); // Guardar lista de favoritos
  }

  // Método para cargar los favoritos desde SharedPreferences
  Future<void> _cargarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoritos = prefs.getStringList('favoritos') ??
        []; // Cargar favoritos o lista vacía
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }
}
