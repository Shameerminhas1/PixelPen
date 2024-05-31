import 'package:flutter/material.dart';
import 'dart:io';

class ImagePanel extends StatelessWidget {
  final String imagePath;
  final List<String>? imagePaths;

  ImagePanel({required this.imagePath, this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 165, 225, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 214, 255),
        title: Text('Image Preview'),
      ),
      body: Center(
        child: imagePaths != null && imagePaths!.isNotEmpty
            ? ListView.builder(
                itemCount: imagePaths!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.file(
                      File(imagePaths![index]),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
