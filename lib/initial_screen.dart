import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:llmm/app/router/app_routes.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(AppRoutes.products);
          },
          child: Text("Product"),
        ),
      ),
    );
  }
}
