// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

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
//     final file = File("${output!.path}/document.pdf");
//     await file.writeAsBytes(await pdf.save());

//     setState(() {
//       savedFile = file;
//     });

//     _shareFile(file);
//   }

//   void _saveAsDoc(String text) async {
//     final output = await getExternalStorageDirectory();
//     final file = File("${output!.path}/document.doc");
//     await file.writeAsString(text);

//     setState(() {
//       savedFile = file;
//     });

//     _shareFile(file);
//   }

//   void _shareFile(File file) async {
//     final box = context.findRenderObject() as RenderBox?;
//     final shareResult = await Share.shareXFiles(
//       [XFile(file.path)],
//       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Share result: ${shareResult.status}"),
//             if (shareResult.status == ShareResultStatus.success)
//               Text("Shared to: ${shareResult.raw}")
//           ],
//         ),
//       ),
//     );
//   }

//   void _readAloud(String text) async {
//     await flutterTts.speak(text);
//   }

//   void _translateText(String text) {
//     // Implement your translation logic here
//   }

//   void _chatAi(String text) {
//     // Implement your AI chat logic here
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
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 maxLines: null,
//                 expands: true,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your text here',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon: Icon(Icons.volume_up),
//               onPressed: () => _readAloud(_controller.text),
//             ),
//             IconButton(
//               icon: Icon(Icons.chat),
//               onPressed: () => _chatAi(_controller.text),
//             ),
//             IconButton(
//               icon: Icon(Icons.translate),
//               onPressed: () => _translateText(_controller.text),
//             ),
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed:
//                   savedFile != null ? () => _shareFile(savedFile!) : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//////--------------------------------------------------------------

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
  @override
  _TextscreenState createState() => _TextscreenState();
}

class _TextscreenState extends State<Textscreen> {
  TextEditingController _controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  File? savedFile;

  void _saveAsPdf(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(text),
        ),
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      savedFile = file;
    });

    _shareFile(file);
  }

  void _saveAsDoc(String text) async {
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/document.doc");
    await file.writeAsString(text);

    setState(() {
      savedFile = file;
    });

    _shareFile(file);
  }

  void _shareFile(File file) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareResult = await Share.shareXFiles(
      [XFile(file.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Share result: ${shareResult.status}"),
            if (shareResult.status == ShareResultStatus.success)
              Text("Shared to: ${shareResult.raw}")
          ],
        ),
      ),
    );
  }

  void _shareToWhatsApp(String text) async {
    final url = 'https://wa.me/?text=${Uri.encodeComponent(text)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
                _saveAsPdf(_controller.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('DOC'),
              onPressed: () {
                _saveAsDoc(_controller.text);
                Navigator.of(context).pop();
              },
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
        title: Text('Text Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _showSaveDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter your text here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReadAloud(initialText: _controller.text),
                    ),
                  );
                }),
            IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(initialText: _controller.text),
                    ),
                  );
                }),
            IconButton(
                icon: Icon(Icons.translate),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TranslateScreen(
                        initialText: _controller.text,
                      ),
                    ),
                  );
                }),
            IconButton(
              icon: Icon(Icons.share),
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
