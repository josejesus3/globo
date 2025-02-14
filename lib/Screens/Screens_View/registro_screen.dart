import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:globo/services/actualizar_registros.dart';
import 'package:globo/widget/tabbar_unidades_economicas.dart';

class RegistroScreen extends StatefulWidget {
  final String title;
  final String? imagen;
  final String descripcion;
  final String direccion;
  final String horarioEntrada;
  final String horarioSalida;
  final String numeroTelefonico;
  final String url;
  final String? galeriaUrl;
  final String? facebook;
  final String? instagram;
  final String? whatsApp;
  final String contactKey;
  const RegistroScreen({
    super.key,
    this.imagen,
    required this.contactKey,
    required this.title,
    required this.descripcion,
    required this.direccion,
    required this.horarioEntrada,
    required this.horarioSalida,
    required this.numeroTelefonico,
    required this.url,
    this.galeriaUrl,
    this.facebook,
    this.instagram,
    this.whatsApp,
  });

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textFieldTitulo = TextEditingController();
  final TextEditingController _textFieldDescripcion = TextEditingController();
  final TextEditingController _textFieldTelefono = TextEditingController();
  final TextEditingController _textFieldDireccion = TextEditingController();
  final TextEditingController _textFieldhorarioEntrada =
      TextEditingController();
  final TextEditingController _textFieldhorarioSalida = TextEditingController();
  final TextEditingController _textFieldFacebook = TextEditingController();
  final TextEditingController _textFieldInstagram = TextEditingController();
  final TextEditingController _textFieldWhatsApp = TextEditingController();

  // Referencia a la base de datos de Firebase
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  // Variable para determinar si el campo de texto está habilitado
  bool isTextFieldEnabled = false;

  // Archivo de imagen para subir o actualizar
  File? imagenUpload;

  // URL de la imagen principal y URL de la galería de imágenes
  String? url1;

  List<String> galeria = [];
  // Inicialización del estado del widget
  @override
  void initState() {
    super.initState();

    galeria.addAll((widget.galeriaUrl ?? '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(','));
    // Establecer los valores iniciales de los controladores de texto
    _textFieldTitulo.text = widget.title;
    _textFieldDescripcion.text = widget.descripcion;
    _textFieldTelefono.text = widget.numeroTelefonico;
    _textFieldDireccion.text = widget.direccion;
    _textFieldhorarioEntrada.text = widget.horarioEntrada;
    _textFieldhorarioSalida.text = widget.horarioSalida;
    _textFieldFacebook.text = widget.facebook!;
    _textFieldInstagram.text = widget.instagram!;
    _textFieldWhatsApp.text = widget.whatsApp!;
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            imagen: widget.imagen,
            title: widget.title,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: [
                      // Título editable y botón de actualización
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 35),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextFormField(
                                style: const TextStyle(fontSize: 25),
                                controller: _textFieldTitulo,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.horizontal(),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                IconButton(
                                  color: Colors.orange.shade500,
                                  onPressed: () {
                                    setState(() {
                                      url1 = widget.url;

                                      if (imagenUpload != null) {
                                        // Si al menos una imagen está presente
                                        DatabaseOperations.actualizarApp(
                                          titulo: _textFieldTitulo.text,
                                          descripcion:
                                              _textFieldDescripcion.text,
                                          telefono: _textFieldTelefono.text,
                                          direccion: _textFieldDireccion.text,
                                          horarioEntrada:
                                              _textFieldhorarioEntrada.text,
                                          horarioSalida:
                                              _textFieldhorarioSalida.text,
                                          imagenUpload: imagenUpload!,
                                          contactKey: widget.contactKey,
                                          databaseReference: databaseReference,
                                          context: context,
                                          url: url1!,
                                          facebook: widget.facebook!,
                                          instagram: widget.instagram!,
                                          whatsapp: _textFieldWhatsApp.text,
                                        );
                                      } else {
                                        // Si ninguna imagen está presente
                                        DatabaseOperations
                                            .actualizarAppSinImagen(
                                          titulo: _textFieldTitulo.text,
                                          descripcion:
                                              _textFieldDescripcion.text,
                                          telefono: _textFieldTelefono.text,
                                          direccion: _textFieldDireccion.text,
                                          horarioEntrada:
                                              _textFieldhorarioEntrada.text,
                                          horarioSalida:
                                              _textFieldhorarioSalida.text,
                                          contactKey: widget.contactKey,
                                          databaseReference: databaseReference,
                                          context: context,
                                          url: url1!,
                                          facebook: _textFieldFacebook.text,
                                          instagram: _textFieldInstagram.text,
                                          whatsapp: _textFieldWhatsApp.text,
                                        );
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit_document,
                                    size: 35,
                                    color: Color.fromARGB(255, 228, 149, 52),
                                  ),
                                ),
                                const Text('Actualizar'),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),

                      // Pestañas para descripción, galería y contacto
                      TabBar(
                        controller: tabController,
                        tabs: const [
                          Tab(icon: Icon(Icons.description_outlined)),
                          Tab(icon: Icon(Icons.photo_outlined)),
                          Tab(icon: Icon(Icons.contact_phone_outlined)),
                        ],
                      ),

                      // Contenido de las pestañas
                      SizedBox(
                        width: double.infinity,
                        height: 550,
                        child: TabBarView(controller: tabController, children: [
                          // Pestaña de descripción
                          RegistroDescripcion(
                              textFieldDescripcion: _textFieldDescripcion),

                          // Pestaña de galería de imágenes
                          Stack(
                            children: [
                              Positioned(
                                top: 100,
                                left: 150,
                                child: Column(
                                  children: [
                                    const Text('Elegir Imagenes'),
                                    IconButton(
                                      onPressed: widget.galeriaUrl != ''
                                          ? () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GaleriaImagen(
                                                            contactKey: widget
                                                                .contactKey,
                                                            galeriaUrl:
                                                                galeria),
                                                  ));
                                            }
                                          : () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GaleriaSinUrl(
                                                            contactKey: widget
                                                                .contactKey),
                                                  ));
                                            },
                                      icon: const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Pestaña de contacto
                          RegistroContacto(
                            textFieldDireccion: _textFieldDireccion,
                            textFieldHorarioSalida: _textFieldhorarioSalida,
                            textFieldHorarioEntrada: _textFieldhorarioEntrada,
                            textFieldtelefono: _textFieldTelefono,
                            textFieldFacebook: _textFieldFacebook,
                            textFieldInstagram: _textFieldInstagram,
                            textFieldWhatsApp: _textFieldWhatsApp,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatefulWidget {
  final String? imagen;
  final String title;
  const _CustomSliverAppBar(
      {super.key, required this.imagen, required this.title});

  @override
  State<_CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref('UnidadesEconomicas');

class _CustomSliverAppBarState extends State<_CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: sized.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        titlePadding: const EdgeInsets.only(left: 10, right: 20, bottom: 30),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                widget.imagen!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
