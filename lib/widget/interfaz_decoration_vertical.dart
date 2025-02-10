// Importaciones necesarias

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globo/screen.dart';

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
    const double ancho = 100;
    const double alto = 140;
    double title = 16;
    double subtitle = 15;
    final textStyle = TextTheme.of(context).titleLarge!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            (widget.url != null && widget.url!.isNotEmpty)
                ? _ImagenUrl(widget: widget)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/IconoColor.png', // Icono de la app predeterminado
                      width: ancho,
                      height: alto,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: textStyle,
                  ),
                  // Subir texto del nombre
                  ListTile(
                    minVerticalPadding: 25,
                    contentPadding: EdgeInsets.only(right: 25),
                    title: Text(
                      'Número de Teléfono',
                      style: TextStyle(fontSize: title),
                    ),
                    subtitle: Text(
                      "321 106 02 19",
                      style: TextStyle(fontSize: subtitle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildListTile({
  required Widget title,
  required Widget subtitle,
  VoidCallback? onTap,
}) {
  return ListTile(
    title: title,
    subtitle: subtitle,
    onTap: onTap,
  );
}

class _ImagenUrl extends StatelessWidget {
  const _ImagenUrl({
    required this.widget,
  });

  final CustomImagenVertical widget;

  @override
  Widget build(BuildContext context) {
    const double ancho = 100;
    const double alto = 140;
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
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
    );
  }
}
