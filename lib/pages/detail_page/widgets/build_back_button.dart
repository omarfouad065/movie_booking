import 'package:flutter/material.dart';

class BuildBackButton extends StatelessWidget {
  const BuildBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }
}
