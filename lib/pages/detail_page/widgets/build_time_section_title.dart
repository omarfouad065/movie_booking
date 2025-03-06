import 'package:flutter/material.dart';

class BuildTimeSectionTitle extends StatelessWidget {
  const BuildTimeSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
