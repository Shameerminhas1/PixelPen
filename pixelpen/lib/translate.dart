// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class TranslateScreen extends StatefulWidget {
//   @override
//   _TranslateScreenState createState() => _TranslateScreenState();
// }

// class _TranslateScreenState extends State<TranslateScreen> {
//   final TextEditingController _textController = TextEditingController();
//   String _selectedLanguage = 'fr';
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

//   Future<void> _translateText() async {
//     const String apiUrl = 'https://translate-api-alpha.vercel.app/translate';
//     final Map<String, String> requestData = {
//       'content': _textController.text,
//       'language': _selectedLanguage,
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
//       appBar: AppBar(
//         title: Text('Translate Screen'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 labelText: 'Enter text to translate',
//               ),
//               maxLines: null, // Allows multiple lines
//               keyboardType: TextInputType.multiline,
//               textInputAction: TextInputAction.newline,
//             ),
//             SizedBox(height: 16.0),
//             DropdownButton<String>(
//               value: _selectedLanguage,
//               items: _languages.entries.map((entry) {
//                 return DropdownMenuItem<String>(
//                   value: entry.value,
//                   child: Text(entry.key),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedLanguage = newValue!;
//                 });
//               },
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _translateText,
//               child: Text('Translate'),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Translated Text: ',
//               style: TextStyle(fontSize: 16.0),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               _translatedText,
//               style: TextStyle(fontSize: 16.0),
//               textAlign: TextAlign.left,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateScreen extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'en'; // Default language
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
      appBar: AppBar(
        title: Text('Translate Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
              ),
              maxLines: null, // Allows multiple lines
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            SizedBox(height: 16.0),
            Column(
              children: [
                Row(
                  children: [
                    Text("Select Base Language: "),
                    SizedBox(width: 16.0),
                    DropdownButton<String>(
                      dropdownColor: Colors.lightGreen,
                      value: _selectedUrduMessage,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'ur',
                          child: Text(
                            'Urdu',
                            style: TextStyle(
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedUrduMessage = newValue!;
                        });
                      },
                    ),

                    // DropdownButton<String>(
                    //   //hint: Text("Translated Language: "),
                    //   dropdownColor: Colors.lightGreen,
                    //   value: _selectedUrduMessage,
                    //   items: _languages.entries.map((entry) {
                    //     return DropdownMenuItem<String>(
                    //       value: entry.value,
                    //       child: Text(
                    //         entry.key,
                    //         style: TextStyle(
                    //             color:
                    //                 entry.value == 'ur' ? Colors.purple : null),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       _selectedUrduMessage = newValue!;
                    //     });
                    //   },
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Select Targeted Language: "),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      // hint: Text("Base Language: "),
                      dropdownColor: Colors.purple,
                      value: _selectedLanguage,
                      items: _languages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.value,
                          child: Text(entry.key),
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
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Translated Text: ',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
