import 'package:flutter/material.dart';
import 'package:globo/widget/fullscreen_view.dart';

class GaleriaCarrusel extends StatelessWidget {
  final List<String> urls;

  const GaleriaCarrusel({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    final shrink = 200.0;
    final sized = MediaQuery.of(context).size;

    return CarouselView.weighted(
      controller: carouselController,
      flexWeights: [1, 10, 1], // Ajusta los "pesos" de las páginas
      shrinkExtent: shrink, // Controla el tamaño de la imagen
      scrollDirection: Axis.horizontal, // Dirección de desplazamiento
      onTap: (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(imageUrl: urls[value]),
          ),
        );
      },
      children: List.generate(
        urls.length,
        (index) {
          return Image.network(
            urls[index].trim(),
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              final totalByte = loadingProgress.expectedTotalBytes ?? 1;
              final loadedBytes = loadingProgress.cumulativeBytesLoaded;
              final progress = loadedBytes / totalByte;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${(progress * 100).toStringAsFixed(0)}%')
                ],
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text("Falla en cargar imagen"),
              );
            },
          );
        },
      ),
    );
  }
}

/*CarouselSlider(
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
                print(url);
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
    );*/
