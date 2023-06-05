import 'dart:io';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "BIGGER OCR"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker imagePicker = ImagePicker();
  File? ocrImage;
  String text = "";
  //pick image
  pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        ocrImage = File(file.path);
      });
    }
  }

  //initialize tesseract ocr
  ocrProcess() async {
    //args support android / Web , i don't have a mac
    String? ocrText = await FlutterTesseractOcr.extractText(ocrImage!.path,
        language: 'lao+eng',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });
    setState(() {
      text = ocrText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(children: [
            InkWell(
              onTap: pickImage,
              child: Container(
                  height: mediaSize.height * .5,
                  width: mediaSize.width * 0.9,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: ocrImage != null
                      ? Image.file(File(ocrImage!.path), fit: BoxFit.fill)
                      : const Center(
                          child: Text("Choose the Image",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)))),
            ),
            ElevatedButton(onPressed: ocrProcess, child: const Text("Process")),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(text))
          ]),
        )));
  }
}
