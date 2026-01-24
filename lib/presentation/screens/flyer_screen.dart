import 'package:flutter/material.dart';

class FlyerScreen extends StatelessWidget {
  const FlyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flyer')),
      body: const Center(child: Text('Flyer Screen')),
    );
  }
}
