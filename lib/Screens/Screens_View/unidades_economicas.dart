// Importaciones necesarias
import 'package:globo/Screens/Screens_View/galeria_carrusel.dart';
import 'package:globo/widget/tabbar_unidades_economicas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favoritos_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Widget para mostrar detalles de una unidad económica
class UnidadesEconomicas extends StatefulWidget {
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

  const UnidadesEconomicas({
    super.key,
    required this.title,
    required this.imagen,
    required this.descripcion,
    this.galeriaUrl,
    required this.direccion,
    required this.horario,
    required this.numeroTelefonico,
    this.url,
    this.facebook,
    this.instagram,
    this.endLatitude,
    this.endLongitude,
    this.numeroWhatsApp,
  });

  @override
  State<UnidadesEconomicas> createState() => _UnidadesEconomicasState();
}

// Estado del widget UnidadesEconomicas
class _UnidadesEconomicasState extends State<UnidadesEconomicas>
    with TickerProviderStateMixin {
  bool _favoriteRed = false;
  final bool _backboton = true;
  final int _calculandoDistancia = 0;
  String distance = '';
  List<String> galeria = [];
  late FavoritosProvider favoritosProvider;

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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pop(); // Regresar a la pantalla anterior (categorías)
        return true; // Permite que el pop suceda
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    // Imagen de fondo
                    widget.url != ''
                        ? Image.network(
                            widget.url!,
                            width: double.infinity,
                            height: 380,
                            fit: BoxFit.cover,
                          )
                        : const Positioned(
                            top: 115,
                            left: 110,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 130,
                                ),
                                Text(
                                  'Sin portada/actualizar perfil',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                    // Botón de retroceso
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Regresar a la pantalla anterior (categorías)
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 35,
                        color: widget.url != ''
                            ? Colors.white
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 350),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 10),
                              child: ListTile(
                                title: Text(
                                  widget.title,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300),
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            TabBar(
                              controller: tabController,
                              tabs: const [
                                Tab(icon: Icon(Icons.description_outlined)),
                                Tab(icon: Icon(Icons.photo_outlined)),
                                Tab(icon: Icon(Icons.contact_phone_outlined)),
                              ],
                            ),
                            // Ajuste de altura en TabBarView con Scroll
                            SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  500, // Ajuste de altura para TabBarView
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  SingleChildScrollView(
                                    child: DescripcionTabBar(
                                      descripcion:
                                          widget.descripcion.isNotEmpty == true
                                              ? widget.descripcion
                                              : "Sin descripción",
                                    ),
                                  ),
                                  widget.galeriaUrl == ''
                                      ? const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('No hay imagen existente'),
                                              Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 28,
                                              )
                                            ],
                                          ),
                                        )
                                      : GaleriaCarrusel(urls: galeria),
                                  SingleChildScrollView(
                                    child: ContactoWidget(
                                      facebook: widget.facebook,
                                      instagram: widget.instagram,
                                      numeroWhatsApp: widget.numeroWhatsApp,
                                      direccion: widget.direccion,
                                      horario: widget.horario,
                                      numeroTelefonico: widget.numeroTelefonico,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Botón de favorito
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _favoriteRed = !_favoriteRed;
                            _guardarFavorito(_favoriteRed);
                            favoritosProvider.marcaFavoritos(widget.title);
                          });
                        },
                        icon: Icon(
                          _favoriteRed
                              ? Icons.favorite
                              : Icons.favorite_outline_sharp,
                          size: 40,
                          color: _favoriteRed
                              ? Colors.red.shade600
                              : widget.url != ''
                                  ? Colors.white
                                  : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
