import 'package:flutter/material.dart';

class BuildMoviePoster extends StatelessWidget {
  const BuildMoviePoster({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath, // Change this to your image path
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
