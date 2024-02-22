import 'package:flutter/material.dart';
class ResultScreen extends StatelessWidget{
  final String text;
  late TextEditingController controller = TextEditingController(text:text);

   ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Result'),
    ),
    body: Container(
      padding: const EdgeInsets.all(30.0),
      child: TextField(
        obscureText: false,
        textAlign: TextAlign.left,
        controller: controller,
        maxLength: 200,
      ),
    ),

  );

}