import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:pixelpen/Textscreen.dart';

class ImagePanel extends StatefulWidget {
  final String imagePath;
  final List<String>? imagePaths;

  ImagePanel({required this.imagePath, this.imagePaths});

  @override
  _ImagePanelState createState() => _ImagePanelState();
}

class _ImagePanelState extends State<ImagePanel> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> deleteImage(BuildContext context, int index) async {
    try {
      if (widget.imagePaths != null && widget.imagePaths!.isNotEmpty) {
        File file = File(widget.imagePaths![index]);
        if (await file.exists()) {
          await file.delete();
        }
        setState(() {
          widget.imagePaths!.removeAt(index);
        });
        if (widget.imagePaths!.isEmpty) {
          Navigator.pop(context, true); // Return true if all images are deleted
        }
      } else {
        bool confirmDelete = await _showDeleteConfirmationDialog(context);
        if (confirmDelete) {
          File file = File(widget.imagePath);
          if (await file.exists()) {
            await file.delete();
          }

          Navigator.pop(
              context, true); // Return true to indicate an image was deleted
        }
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to delete this image?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Future<String> _performOCR(String imagePath) async {
    String url =
        'https://app.nanonets.com/api/v2/OCR/Model/5d46b5da-c4bb-4469-a10d-3f18d7a1b19c/LabelFile/';
    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Basic ' +
                base64Encode(
                    utf8.encode('8989dc74-34c3-11ef-8a36-f2643cf90fba:')),
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        if (jsonResponse['result'] != null &&
            jsonResponse['result'].isNotEmpty) {
          if (jsonResponse['result'][0]['prediction'] != null &&
              jsonResponse['result'][0]['prediction'].isNotEmpty) {
            return jsonResponse['result'][0]['prediction'][0]['ocr_text'] ?? '';
          } else {
            throw Exception('No text found in the image.');
          }
        } else {
          throw Exception('No result found in the OCR response.');
        }
      } else {
        throw Exception(
            'OCR request failed with status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error performing OCR: $e');
    }
  }

  Widget singleImageView(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => deleteImage(context, 0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo,
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget batchImageView(BuildContext context) {
    return ListView.builder(
      itemCount: widget.imagePaths!.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Image.file(
                    File(widget.imagePaths![index]),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => deleteImage(context, index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade700,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Image Tray',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade200,
                  Colors.blue.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : (widget.imagePaths != null && widget.imagePaths!.isNotEmpty
                    ? batchImageView(context)
                    : singleImageView(context)),
          ),
          if (_errorMessage != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 255),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      try {
                        String extractedText =
                            await _performOCR(widget.imagePath);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Textscreen(
                              initialFileContent: extractedText,
                            ),
                          ),
                        );
                      } catch (e) {
                        setState(() {
                          _errorMessage = e.toString();
                        });
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Convert',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                            width:
                                7), // Add some space between the text and the icon
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16, // Adjust the size of the icon as needed
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
