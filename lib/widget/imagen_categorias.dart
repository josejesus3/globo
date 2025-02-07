import 'package:flutter/material.dart';

class ImagenCategorias extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagen;
  final String text;
  final double starRating;

  const ImagenCategorias({
    super.key,
    required this.onPressed,
    required this.imagen,
    this.text = '',
    required this.starRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 5.0), // Espacio a los lados (derecha e izquierda)
      child: GestureDetector(
        onTap: onPressed, // Hace que toda el área responda al toque
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagen,
                height: 130,
                width: 220,
                fit: BoxFit.cover, // Ajusta la imagen para llenar el área
              ),
            ),
            // Contenedor con nombre por categorías
            SizedBox(
              width: 200, // Limitar el ancho del contenedor del texto
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: "Heiti TC",
                      fontSize: 25,
                      color: Colors.white, // El texto seguirá siendo blanco
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign:
                        TextAlign.center, // Asegura que el texto esté centrado
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
