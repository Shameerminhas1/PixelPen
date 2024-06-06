// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class TranslateScreen extends StatefulWidget {
//   @override
//   _TranslateScreenState createState() => _TranslateScreenState();
// }

// class _TranslateScreenState extends State<TranslateScreen> {
//   final TextEditingController _textController = TextEditingController();
//   String _selectedLanguage = 'es'; // Default language
//   String _selectedUrduMessage = 'ur'; // Selected Urdu message
//   String _translatedText = '';

//   // Define the languages with user-friendly labels
//   final Map<String, String> _languages = {
//     'English': 'en',
//     'French': 'fr',
//     'Spanish': 'es',
//     'German': 'de',
//     'Italian': 'it',
//     'Portuguese': 'pt',
//     'Urdu': 'ur',
//     'Hindi': 'hi',
//     'Persian': 'fa',
//     'Arabic': 'ar',
//   };

//   // API URL
//   final String apiUrl = 'https://translate-api-alpha.vercel.app/translate';

//   // Function to handle translation
//   Future<void> _translateText() async {
//     final Map<String, String> requestData = {
//       'content': _textController.text,
//       'language': _selectedLanguage,
//       'base_language': _selectedUrduMessage.isNotEmpty
//           ? 'ur'
//           : '', // Include base_language if Urdu message is selected
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(requestData),
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         setState(() {
//           _translatedText = responseData['data'];
//         });
//       } else {
//         final responseData = json.decode(response.body);
//         setState(() {
//           _translatedText = 'Error: ${responseData['message']}';
//         });
//       }
//     } catch (error) {
//       setState(() {
//         _translatedText = 'Error: $error';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white, // Change this to the desired color
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Text(
//           'Translate Menu',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Welcome back !',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: TextField(
//                 controller: _textController,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: 'Type or paste here to translate',
//                   hintStyle: TextStyle(color: Colors.white54),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 maxLines: null, // Allows multiple lines
//                 keyboardType: TextInputType.multiline,
//                 textInputAction: TextInputAction.newline,
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 DropdownButton<String>(
//                   dropdownColor: Colors.grey[850],
//                   value: _selectedUrduMessage,
//                   items: _languages.entries.map((entry) {
//                     return DropdownMenuItem<String>(
//                       value: entry.value,
//                       child: Text(
//                         entry.key,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedUrduMessage = newValue!;
//                     });
//                   },
//                 ),
//                 Icon(Icons.swap_horiz, color: Colors.white),
//                 DropdownButton<String>(
//                   dropdownColor: Colors.grey[850],
//                   value: _selectedLanguage,
//                   items: _languages.entries.map((entry) {
//                     return DropdownMenuItem<String>(
//                       value: entry.value,
//                       child: Text(
//                         entry.key,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedLanguage = newValue!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 //primary: Colors.blueAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onPressed: _translateText,
//               child: Text('Translate'),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Translation',
//               style: TextStyle(color: Colors.white, fontSize: 16.0),
//             ),
//             SizedBox(height: 8.0),
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[850],
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Container(
//                 height: 165,
//                 child: Text(
//                   _translatedText,
//                   style: TextStyle(color: Colors.white, fontSize: 16.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslateScreen extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'es'; // Default language
  String _selectedUrduMessage = 'ur'; // Selected Urdu message
  String _translatedText = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  final FlutterTts flutterTts = FlutterTts();

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _translateText() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, String> requestData = {
      'content': _textController.text,
      'language': _selectedLanguage,
      'base_language': _selectedUrduMessage.isNotEmpty ? 'ur' : '',
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
          _animationController.reset();
          _animationController.forward();
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

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _speakText() async {
    if (_translatedText.isNotEmpty) {
      await flutterTts.speak(_translatedText);
    }
  }

  void _copyToClipboard() {
    if (_translatedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _translatedText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard!')),
      );
    }
  }

  void _clearText() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Translate Menu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.grey[850]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.white),
                            onPressed: _clearText,
                          ),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey[850],
                              value: _selectedUrduMessage,
                              isExpanded: true,
                              underline: SizedBox(),
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey[850],
                              value: _selectedLanguage,
                              isExpanded: true,
                              underline: SizedBox(),
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            onPressed: _translateText,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    'Translate',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Translation',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 170.0),
                        IconButton(
                          icon: Icon(Icons.volume_up, color: Colors.white),
                          onPressed: _speakText,
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: Colors.white),
                          onPressed: _copyToClipboard,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _translatedText,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
