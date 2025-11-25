import 'package:flutter/material.dart';
import '../widgets/home/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // zona fija
            HomeHeader(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BalanceCard(),
            ),
            SizedBox(height: 30),
            HomeQuickActions(),
            SizedBox(height: 30),

            // zona movil
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1F222E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const HomeTransactions(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
