import 'package:flutter/material.dart';

void main() => runApp(const Balancea());

class Balancea extends StatelessWidget {
  const Balancea({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balancea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF191A22)),
      home: Scaffold(
        body: const Center(
          child: Text(
            'Balancea Setup OK',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
