import 'package:flutter/material.dart';

class BuildMovieDesc extends StatelessWidget {
  const BuildMovieDesc({super.key, required this.desc});

  final String desc;

  @override
  Widget build(BuildContext context) {
    return Text(
      desc,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white70),
    );
  }
}
