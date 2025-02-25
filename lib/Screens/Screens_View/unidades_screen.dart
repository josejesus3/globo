import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:globo/Screens/Screens_View/galeria_carrusel.dart';
import 'package:globo/providers/favoritos_provider.dart';

import 'package:globo/widget/fullscreen_view.dart';
import 'package:globo/widget/tabbar_unidades_economicas.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UnidadesScreen extends StatefulWidget {
  final String title;
  final String imagen;
  final String descripcion;
  final String? galeriaUrl;
  final String direccion;
  final String horario;
  final String numeroTelefonico;
  final double? endLatitude;
  final double? endLongitude;
  final String? url;
  final String? facebook;
  final String? instagram;
  final String? numeroWhatsApp;
  const UnidadesScreen({
    super.key,
    required this.title,
    required this.imagen,
    required this.descripcion,
    this.galeriaUrl,
    required this.direccion,
    required this.horario,
    required this.numeroTelefonico,
    this.endLatitude,
    this.endLongitude,
    this.url,
    this.facebook,
    this.instagram,
    this.numeroWhatsApp,
  });

  @override
  State<UnidadesScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<UnidadesScreen>
    with TickerProviderStateMixin {
  bool _favoriteRed = false;
  String distance = '';
  List<String> galeria = [];
  late FavoritosProvider favoritosProvider;

  // Referencia a la base de datos de Firebase
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  @override
  initState() {
    super.initState();
    favoritosProvider = context.read<FavoritosProvider>();
    _cargarFavorito();
  }

  @override
  Widget build(BuildContext context) {
    galeria.addAll((widget.galeriaUrl ?? '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(','));
    TabController tabController = TabController(length: 3, vsync: this);
    final textStyle = TextTheme.of(context)
        .titleLarge!
        .copyWith(color: Colors.white, fontSize: 21);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: textStyle,
        ),
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
            onPressed: () {
              setState(() {
                _favoriteRed = !_favoriteRed;
                _guardarFavorito(_favoriteRed);
                favoritosProvider.marcaFavoritos(widget.title);
              });
            },
            icon: Icon(
              _favoriteRed ? Icons.favorite : Icons.favorite_outline_sharp,
              size: 28,
              color: _favoriteRed
                  ? Colors.red.shade600
                  : widget.url != ''
                      ? Colors.white
                      : const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _CustomSliverAppBar(
            url: widget.url,
            title: widget.title,
            imagen: widget.imagen!,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
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
          ),
          SliverFillRemaining(
              child: Container(
            color: Colors.white,
            child: TabBarView(
              controller: tabController,
              children: [
                DescripcionTabBar(
                  descripcion: widget.descripcion.isNotEmpty == true
                      ? widget.descripcion
                      : "Sin descripción",
                ),
                widget.galeriaUrl == ''
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No hay imagen existente'),
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 28,
                            )
                          ],
                        ),
                      )
                    : GaleriaCarrusel(urls: galeria),
                ContactoWidget(
                  facebook: widget.facebook,
                  instagram: widget.instagram,
                  numeroWhatsApp: widget.numeroWhatsApp,
                  direccion: widget.direccion,
                  horario: widget.horario,
                  numeroTelefonico: widget.numeroTelefonico,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  void _cargarFavorito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRed = prefs.getBool(widget.title) ?? false;
    });
  }

  void _guardarFavorito(bool favorito) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.title, favorito);
  }
}

class _CustomSliverAppBar extends StatefulWidget {
  final String? url;
  final String title;
  final String imagen;

  const _CustomSliverAppBar({
    super.key,
    required this.url,
    required this.title,
    required this.imagen,
  });

  @override
  State<_CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref('UnidadesEconomicas');

class _CustomSliverAppBarState extends State<_CustomSliverAppBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return SliverAppBar(
      leading: Container(),
      backgroundColor: Colors.black,
      expandedHeight:
          sized.height * 0.45, // Ajusta la altura según sea necesario
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: widget.url != ''
                  ? GestureDetector(
                      onDoubleTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imageUrl: widget.url!),
                        ),
                      ),
                      child: Image.network(
                        widget.url!,
                        width:
                            double.infinity, // Asegura que ocupe todo el ancho
                        height: 250, // Aquí ajustas el tamaño específico
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) return const SizedBox();
                          return FadeIn(child: child);
                        },
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Image.asset(
                        widget.imagen,
                        width: double.infinity,
                        height: 250, // Ajusta el tamaño aquí
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
