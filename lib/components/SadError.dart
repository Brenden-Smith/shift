import 'package:flutter/material.dart';

class SadError extends StatelessWidget {
  const SadError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Spacer(flex: 1),
      Center(
        child: Icon(
          Icons.sentiment_very_dissatisfied,
          size: 50,
        ),
      ),
      Center(child: Text('Oops!')),
      Center(child: Text('Something went wrong')),
      Spacer(flex: 1)
    ]);
  }
}
