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

///

// import 'package:flutter/material.dart';
// import 'dart:io';

// class ImagePanel extends StatelessWidget {
//   final String imagePath;
//   final List<String>? imagePaths;

//   ImagePanel({required this.imagePath, this.imagePaths});

//   Future<void> deleteImage(BuildContext context, int index) async {
//     try {
//       if (imagePaths != null && imagePaths!.isNotEmpty) {
//         File file = File(imagePaths![index]);
//         if (await file.exists()) {
//           await file.delete();
//         }
//         imagePaths!.removeAt(index);
//       } else {
//         File file = File(imagePath);
//         if (await file.exists()) {
//           await file.delete();
//         }

//         Navigator.pop(
//             context, true); // Return true to indicate an image was deleted
//       }
//       if (imagePaths != null && imagePaths!.isEmpty) {
//         Navigator.pop(
//             context, true); // Return true to indicate all images were deleted
//       }
//     } catch (e) {
//       print('Error deleting image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 165, 225, 255),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 125, 214, 255),
//         title: Text('Image Preview'),
//       ),
//       body: Center(
//         child: imagePaths != null && imagePaths!.isNotEmpty
//             ? ListView.builder(
//                 itemCount: imagePaths!.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       children: [
//                         Image.file(
//                           File(imagePaths![index]),
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         ElevatedButton(
//                           onPressed: () => deleteImage(context, index),
//                           child: Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       Image.file(
//                         File(imagePath),
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       ElevatedButton(
//                         onPressed: () => deleteImage(context, 0),
//                         child: Text('Delete'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
