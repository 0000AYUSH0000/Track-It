import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  const CardBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 180,
        width: 160,
        child: Card(

          elevation: 7,
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                text,
                style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
