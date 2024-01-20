import 'package:flutter/material.dart';

class DetailNoteWidget extends StatelessWidget {
  const DetailNoteWidget({
    super.key,
    required this.label,
    required this.isTitle,
  });

  final String label;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(1, 1),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      padding: const EdgeInsets.all(10),
      child: Text(
        label,
        style: (isTitle)
            ? const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )
            : const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
      ),
    );
  }
}
