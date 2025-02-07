
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'principal.dart';

class FondoPantalla extends StatefulWidget {
  const FondoPantalla({super.key});

  @override
  State<FondoPantalla> createState() => _FondoPantallaState();
}

class _FondoPantallaState extends State<FondoPantalla> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const Principal(),
        ),(Route<dynamic> route)=> false
      ),
    );
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF282E53),
              Color(0xF07784D1),
            ],
          ),
        ),
        child: Center(child: _buildPortraitContent()),
      ),
    );
  }

  Widget _buildPortraitContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset('assets/logo con texto.png'),
        const Spacer(),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Heiti TC",
              fontSize: 35,
              fontWeight: FontWeight.w200,
            ),
            children: [
              //TextSpan(text: '¡Tan fácil de\n  encontrar!'),
            ],
          ),
        ),
        const SizedBox(height: 35),
        const Spacer(),
        //Expanded(child: Image.asset('assets/piePagina.png')),
      ],
    );
  }
}
