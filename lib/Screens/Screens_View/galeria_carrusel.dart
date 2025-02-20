import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:globo/widget/fullscreen_view.dart';

class GaleriaCarrusel extends StatelessWidget {
  final List<String> urls;

  const GaleriaCarrusel({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: sized.height * 0.7,
        enlargeCenterPage: true,
        autoPlay: false, // Evitar que la imagen cambie automáticamente al tocar
      ),
      items: urls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // Aquí, cambiamos la navegación para asegurarnos de que no haya problemas de estado
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(imageUrl: url),
                  ),
                );
              },
              child: Image.network(
                url.trim(),
                width: double.infinity,
                height: sized.height * 0.7, // Ajustamos el tamaño de la imagen
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  } else {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: frame == null
                          ? const Center(child: CircularProgressIndicator())
                          : child,
                    );
                  }
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
