// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class ReadAloud extends StatefulWidget {
//   @override
//   _ReadAloudState createState() => _ReadAloudState();
// }

// class _ReadAloudState extends State<ReadAloud> {
//   final TextEditingController _textController = TextEditingController();
//   FlutterTts _flutterTts = FlutterTts();
//   String _selectedLanguage = 'en-US';

//   final Map<String, String> _languageOptions = {
//     'English': 'en-US',
//     'Spanish': 'es-ES',
//     'Urdu': 'ur-IN',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _flutterTts.setLanguage(_selectedLanguage);
//   }

//   Future<void> _speak() async {
//     if (_textController.text.isNotEmpty) {
//       await _flutterTts.setLanguage(_selectedLanguage);
//       await _flutterTts.speak(_textController.text);
//     }
//   }

//   @override
//   void dispose() {
//     _flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Read Aloud'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter text to read aloud',
//               ),
//             ),
//             SizedBox(height: 16),
//             DropdownButton<String>(
//               value: _selectedLanguage,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedLanguage = newValue!;
//                   _flutterTts.setLanguage(_selectedLanguage);
//                 });
//               },
//               items: _languageOptions.entries.map((entry) {
//                 return DropdownMenuItem<String>(
//                   value: entry.value,
//                   child: Text(entry.key),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _speak,
//               child: Icon(
//                 Icons.volume_up_rounded,
//                 size: 50,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// above code is language drop down

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ReadAloud extends StatefulWidget {
  @override
  _ReadAloudState createState() => _ReadAloudState();
}

class _ReadAloudState extends State<ReadAloud> {
  final TextEditingController _textController = TextEditingController();
  FlutterTts _flutterTts = FlutterTts();
  String? _detectedLanguage;
  final translator = GoogleTranslator();

  final Map<String, String> _languageCodes = {
    'en': 'en-US',
    'es': 'es-ES',
    'ur': 'ur-IN',
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _detectLanguageAndSpeak() async {
    if (_textController.text.isNotEmpty) {
      final detectedLang = await _detectLanguage(_textController.text);
      _detectedLanguage = _languageCodes[detectedLang] ?? 'en-US';

      await _flutterTts.setLanguage(_detectedLanguage!);
      await _flutterTts.speak(_textController.text);
    }
  }

  Future<String> _detectLanguage(String text) async {
    final translation = await translator.translate(text);
    return translation.sourceLanguage.code;
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Read Aloud',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Welcome back !',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
              TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: _textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  //labelText: 'Enter text to read aloud',
                ),
                maxLines: null, // Allows multiple lines
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      backgroundColor: Colors.black),
                  onPressed: _detectLanguageAndSpeak,
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
