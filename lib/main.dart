
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ocr_scanner/screen/camera_screen.dart';
import 'package:ocr_scanner/screen/file_screen.dart';
import 'package:ocr_scanner/screen/result_screen.dart';
import 'package:file_picker/file_picker.dart';




void main() {
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}


class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
  State<MainScreen> createState() => _MainScreenState();
  

}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{

  final _textRecognizer = TextRecognizer(); 

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Builder(builder: (context) {
      return Row(
        children: [
          ElevatedButton(onPressed: () => OpenCam(), child: const Text("Camera"),),
          ElevatedButton(onPressed: () => _ImageScanner(), child: const Text("Image"),),
          ElevatedButton(onPressed: () => _PDFScanner(), child: const Text("PDF"),),
          ElevatedButton(onPressed: () => OpenFile(), child: const Text("File"),),
        ],
      );
    });
  }

  Future<void> _PDFScanner() async{

    final navigator = Navigator.of(context);

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      );

      final file = File(result!.files.single.path!);
      
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text),
        ),
      );

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred when scanning text"),
        ),
      );
    }

  }

  Future<void> _ImageScanner() async{

    final navigator = Navigator.of(context);

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      );

      final file = File(result!.files.single.path!);
      
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text),
        ),
      );

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred when scanning text"),
        ),
      );
    }

  }

  void OpenCam(){
    final navigator = Navigator.of(context);

    navigator.push(
        MaterialPageRoute(builder: (context) => const CameraScreen(),
        ),
      );
  }
  void OpenFile() {
    final navigator = Navigator.of(context);

    navigator.push(
        MaterialPageRoute(builder: (context) => const FileScreen(),
        ),
      );
  }

}





