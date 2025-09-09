import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleTestApp());
}

class SimpleTestApp extends StatelessWidget {
  const SimpleTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Test App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Windows Test'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello Flutter on Windows!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 20),
              Text('App is running successfully'),
            ],
          ),
        ),
      ),
    );
  }
}