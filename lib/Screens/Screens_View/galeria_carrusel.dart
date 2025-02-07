import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;

class GaleriaCarrusel extends StatelessWidget {
  final List<String> urls;

  const GaleriaCarrusel({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: urls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              url.trim(),
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
            );
          },
        );
      }).toList(),
    );
  }
}