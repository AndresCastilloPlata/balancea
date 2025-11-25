import 'package:balancea/presentation/widgets/home/home_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(),
            SizedBox(height: 20),
            Text(
              "Aquí irá la tarjeta de saldo",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
