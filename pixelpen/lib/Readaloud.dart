import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ReadAloud extends StatefulWidget {
  final String initialText;

  ReadAloud({this.initialText = ''});

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
    _textController.text =
        widget.initialText; // Initialize text controller with initial text
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Read Aloud',
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
                colors: [Colors.blue.shade200, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter text to read aloud',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      maxLines: null, // Allows multiple lines
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      backgroundColor: Colors.white,
                      elevation: 5,
                    ),
                    onPressed: _detectLanguageAndSpeak,
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 45,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
