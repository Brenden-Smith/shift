import 'package:flutter/material.dart';
import 'package:shift/layout.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text("Team"));
  }
}
