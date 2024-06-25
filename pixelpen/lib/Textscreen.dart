// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pixelpen/Chat_screen.dart';
// import 'package:pixelpen/Readaloud.dart';
// import 'package:pixelpen/translate.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Textscreen extends StatefulWidget {
//   @override
//   _TextscreenState createState() => _TextscreenState();
// }

// class _TextscreenState extends State<Textscreen> {
//   TextEditingController _controller = TextEditingController();
//   FlutterTts flutterTts = FlutterTts();
//   File? savedFile;

//   void _saveAsPdf(String text) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text(text),
//         ),
//       ),
//     );

//     final output = await getExternalStorageDirectory();
//     final file = File("${output!.path}/pixelpdf.pdf");
//     await file.writeAsBytes(await pdf.save());

//     setState(() {
//       savedFile = file;
//     });

//     _shareFile(file);
//     _showSnackBar('PDF file saved successfully');
//   }

//   void _saveAsDoc(String text) async {
//     final output = await getExternalStorageDirectory();
//     final file = File("${output!.path}/pixeldoc.doc");
//     await file.writeAsString(text);

//     setState(() {
//       savedFile = file;
//     });

//     _shareFile(file);
//     _showSnackBar('DOC file saved successfully');
//   }

//   void _shareFile(File file) async {
//     final box = context.findRenderObject() as RenderBox?;
//     final shareResult = await Share.shareXFiles(
//       [XFile(file.path)],
//       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.blue.shade500,
//         behavior: SnackBarBehavior.floating,
//         content: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 shareResult.status == ShareResultStatus.success
//                     ? Icons.check_circle_outline
//                     : Icons.error_outline,
//                 color: shareResult.status == ShareResultStatus.success
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               SizedBox(width: 12.0),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       shareResult.status == ShareResultStatus.success
//                           ? 'Shared successfully!'
//                           : 'Share failed!',
//                       style: TextStyle(
//                         color: shareResult.status == ShareResultStatus.success
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     if (shareResult.status == ShareResultStatus.success)
//                       Text(
//                         'Shared to: ${shareResult.raw}',
//                         style: TextStyle(fontSize: 14.0),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         action: SnackBarAction(
//           label: 'Close',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _shareToWhatsApp(String text) async {
//     final url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       print('Error launching WhatsApp: $e');
//     }
//   }

//   void _readAloud(String text) async {
//     await flutterTts.speak(text);
//   }

//   void _navigateToTranslateScreen(String text) {
//     Navigator.pushNamed(context, 'translate', arguments: text);
//   }

//   void _navigateToChatAiScreen(String text) {
//     Navigator.pushNamed(context, 'chat_Screen', arguments: text);
//   }

//   void _showSaveDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Save As'),
//           content: Text('Choose a format to save your document:'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('PDF'),
//               onPressed: () {
//                 _saveAsPdf(_controller.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('DOC'),
//               onPressed: () {
//                 _saveAsDoc(_controller.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(fontSize: 16.0),
//         ),
//         backgroundColor: Colors.blue.shade900,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text Editor'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _showSaveDialog,
//           ),
//           IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () {
//               _controller.clear();
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.blue.shade200,
//               Colors.blue.shade700,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   elevation: 8.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _controller,
//                       maxLines: null,
//                       expands: true,
//                       textAlignVertical: TextAlignVertical.top,
//                       style: TextStyle(fontSize: 16.0),
//                       decoration: InputDecoration(
//                         hintText: 'Enter your text here',
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.all(12.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon: Icon(Icons.volume_up),
//               tooltip: 'Read Aloud',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ReadAloud(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.chat),
//               tooltip: 'Chat AI',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ChatScreen(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.translate),
//               tooltip: 'Translate',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         TranslateScreen(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.share),
//               tooltip: 'Share',
//               onPressed: savedFile != null
//                   ? () => _shareFile(savedFile!)
//                   : () => _shareToWhatsApp(_controller.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pixelpen/Chat_screen.dart';
// import 'package:pixelpen/Readaloud.dart';
// import 'package:pixelpen/translate.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Textscreen extends StatefulWidget {

//   @override
//   _TextscreenState createState() => _TextscreenState();
// }

// class _TextscreenState extends State<Textscreen> {

//   TextEditingController _controller = TextEditingController();
//   TextEditingController _fileNameController = TextEditingController();
//   FlutterTts flutterTts = FlutterTts();
//   File? savedFile;

//   void _saveAsPdf(String text, String fileName) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text(text),
//         ),
//       ),
//     );

//     final output = await getExternalStorageDirectory();
//     final file = File("${output!.path}/$fileName.pdf");
//     await file.writeAsBytes(await pdf.save());

//     setState(() {
//       savedFile = file;
//     });

//     //_shareFile(file);
//     _showSnackBar('PDF file saved successfully');
//   }

//   void _saveAsDoc(String text, String fileName) async {
//     final output = await getExternalStorageDirectory();
//     final file = File("${output!.path}/$fileName.doc");
//     await file.writeAsString(text);

//     setState(() {
//       savedFile = file;
//     });

//     // _shareFile(file);
//     _showSnackBar('DOC file saved successfully');
//   }

//   void _shareFile(File file) async {
//     final box = context.findRenderObject() as RenderBox?;
//     final shareResult = await Share.shareXFiles(
//       [XFile(file.path)],
//       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.blue.shade500,
//         behavior: SnackBarBehavior.floating,
//         content: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 shareResult.status == ShareResultStatus.success
//                     ? Icons.check_circle_outline
//                     : Icons.error_outline,
//                 color: shareResult.status == ShareResultStatus.success
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               SizedBox(width: 12.0),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       shareResult.status == ShareResultStatus.success
//                           ? 'Shared successfully!'
//                           : 'Share failed!',
//                       style: TextStyle(
//                         color: shareResult.status == ShareResultStatus.success
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     if (shareResult.status == ShareResultStatus.success)
//                       Text(
//                         'Shared to: ${shareResult.raw}',
//                         style: TextStyle(fontSize: 14.0),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         action: SnackBarAction(
//           label: 'Close',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _shareToWhatsApp(String text) async {
//     final url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       print('Error launching WhatsApp: $e');
//     }
//   }

//   void _readAloud(String text) async {
//     await flutterTts.speak(text);
//   }

//   void _navigateToTranslateScreen(String text) {
//     Navigator.pushNamed(context, 'translate', arguments: text);
//   }

//   void _navigateToChatAiScreen(String text) {
//     Navigator.pushNamed(context, 'chat_Screen', arguments: text);
//   }

//   void _showSaveDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Save As'),
//           content: Text('Choose a format to save your document:'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('PDF'),
//               onPressed: () {
//                 _saveAsPdf(_controller.text, _fileNameController.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('DOC'),
//               onPressed: () {
//                 _saveAsDoc(_controller.text, _fileNameController.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(fontSize: 16.0),
//         ),
//         backgroundColor: Colors.blue.shade900,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text Editor'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _showSaveDialog,
//           ),
//           IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () {
//               _controller.clear();
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.blue.shade200,
//               Colors.blue.shade700,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _fileNameController,
//                 decoration: InputDecoration(
//                   fillColor: Colors.white70,
//                   filled: true,
//                   hintText: 'Enter file name',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(80.0)),
//                   contentPadding: EdgeInsets.all(12.0),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   elevation: 8.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _controller,
//                       maxLines: null,
//                       expands: true,
//                       textAlignVertical: TextAlignVertical.top,
//                       style: TextStyle(fontSize: 16.0),
//                       decoration: InputDecoration(
//                         hintText: 'Enter your text here',
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.all(12.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon: Icon(Icons.volume_up),
//               tooltip: 'Read Aloud',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ReadAloud(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.chat),
//               tooltip: 'Chat AI',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ChatScreen(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.translate),
//               tooltip: 'Translate',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         TranslateScreen(initialText: _controller.text),
//                   ),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.share),
//               tooltip: 'Share',
//               onPressed: savedFile != null
//                   ? () => _shareFile(savedFile!)
//                   : () => _shareToWhatsApp(_controller.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//-----------------

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pixelpen/Chat_screen.dart';
import 'package:pixelpen/Readaloud.dart';
import 'package:pixelpen/translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Textscreen extends StatefulWidget {
  final String? initialFileName;
  final String? initialFileContent;

  Textscreen({this.initialFileName, this.initialFileContent});

  @override
  _TextscreenState createState() => _TextscreenState();
}

class _TextscreenState extends State<Textscreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _fileNameController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  File? savedFile;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialFileContent ?? '';
    _fileNameController.text = widget.initialFileName ?? '';
  }

  void _saveAsPdf(String text, String fileName) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(text),
        ),
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      savedFile = file;
    });

    //_shareFile(file);
    _showSnackBar('PDF file saved successfully');
  }

  void _saveAsDoc(String text, String fileName) async {
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/$fileName.doc");
    await file.writeAsString(text);

    setState(() {
      savedFile = file;
    });

    // _shareFile(file);
    _showSnackBar('DOC file saved successfully');
  }

  void _shareFile(File file) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareResult = await Share.shareXFiles(
      [XFile(file.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue.shade500,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                shareResult.status == ShareResultStatus.success
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: shareResult.status == ShareResultStatus.success
                    ? Colors.green
                    : Colors.red,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shareResult.status == ShareResultStatus.success
                          ? 'Shared successfully!'
                          : 'Share failed!',
                      style: TextStyle(
                        color: shareResult.status == ShareResultStatus.success
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    if (shareResult.status == ShareResultStatus.success)
                      Text(
                        'Shared to: ${shareResult.raw}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _shareToWhatsApp(String text) async {
    final url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  void _readAloud(String text) async {
    await flutterTts.speak(text);
  }

  void _navigateToTranslateScreen(String text) {
    Navigator.pushNamed(context, 'translate', arguments: text);
  }

  void _navigateToChatAiScreen(String text) {
    Navigator.pushNamed(context, 'chat_Screen', arguments: text);
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save As'),
          content: Text('Choose a format to save your document:'),
          actions: <Widget>[
            TextButton(
              child: Text('PDF'),
              onPressed: () {
                _saveAsPdf(_controller.text, _fileNameController.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('DOC'),
              onPressed: () {
                _saveAsDoc(_controller.text, _fileNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Colors.blue.shade900,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _showSaveDialog,
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade700,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextField(
                    controller: _fileNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Enter file name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintText: 'Enter your text here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.volume_up),
              tooltip: 'Read Aloud',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadAloud(initialText: _controller.text),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat),
              tooltip: 'Chat AI',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(initialText: _controller.text),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.translate),
              tooltip: 'Translate',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TranslateScreen(initialText: _controller.text),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              tooltip: 'Share',
              onPressed: savedFile != null
                  ? () => _shareFile(savedFile!)
                  : () => _shareToWhatsApp(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
