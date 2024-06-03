import 'package:flutter/material.dart';
import 'dart:io';

class ImagePanel extends StatefulWidget {
  final String imagePath;
  final List<String>? imagePaths;

  ImagePanel({required this.imagePath, this.imagePaths});

  @override
  _ImagePanelState createState() => _ImagePanelState();
}

class _ImagePanelState extends State<ImagePanel> {
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
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
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
                  height: 500, // Adjust the height as needed
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
      backgroundColor: Color.fromARGB(255, 165, 225, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 214, 255),
        title: Text('Image Preview'),
      ),
      body: Center(
        child: widget.imagePaths != null && widget.imagePaths!.isNotEmpty
            ? batchImageView(context)
            : singleImageView(context),
      ),
    );
  }
}
