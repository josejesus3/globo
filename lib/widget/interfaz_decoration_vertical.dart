// Importaciones necesarias

import 'package:flutter/material.dart';

/*Este código define un widget personalizado llamado CustomImagenVertical que muestra una 
imagen, texto y calificación verticalmente. 
Puedes ajustar la apariencia y el diseño según tus necesidades. 
Si tienes alguna pregunta específica sobre alguna parte del código, estoy aquí para ayudar.*/

// Widget personalizado para mostrar una imagen verticalmente con texto y calificación
class CustomImagenVertical extends StatefulWidget {
  // Propiedades necesarias para la creación del widget
  final String imagen;
  final String? url;
  final String text;
  final VoidCallback onPressed;

  // Constructor que requiere las propiedades mencionadas
  const CustomImagenVertical({
    super.key,
    required this.imagen,
    required this.text,
    required this.onPressed,
    this.url,
  });

  // Método para crear el estado del widget
  @override
  State<CustomImagenVertical> createState() => _CustomImagenVerticalState();
}

// Estado del widget para el widget personalizado de imagen vertical
class _CustomImagenVerticalState extends State<CustomImagenVertical> {
  @override
  Widget build(BuildContext context) {
    const double ancho = 110;
    const double alto = 95;
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        margin: const EdgeInsets.only(left: 15, right: 22, top: 10, bottom: 10),
        child: Container(
          height: 75,
          color: const Color.fromARGB(255, 231, 231, 231),
          child: Row(
            children: [
              (widget.url != null && widget.url!.isNotEmpty)
                  ? _ImagenUrl(widget: widget)
                  : Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/IconoColor.png', // Icono de la app predeterminado
                          width: 300,
                          height: 300,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10), // Ajuste del padding horizontal
                  child: Align(
                    alignment: Alignment.centerLeft, // Centra el texto verticalmente
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontFamily: "Heiti TC",
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagenUrl extends StatelessWidget {
  const _ImagenUrl({
    required this.widget,
  });

  final CustomImagenVertical widget;

  @override
  Widget build(BuildContext context) {
    const double ancho = 110;
    const double alto = 75;
    return Expanded(
      flex: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: Image.network(
          widget.url!,
          width: ancho,
          height: alto,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const SizedBox(
                width: ancho,
                height: alto,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black26,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              width: ancho,
              height: alto,
              child: Center(child: Text('Error de conexión')),
            );
          },
        ),
      ),
    );
  }
}
