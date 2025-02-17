import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:globo/services/select_image.dart';
import 'package:globo/widget/tabbar_unidades_economicas.dart';
import 'package:image_picker/image_picker.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF202A53),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final XFile? image = await selectImage();
              setState(() {
                if (image == null) {
                } else {
                  setState(() {
                    imagenUpload = File(image.path);
                  });
                }
              });
            },
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
              color: widget.url != ''
                  ? Colors.white
                  : imagenUpload != null
                      ? Colors.white
                      : Colors.white,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            url: widget.url,
            title: widget.title,
            imagen: widget.imagen!,
            imagenUpload: imagenUpload,
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(icon: Icon(Icons.description_outlined)),
                Tab(icon: Icon(Icons.photo_outlined)),
                Tab(icon: Icon(Icons.contact_phone_outlined)),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabController,
              children: [
                // Aquí puedes poner el contenido de cada pestaña
                RegistroDescripcion(
                    textFieldDescripcion: _textFieldDescripcion),

                // Para la pestaña de elegir imágenes, asignamos dimensiones específicas:
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Elegir Imagenes'),
                      IconButton(
                        onPressed: widget.galeriaUrl != ''
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GaleriaImagen(
                                          contactKey: widget.contactKey,
                                          galeriaUrl: galeria),
                                    ));
                              }
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GaleriaSinUrl(
                                          contactKey: widget.contactKey),
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

                // Para el contenido de contacto, también puedes agregar dimensiones:
                Container(
                  padding: EdgeInsets.all(16),
                  child: RegistroContacto(
                    textFieldDireccion: _textFieldDireccion,
                    textFieldHorarioSalida: _textFieldhorarioSalida,
                    textFieldHorarioEntrada: _textFieldhorarioEntrada,
                    textFieldtelefono: _textFieldTelefono,
                    textFieldFacebook: _textFieldFacebook,
                    textFieldInstagram: _textFieldInstagram,
                    textFieldWhatsApp: _textFieldWhatsApp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatefulWidget {
  final String? url;
  final String title;
  final String imagen;
  final File? imagenUpload;

  const _CustomSliverAppBar(
      {super.key,
      required this.url,
      required this.title,
      required this.imagen,
      this.imagenUpload});

  @override
  State<_CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref('UnidadesEconomicas');

class _CustomSliverAppBarState extends State<_CustomSliverAppBar> {
  final TextEditingController _textFieldTitulo = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFieldTitulo.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return SliverAppBar(
      leading: Container(),
      backgroundColor: Colors.black,
      expandedHeight: sized.height * 0.65,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: TextFormField(
          style: const TextStyle(fontSize: 14),
          controller: _textFieldTitulo,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.horizontal(),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 10, right: 20, bottom: 30),
        background: Stack(
          children: [
            SizedBox.expand(
              child: widget.url != ''
                  ? Image.network(
                      widget.url!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) return const SizedBox();
                        return FadeIn(child: child);
                      },
                    )
                  : Container(
                      color: Colors.white,
                      child: Image.asset(
                        widget.imagen,
                      ),
                    ),
            ),
            widget.imagenUpload != null
                ? Image.file(
                    widget.imagenUpload!,
                    width: sized.width * 1.0,
                    height: sized.height * 0.7,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
