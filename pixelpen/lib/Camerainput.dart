import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:pixelpen/Imagepanel.dart';

class CameraInput extends StatefulWidget {
  @override
  _CameraInputState createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  FlashMode currentFlashMode = FlashMode.off;
  String? lastImagePath; //--
  bool isBatchMode = false;
  List<String> batchImages = [];

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller!.initialize();
      if (mounted) {
        setState(() {
          isCameraInitialized = true;
        });
      }
    }
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized) {
      return;
    }

    // Check for camera permissions
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      print('Camera permission not granted');
      return;
    }

    try {
      XFile picture = await controller!.takePicture();

      // Get the directory to save the picture
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await picture.saveTo(path);
      print('picture successfully taken');
      print('Picture saved to $path');

      // Handle batch mode
      if (isBatchMode) {
        setState(() {
          batchImages.add(path);
        });
      } else {
        setState(() {
          lastImagePath = path;
        });
      }

      // Save the picture to the gallery
      final result = await Gal.putImage(path, album: 'Pixel Images');

      //print('Picture saved to gallery: $result',);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    try {
      FlashMode nextFlashMode;
      switch (currentFlashMode) {
        case FlashMode.off:
          nextFlashMode = FlashMode.torch;
          break;
        case FlashMode.torch:
          nextFlashMode = FlashMode.off;
          break;
        default:
          nextFlashMode = FlashMode.off;
          break;
      }

      await controller!.setFlashMode(nextFlashMode);
      setState(() {
        currentFlashMode = nextFlashMode;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isCameraInitialized
          ? Stack(
              children: [
                // Camera preview
                Center(
                    child: Container(
                  height: 875,
                  width: 450,
                  child: CameraPreview(controller!),
                )),
                // Mode selector
                Positioned(
                  bottom: 110,
                  left: 115,
                  right: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //single pic mode
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBatchMode = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 16),
                            decoration: BoxDecoration(
                              color: !isBatchMode
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Single',
                              style: TextStyle(
                                color:
                                    !isBatchMode ? Colors.green : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        //btch pic mode
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBatchMode = true;
                              batchImages.clear();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isBatchMode
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Batch',
                              style: TextStyle(
                                color:
                                    isBatchMode ? Colors.green : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Camera icon
                Positioned(
                  bottom: 30,
                  left: 165,
                  child: IconButton(
                    icon: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.camera_alt,
                            size: 30, color: Colors.black)),
                    onPressed: takePicture,
                  ),
                ),

                //upgal
                // Gallery icon
                // Positioned(
                //   bottom: 35,
                //   right: 20,
                //   child: GestureDetector(
                //     onTap: () {
                //       if (isBatchMode && batchImages.isNotEmpty) {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => ImagePanel(
                //                 imagePath: batchImages.last,
                //                 imagePaths: batchImages),
                //           ),
                //         );
                //       } else if (lastImagePath != null) {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 ImagePanel(imagePath: lastImagePath!),
                //           ),
                //         );
                //       } else {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 ImagePanel(imagePath: '', imagePaths: []),
                //           ),
                //         );
                //       }
                //     },
                //     child: Container(
                //       width: 60,
                //       height: 60,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         shape: BoxShape.circle,
                //         image: (isBatchMode && batchImages.isNotEmpty)
                //             ? DecorationImage(
                //                 image: FileImage(File(batchImages.last)),
                //                 fit: BoxFit.cover,
                //               )
                //             : lastImagePath != null
                //                 ? DecorationImage(
                //                     image: FileImage(File(lastImagePath!)),
                //                     fit: BoxFit.cover,
                //                   )
                //                 : null,
                //       ),
                //     ),
                //   ),
                // ),
                //upgal

                // //Gallery icon
                Positioned(
                  bottom: 35,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      if (isBatchMode && batchImages.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePanel(
                                imagePath: batchImages.last,
                                imagePaths: batchImages),
                          ),
                        );
                      } else if (lastImagePath != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImagePanel(imagePath: lastImagePath!),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: (isBatchMode && batchImages.isNotEmpty)
                            ? DecorationImage(
                                image: FileImage(File(batchImages.last)),
                                fit: BoxFit.cover,
                              )
                            : lastImagePath != null
                                ? DecorationImage(
                                    image: FileImage(File(lastImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                    ),
                  ),
                ),
                // Flash
                Positioned(
                  top: 20,
                  right: -3,
                  child: IconButton(
                    icon: Container(
                        height: 60,
                        width: 60,
                        child: Icon(
                          currentFlashMode == FlashMode.torch
                              ? Icons.flash_on
                              : Icons.flash_off,
                          size: 30,
                          color: Colors.white,
                        )),
                    onPressed: toggleFlash,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}










/////////////////////////////////////////////////////////////////////////////////////
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:gal/gal.dart';
// import 'package:pixelpen/Imagepanel.dart';

// class CameraInput extends StatefulWidget {
//   @override
//   _CameraInputState createState() => _CameraInputState();
// }

// class _CameraInputState extends State<CameraInput> {
//   CameraController? controller;
//   List<CameraDescription>? cameras;
//   bool isCameraInitialized = false;
//   FlashMode currentFlashMode = FlashMode.off;
//   String? lastImagePath;
//   bool isBatchMode = false;
//   List<String> batchImages = [];

//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }

//   Future<void> initCamera() async {
//     cameras = await availableCameras();
//     if (cameras != null && cameras!.isNotEmpty) {
//       controller = CameraController(cameras![0], ResolutionPreset.high);
//       await controller!.initialize();
//       if (mounted) {
//         setState(() {
//           isCameraInitialized = true;
//         });
//       }
//     }
//   }

//   Future<void> takePicture() async {
//     if (!controller!.value.isInitialized) {
//       return;
//     }

//     var status = await Permission.camera.request();
//     if (!status.isGranted) {
//       print('Camera permission not granted');
//       return;
//     }

//     try {
//       XFile picture = await controller!.takePicture();

//       final directory = await getApplicationDocumentsDirectory();
//       final path =
//           '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
//       await picture.saveTo(path);
//       print('picture successfully taken');
//       print('Picture saved to $path');

//       if (isBatchMode) {
//         setState(() {
//           batchImages.add(path);
//         });
//       } else {
//         setState(() {
//           lastImagePath = path;
//         });
//       }

//       final result = await Gal.putImage(path, album: 'Pixel Images');
//     } catch (e) {
//       print('Error taking picture: $e');
//     }
//   }

//   Future<void> toggleFlash() async {
//     if (controller == null || !controller!.value.isInitialized) {
//       return;
//     }

//     try {
//       FlashMode nextFlashMode;
//       switch (currentFlashMode) {
//         case FlashMode.off:
//           nextFlashMode = FlashMode.torch;
//           break;
//         case FlashMode.torch:
//           nextFlashMode = FlashMode.off;
//           break;
//         default:
//           nextFlashMode = FlashMode.off;
//           break;
//       }

//       await controller!.setFlashMode(nextFlashMode);
//       setState(() {
//         currentFlashMode = nextFlashMode;
//       });
//     } catch (e) {
//       print('Error toggling flash: $e');
//     }
//   }

//   void _deleteImage(String imagePath) {
//     setState(() {
//       if (isBatchMode) {
//         batchImages.remove(imagePath);
//         if (batchImages.isEmpty) {
//           lastImagePath = null;
//         } else {
//           lastImagePath = batchImages.last;
//         }
//       } else {
//         lastImagePath = null;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isCameraInitialized
//           ? Stack(
//               children: [
//                 Center(
//                   child: Container(
//                     height: 875,
//                     width: 450,
//                     child: CameraPreview(controller!),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 110,
//                   left: 115,
//                   right: 0,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isBatchMode = false;
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: 1,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                               color: !isBatchMode
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               'Single',
//                               style: TextStyle(
//                                 color:
//                                     !isBatchMode ? Colors.green : Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 25),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isBatchMode = true;
//                               batchImages.clear();
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: 1,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isBatchMode
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               'Batch',
//                               style: TextStyle(
//                                 color:
//                                     isBatchMode ? Colors.green : Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 30,
//                   left: 165,
//                   child: IconButton(
//                     icon: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: Colors.white,
//                       ),
//                       child: Icon(
//                         Icons.camera_alt,
//                         size: 30,
//                         color: Colors.black,
//                       ),
//                     ),
//                     onPressed: takePicture,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 35,
//                   right: 20,
//                   child: GestureDetector(
//                     onTap: () {
//                       if (isBatchMode && batchImages.isNotEmpty) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ImagePanel(
//                               imagePath: batchImages.last,
//                               imagePaths: batchImages,
//                               onDelete: _deleteImage,
//                             ),
//                           ),
//                         );
//                       } else if (lastImagePath != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ImagePanel(
//                               imagePath: lastImagePath!,
//                               imagePaths: [lastImagePath!],
//                               onDelete: _deleteImage,
//                             ),
//                           ),
//                         );
//                       } else {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ImagePanel(
//                               imagePath: '',
//                               imagePaths: [],
//                               onDelete: _deleteImage,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         image: (isBatchMode && batchImages.isNotEmpty)
//                             ? DecorationImage(
//                                 image: FileImage(File(batchImages.last)),
//                                 fit: BoxFit.cover,
//                               )
//                             : lastImagePath != null
//                                 ? DecorationImage(
//                                     image: FileImage(File(lastImagePath!)),
//                                     fit: BoxFit.cover,
//                                   )
//                                 : null,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   right: -3,
//                   child: IconButton(
//                     icon: Container(
//                       height: 60,
//                       width: 60,
//                       child: Icon(
//                         currentFlashMode == FlashMode.torch
//                             ? Icons.flash_on
//                             : Icons.flash_off,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                     onPressed: toggleFlash,
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
