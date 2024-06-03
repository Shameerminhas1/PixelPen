import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateScreen extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'es'; // Default language
  String _selectedUrduMessage = 'ur'; // Selected Urdu message
  String _translatedText = '';

  // Define the languages with user-friendly labels
  final Map<String, String> _languages = {
    'English': 'en',
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Urdu': 'ur',
    'Hindi': 'hi',
    'Persian': 'fa',
    'Arabic': 'ar',
  };

  // API URL
  final String apiUrl = 'https://translate-api-alpha.vercel.app/translate';

  // Function to handle translation
  Future<void> _translateText() async {
    final Map<String, String> requestData = {
      'content': _textController.text,
      'language': _selectedLanguage,
      'base_language': _selectedUrduMessage.isNotEmpty
          ? 'ur'
          : '', // Include base_language if Urdu message is selected
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _translatedText = responseData['data'];
        });
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _translatedText = 'Error: ${responseData['message']}';
        });
      }
    } catch (error) {
      setState(() {
        _translatedText = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Translate Menu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back !',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type or paste here to translate',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: null, // Allows multiple lines
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.grey[850],
                  value: _selectedUrduMessage,
                  items: _languages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(
                        entry.key,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUrduMessage = newValue!;
                    });
                  },
                ),
                Icon(Icons.swap_horiz, color: Colors.white),
                DropdownButton<String>(
                  dropdownColor: Colors.grey[850],
                  value: _selectedLanguage,
                  items: _languages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(
                        entry.key,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Translation',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                height: 165,
                child: Text(
                  _translatedText,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
