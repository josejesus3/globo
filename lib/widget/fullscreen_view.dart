import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Cierra la pantalla cuando se toca la imagen
        },
        child: Center(
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain, // Ajuste para que la imagen no se recorte
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return child;
              }
            },
          ),
        ),
      ),
    );
  }
}
