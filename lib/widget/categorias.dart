import 'package:globo/Screens/home/principal.dart';
import 'package:globo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Categorias extends StatelessWidget {
  final String categorias;
  const Categorias({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    Query databaseReference =
        FirebaseDatabase.instance.ref().child('UnidadesEconomicas');

    // Definimos las actividades económicas para cada categoría
    Map<String, List<String>> actividadesPorCategoria = {
      'Alimentos y Bebidas': [
        'Comercio al por menor de otros alimentos',
        'Servicios de preparación de otros alimentos para consumo inmediato',
        'Restaurantes con servicio de preparación de alimentos a la carta o de comida corrida',
        'Comercio al por menor de paletas de hielo y helados',
        'Elaboración de alimentos frescos para consumo inmediato',
        'Comercio al por menor de carnes rojas',
        'Comercio al por menor de cerveza',
        'Comercio al por menor de vinos y licores',
        'Panificación tradicional',
        'Elaboración de botanas',
        'Venta de Cerveza en envase cerrado anexo a Tienda de Conveniencia',
        'Venta de cerveza en envase cerrado anexo a mini super',
        'Cafeterías, fuentes de sodas, neverías, refresquerías y similares',
        'Venta de Cerveza en envase cerrado anexo Abarrotes',
        'Restaurantes con servicio de preparación de pizzas, hamburguesas, hot dogs y pollos rostizados para llevar'
      ],
      'Comercios Minoristas': [
        'Comercio al por menor de artículos de papelería',
        'Comercio al por menor de ropa, excepto de bebé y lencería',
        'Comercio al por menor de calzado',
        'Comercio al por menor de regalos',
        'Comercio al por menor en tiendas de abarrotes, ultramarinos y misceláneas',
        'Comercio al por menor de frutas y verduras frescas',
        'Comercio al por menor de cristalería, loza y utensilios de cocina',
        'Comercio al por menor de muebles para el hogar',
        'Comercio al por menor de teléfonos y otros aparatos de comunicación',
        'Comercio al por menor de vinos y licores',
        'Comercio al por menor de plantas y flores naturales',
        'Comercio al por menor de artículos de joyería y relojes',
        'Comercio al por menor de carne de aves',
        'Comercio al por menor de productos naturistas, medicamentos homeopáticos y de complementos alimenticios',
        'Comercio al por menor de bisutería y accesorios de vestir'
      ],
      'Servicios Personales': [
        'Salones y clínicas de belleza y peluquerías',
        'Lavado y lubricado de automóviles y camiones',
        'Consultorios dentales del sector privado',
        'Servicios de acceso a computadoras',
        'Consultorios de psicología del sector privado',
        'Billares',
        'Centros de acondicionamiento físico del sector privado',
        'Cafeterías, fuentes de sodas, neverías, refresquerías y similares',
        'Alquiler sin intermediación de salones para fiestas y convenciones',
        'Lavanderías y tintorerías',
        'Baños públicos',
        'Otros consultorios del sector privado para el cuidado de la salud',
        'Cerrajerías',
        'Consultorios de quiropráctica del sector privado',
        'Comercio al por menor de artículos de mercería y bonetería'
      ],
      'Talleres y Reparaciones': [
        'Reparación mecánica en general de automóviles y camiones',
        'Reparación y mantenimiento de motocicletas',
        'Reparación menor de llantas',
        'Hojalatería y pintura de automóviles y camiones',
        'Reparación y mantenimiento de aparatos eléctricos para el hogar y personales',
        'Cerrajerías',
        'Reparación y mantenimiento de maquinaria y equipo agropecuario y forestal',
        'Instalaciones de sistemas centrales de aire acondicionado y calefacción',
        'Reparación de tapicería de muebles para el hogar',
        'Tapicería de automóviles y camiones',
        'Rectificación de partes de motor de automóviles y camiones',
        'Reparación y mantenimiento de bicicletas',
        'Reparación del sistema eléctrico de automóviles y camiones',
        'Fabricación de productos de herrería',
        'Colocación de pisos flexibles y de madera'
      ],
      'Salud y Farmacéutico': [
        'Farmacias sin minisúper',
        'Consultorios dentales del sector privado',
        'Consultorios de nutriólogos y dietistas del sector privado',
        'Otros consultorios del sector privado para el cuidado de la salud',
        'Clínicas de consultorios médicos del sector privado',
        'Laboratorios médicos y de diagnóstico del sector privado',
        'Comercio al por menor de productos naturistas, medicamentos homeopáticos y de complementos alimenticios',
        'Consultorios de medicina general del sector privado',
        'Comercio al por menor de artículos ortopédicos',
        'Servicios de fotografía y videograbación',
        'Farmacias con minisúper'
      ],
      'Educación y Cultura': [
        'Escuelas de educación preescolar del sector privado',
        'Escuelas de educación primaria del sector privado',
        'Escuelas de educación secundaria general del sector privado',
        'Escuelas de educación media superior del sector privado',
        'Escuelas de idiomas del sector privado',
        'Academias de música',
        'Clases de danza',
        'Centros de formación cultural',
        'Otros servicios recreativos prestados por el sector privado',
        'Bibliotecas',
        'Escuelas de arte del sector privado'
      ],
      'Servicios Profesionales': [
        'Servicios de contabilidad y auditoría',
        'Bufetes jurídicos',
        'Consultorios de medicina general del sector privado',
        'Servicios veterinarios para la ganadería prestados por el sector privado',
        'Servicios funerarios',
        'Otros servicios relacionados con la contabilidad',
        'Servicios de rotulación y otros servicios de publicidad',
        'Servicios de preparación de otros alimentos para consumo inmediato',
        'Inmobiliarias y corredores de bienes raíces',
        'Agencias de viajes',
        'Servicios de fotocopiado, fax y afines'
      ],
      'Entretenimiento y Recreación': [
        'Parques de diversiones y temáticos del sector privado',
        'Parques acuáticos y balnearios del sector privado',
        'Centros de acondicionamiento físico del sector privado',
        'Cafeterías, fuentes de sodas, neverías, refresquerías y similares',
        'Venta de billetes de lotería, pronósticos deportivos y otros boletos de sorteo',
        'Alquiler sin intermediación de salones para fiestas y convenciones',
        'Billares',
        'Otros servicios recreativos prestados por el sector privado',
        'Comercio al por menor de juguetes',
        'Asilos y otras residencias del sector privado para el cuidado de ancianos'
      ]
    };
    // Lista de actividades económicas correspondientes a la categoría seleccionada
    List<String> actividadesCorrespondientes =
        actividadesPorCategoria[categorias] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categorias, // Mostrar el nombre de la categoría en el AppBar
          style: const TextStyle(
            fontFamily: "Heiti TC",
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF202A53), // Cambia el color del AppBar
        centerTitle: true, // Centra el título
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const Principal();
              }),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Colors.white, // Cambia el color del ícono a blanco
          ),
        ),
      ),
      body: StreamBuilder(
          stream: databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != snapshot) {
              return FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (context, snapshot, animation, index) {
                  final String actividadComercial =
                      snapshot.child('ActividadComercial').value.toString();

                  // Verifica si la actividad comercial pertenece a la categoría seleccionada
                  if (actividadesCorrespondientes.any((actividad) =>
                      actividadComercial
                          .toLowerCase()
                          .contains(actividad.toLowerCase()))) {
                    return CustomFirebaseList(snapshot: snapshot);
                  } else {
                    return Container();
                  }
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
