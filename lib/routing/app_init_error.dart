import 'package:flutter/material.dart';

class AppInitError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Error while loading app"),
      ),
    );
  }
}
