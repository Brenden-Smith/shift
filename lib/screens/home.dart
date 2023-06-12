import 'package:flutter/material.dart';
import 'package:shift/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text("Hello!"));
  }
}
