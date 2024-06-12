import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:pixelpen/Imagepanel.dart';
import 'package:image_picker/image_picker.dart';

class CameraInput extends StatefulWidget {
  @override
  _CameraInputState createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  FlashMode currentFlashMode = FlashMode.off;
  String? lastImagePath;
  bool isBatchMode = false;
  List<String> batchImages = [];
  XFile? _pickedImage; //new

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
      print('Picture successfully taken');
      print('Picture saved to $path');

      if (isBatchMode) {
        setState(() {
          batchImages.add(path);
        });
      } else {
        setState(() {
          lastImagePath = path;
        });

        // Navigate to ImagePanel
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePanel(
              imagePath: path,
              imagePaths: null,
            ),
          ),
        );

        // Update gallery icon after coming back from ImagePanel
        if (result == true && isBatchMode) {
          setState(() {
            batchImages.clear();
          });
        }
      }

      // Save the picture to the gallery
      final result = await Gal.putImage(path, album: 'Pixel Images');
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

  Future<void> clearImages() async {
    try {
      if (isBatchMode) {
        for (String path in batchImages) {
          File file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
        batchImages.clear();
      } else {
        if (lastImagePath != null) {
          File file = File(lastImagePath!);
          if (await file.exists()) {
            await file.delete();
          }
          lastImagePath = null;
        }
      }
      setState(() {});
    } catch (e) {
      print('Error clearing images: $e');
    }
  }

//new
  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });

      // Navigate to ImagePanel
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePanel(
            imagePath: pickedFile.path,
            imagePaths: null,
          ),
        ),
      );

      // Update gallery icon after coming back from ImagePanel
      if (result == true && isBatchMode) {
        setState(() {
          batchImages.clear();
        });
      }
    }
  }

//new

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isCameraInitialized
          ? Stack(
              children: [
                // Camera preview
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 17,
                  ),
                  child: Center(
                      child: Container(
                    //height: 872,
                    //width: 394,
                    child: CameraPreview(controller!),
                  )),
                ),

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
                        // Single picture mode
                        GestureDetector(
                          onTap: () async {
                            await clearImages();
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
                                fontWeight: FontWeight.bold,
                                color:
                                    !isBatchMode ? Colors.green : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        // Batch picture mode
                        GestureDetector(
                          onTap: () async {
                            await clearImages();
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
                                fontWeight: FontWeight.bold,
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
                  bottom: 10,
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
// new
// Gallery icon (only shown in batch mode)
                if (isBatchMode)
                  Positioned(
                    bottom: 15,
                    right: 20,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (batchImages.isNotEmpty) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePanel(
                                      imagePath: batchImages.last,
                                      imagePaths: batchImages),
                                ),
                              );
                              // Update gallery icon after coming back from ImagePanel
                              if (result == true && batchImages.isEmpty) {
                                setState(() {});
                              }
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: batchImages.isNotEmpty
                                    ? DecorationImage(
                                        image:
                                            FileImage(File(batchImages.last)),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                          ),
                        ),
                        if (batchImages.isNotEmpty)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 17,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                '${batchImages.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                //
                // Gallery icon (only shown in batch mode)
                // if (isBatchMode)
                //   Positioned(
                //     bottom: 35,
                //     right: 20,
                //     child: GestureDetector(
                //       onTap: () async {
                //         if (batchImages.isNotEmpty) {
                //           final result = await Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ImagePanel(
                //                   imagePath: batchImages.last,
                //                   imagePaths: batchImages),
                //             ),
                //           );
                //           // Update gallery icon after coming back from ImagePanel
                //           if (result == true && batchImages.isEmpty) {
                //             setState(() {});
                //           }
                //         }
                //       },
                //       child: Container(
                //         width: 60,
                //         height: 60,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             shape: BoxShape.circle,
                //             image: batchImages.isNotEmpty
                //                 ? DecorationImage(
                //                     image: FileImage(File(batchImages.last)),
                //                     fit: BoxFit.cover,
                //                   )
                //                 : null),
                //       ),
                //     ),
                //   ),
                // Flash
                ///new
                Positioned(
                  bottom: 15,
                  left: 20,
                  child: IconButton(
                    iconSize: 45,
                    color: Colors.white,
                    icon: Icon(Icons.insert_photo),
                    onPressed: _getImageFromGallery,
                  ),
                ),
                //new
                Positioned(
                  top: 20,
                  right: -3,
                  child: IconButton(
                    icon: Container(
                        height: 60,
                        width: 60,
                        child: Icon(
                          currentFlashMode == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
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
