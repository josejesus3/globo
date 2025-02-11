import 'package:flutter/material.dart';
import 'package:globo/Screens/home/favoritos.dart';
import 'package:globo/Screens/home/principal.dart';

class CostomBottonNavigatorBar extends StatelessWidget {
  final int currentIndex;
  const CostomBottonNavigatorBar({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Principal(),
            ));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Favoritos(),
            ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (value) => onItemTapped(context, value),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoritos')
        ]);
  }
}
