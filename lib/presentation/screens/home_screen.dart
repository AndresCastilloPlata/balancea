import 'package:flutter/material.dart';
import '../widgets/home/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BalanceCard(),
              ),
              SizedBox(height: 30),
              HomeQuickActions(),
              SizedBox(height: 30),
              HomeTransactions(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
