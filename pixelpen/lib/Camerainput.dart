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
                                color:
                                    !isBatchMode ? Colors.green : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        //btch pic mode
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
                //gal on dele
                // Positioned(
                //   bottom: 35,
                //   right: 20,
                //   child: GestureDetector(
                //     onTap: () async {
                //       bool? result;
                //       if (isBatchMode && batchImages.isNotEmpty) {
                //         result = await Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => ImagePanel(
                //                 imagePath: batchImages.last,
                //                 imagePaths: batchImages),
                //           ),
                //         );
                //       } else if (lastImagePath != null) {
                //         result = await Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 ImagePanel(imagePath: lastImagePath!),
                //           ),
                //         );
                //       }

                //       if (result == true) {
                //         setState(() {});
                //       }
                //     },
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
                          image: (isBatchMode &&
                                  batchImages.isNotEmpty &&
                                  batchImages.last.isNotEmpty)
                              ? DecorationImage(
                                  image: FileImage(File(batchImages.last)),
                                  fit: BoxFit.cover,
                                )
                              : lastImagePath != null
                                  ? DecorationImage(
                                      image: FileImage(File(lastImagePath!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
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
