/*import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Screens/home/principal.dart';
import '../delegates/registrar_delegate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeUser = FocusNode();
  bool _obscurePassword = true;
  bool botonExit = true;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  final TextEditingController textUsuario = TextEditingController();
  final TextEditingController textRFC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        botonExit
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Principal();
                }),
              )
            : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              height: double.infinity, // Degradado cubre toda la pantalla
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color(0xFF282E53),
                    Color(0xF07784D1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(220, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.05),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: "Heiti TC",
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                _formUser(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _formPassword(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _buttonLogin(screenWidth),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Image.asset(
                    'assets/logo con texto.png',
                    width: screenWidth * 0.5, // Aumentado para mejor visibilidad
                  ),
                ],
              ),
            ),
            Positioned(
              top: 33,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Principal()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUser() {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black));
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          focusNode: _focusNodeUser,
          controller: textUsuario,
          decoration: InputDecoration(
              labelText: 'Propietario',
              hintText: 'Nombre completo(propietario de UE)',
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.person_outline_outlined),
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder),
          onEditingComplete: () => _focusNodePassword.requestFocus(),
        );
      },
      stream: null,
    );
  }

  Widget _formPassword() {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black),
    );
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          controller: textRFC,
          obscureText: _obscurePassword,
          focusNode: _focusNodePassword,
          decoration: InputDecoration(
            labelText: 'RFC',
            hintText: 'Escribe el RFC de la UE',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: _obscurePassword
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            ),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        );
      },
      stream: null,
    );
  }

  Widget _buttonLogin(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 15), // Espacio de 20 píxeles debajo del botón
      child: SizedBox(
        width: screenWidth * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (textUsuario.text.isEmpty) {
              FocusScope.of(context).requestFocus(_focusNodeUser);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('El campo propietario no puede estar vacío'),
              ));
            } else if (textRFC.text.isEmpty) {
              FocusScope.of(context).requestFocus(_focusNodePassword);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('El campo RFC no puede estar vacío'),
              ));
            } else if (textUsuario.text.isNotEmpty && textRFC.text.isNotEmpty) {
              validarUsuarioRFC(textUsuario.text, textRFC.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 166, 58),
            elevation: 100,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Ingresar',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          ),
        ),
      ),
    );
  }

  void validarUsuarioRFC(String usuario, String rfc) async {
    try {
      final response = await Dio().get(
          'https://appgobierno-c3e76-default-rtdb.firebaseio.com/Usuarios.json');

      if (response.statusCode == 200) {
        bool encontrado = false;

        for (var element in response.data) {
          //Imprime en consola los datos de la base de datos
          //print("Nombre: "+element['NombrePropietario'] + " RFC: " + element['RFC']);
          if (element['NombrePropietario'] == usuario.trim() &&
              element['RFC'] == rfc.trim()) {
            encontrado = true;
            break;
          }
        }

        if (encontrado) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return RegisterSearchDelegate(
                textUsuario: textUsuario.text,
                textRFC: textRFC.text,
              );
            }),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black38,
              duration: const Duration(seconds: 4),
              content: ListTile(
                leading: Icon(
                  Icons.warning_amber,
                  color: Colors.amber.shade400,
                ),
                title: const Text(
                  'Datos Incorrectos',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: const Text(
                  'Revisar nombre del propietario sin acento\nAsegurarse que el RFC sea correcto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
      } else {
        Exception();
      }
    } catch (e) {
      print(Exception(e));
    }
  }
}*/
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Screens/home/principal.dart';
import '../delegates/registrar_delegate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeUser = FocusNode();
  bool _obscurePassword = true;
  bool botonExit = true;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  final TextEditingController textUsuario = TextEditingController();
  final TextEditingController textRFC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        botonExit
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Principal();
                }),
              )
            : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: screenHeight, // Degradado cubre toda la pantalla
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Color(0xFF282E53),
                        Color(0xF07784D1),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.15,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(220, 255, 255, 255),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: screenWidth * 0.05),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: "Heiti TC",
                                        fontSize: 40,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    _formUser(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _formPassword(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    _buttonLogin(screenWidth),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Image.asset(
                        'assets/logo con texto.png',
                        width: screenWidth * 0.5, // Aumentado para mejor visibilidad
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 33,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Principal()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUser() {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black));
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          focusNode: _focusNodeUser,
          controller: textUsuario,
          decoration: InputDecoration(
              labelText: 'Propietario',
              hintText: 'Nombre completo(propietario de UE)',
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.person_outline_outlined),
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder),
          onEditingComplete: () => _focusNodePassword.requestFocus(),
        );
      },
      stream: null,
    );
  }

  Widget _formPassword() {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black),
    );
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          controller: textRFC,
          obscureText: _obscurePassword,
          focusNode: _focusNodePassword,
          decoration: InputDecoration(
            labelText: 'RFC',
            hintText: 'Escribe el RFC de la UE',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: _obscurePassword
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            ),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        );
      },
      stream: null,
    );
  }

  Widget _buttonLogin(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 15), // Espacio de 20 píxeles debajo del botón
      child: SizedBox(
        width: screenWidth * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (textUsuario.text.isEmpty) {
              FocusScope.of(context).requestFocus(_focusNodeUser);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('El campo propietario no puede estar vacío'),
              ));
            } else if (textRFC.text.isEmpty) {
              FocusScope.of(context).requestFocus(_focusNodePassword);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('El campo RFC no puede estar vacío'),
              ));
            } else if (textUsuario.text.isNotEmpty && textRFC.text.isNotEmpty) {
              validarUsuarioRFC(textUsuario.text, textRFC.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 166, 58),
            elevation: 100,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Ingresar',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          ),
        ),
      ),
    );
  }

  void validarUsuarioRFC(String usuario, String rfc) async {
    try {
      final response = await Dio().get(
          'https://appgobierno-c3e76-default-rtdb.firebaseio.com/Usuarios.json');

      if (response.statusCode == 200) {
        bool encontrado = false;

        for (var element in response.data) {
          //Imprime en consola los datos de la base de datos
          //print("Nombre: "+element['NombrePropietario'] + " RFC: " + element['RFC']);
          if (element['NombrePropietario'] == usuario.trim() &&
              element['RFC'] == rfc.trim()) {
            encontrado = true;
            break;
          }
        }

        if (encontrado) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return RegisterSearchDelegate(
                textUsuario: textUsuario.text,
                textRFC: textRFC.text,
              );
            }),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black38,
              duration: const Duration(seconds: 4),
              content: ListTile(
                leading: Icon(
                  Icons.warning_amber,
                  color: Colors.amber.shade400,
                ),
                title: const Text(
                  'Datos Incorrectos',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: const Text(
                  'Revisar nombre del propietario sin acento\nAsegurarse que el RFC sea correcto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
      } else {
        Exception();
      }
    } catch (e) {
      print(Exception(e));
    }
  }
}