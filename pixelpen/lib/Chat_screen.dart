// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'dart:io';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _listScrollController = ScrollController();
//   final FocusNode _focusNode = FocusNode();
//   bool _isTyping = false;
//   late final GenerativeModel _model;

//   @override
//   void initState() {
//     super.initState();
//     _model = GenerativeModel(
//         model: 'gemini-1.5-flash',
//         //sk-proj-txMmDfVhdX63RP5iaOiBT3BlbkFJ8Zaqub6VXd8ddrmO6q7L
//         apiKey: 'AIzaSyBX7BHTNXm6d5O4Pv_jbSbQ1A55f2kiJfQ');
//   }

//   @override
//   void dispose() {
//     _listScrollController.dispose();
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _handleSubmitted(String text) async {
//     if (text.isEmpty) return;
//     _controller.clear();
//     setState(() {
//       _messages.insert(0, ChatMessage(text: text, sender: "PixelPen"));
//       _isTyping = true;
//     });

//     final response = await _generateBotResponse(text);
//     setState(() {
//       _messages.insert(0, ChatMessage(text: response, sender: "CODE-X"));
//       _isTyping = false;
//     });

//     _scrollListToEnd();
//   }

//   Future<String> _generateBotResponse(String userMessage) async {
//     final content = [Content.text(userMessage)];
//     final response = await _model.generateContent(content);
//     return response.text ?? "Sorry, I couldn't understand that.";
//   }

//   void _scrollListToEnd() {
//     _listScrollController.animateTo(
//       _listScrollController.position.minScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'AI Generator',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: Stack(
//         children: [
//           AnimatedContainer(
//             duration: Duration(seconds: 3),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black, Colors.grey[850]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: <Widget>[
//                 Flexible(
//                   child: ListView.builder(
//                     padding: EdgeInsets.all(8.0),
//                     controller: _listScrollController,
//                     reverse: true,
//                     itemBuilder: (_, int index) => _messages[index],
//                     itemCount: _messages.length,
//                   ),
//                 ),
//                 if (_isTyping) ...[
//                   const SpinKitThreeBounce(
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   const SizedBox(height: 15),
//                 ],
//                 Divider(height: 1.0),
//                 _buildTextComposer(),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _handleSubmitted(_controller.text),
//         backgroundColor: Colors.grey,
//         child: Icon(Icons.send),
//       ),
//     );
//   }

//   Widget _buildTextComposer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(25.0),
//       ),
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.circle, color: Colors.white),
//             onPressed: () {
//               // Handle mic press
//             },
//           ),
//           Flexible(
//             child: TextField(
//               controller: _controller,
//               focusNode: _focusNode,
//               onSubmitted: _handleSubmitted,
//               decoration: InputDecoration.collapsed(
//                 hintText: 'Enter text to generate response',
//                 hintStyle: TextStyle(color: Colors.grey),
//               ),
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: IconButton(
//               icon: Icon(Icons.send, color: Colors.white),
//               onPressed: () => _handleSubmitted(_controller.text),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage extends StatelessWidget {
//   final String text;
//   final String sender;

//   ChatMessage({required this.text, required this.sender});

//   @override
//   Widget build(BuildContext context) {
//     bool isUser = sender == "PixelPen";
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment:
//             isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: <Widget>[
//           if (!isUser)
//             CircleAvatar(
//               child: Text(sender[0]),
//               backgroundColor: Colors.blue,
//             ),
//           if (!isUser) const SizedBox(width: 10),
//           Flexible(
//             child: Column(
//               crossAxisAlignment:
//                   isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   sender,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 5.0),
//                   padding: const EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     color: isUser ? Colors.blueAccent : Colors.grey[700],
//                     borderRadius: BorderRadius.circular(15.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 4.0,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     text,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isUser) const SizedBox(width: 10),
//           if (isUser)
//             CircleAvatar(
//               child: Text(sender[0]),
//               backgroundColor: Colors.grey,
//             ),
//         ],
//       ),
//     );
//   }
// }
//-------

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String initialText;

  ChatScreen({this.initialText = ''});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey:
          'AIzaSyBX7BHTNXm6d5O4Pv_jbSbQ1A55f2kiJfQ', // Replace with your actual API key
    );
    _controller.text =
        widget.initialText; // Initialize text controller with initial text
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, sender: "PixelPen"));
      _isTyping = true;
    });

    final response = await _generateBotResponse(text);
    setState(() {
      _messages.insert(0, ChatMessage(text: response, sender: "CODE-X"));
      _isTyping = false;
    });

    _scrollListToEnd();
  }

  Future<String> _generateBotResponse(String userMessage) async {
    final content = [Content.text(userMessage)];
    final response = await _model.generateContent(content);
    return response.text ?? "Sorry, I couldn't understand that.";
  }

  void _scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'AI Generator',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
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
          SafeArea(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    controller: _listScrollController,
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                if (_isTyping) ...[
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(height: 15),
                ],
                Divider(height: 1.0),
                _buildTextComposer(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleSubmitted(_controller.text),
        backgroundColor: Colors.grey,
        child: Icon(Icons.send),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.circle, color: Colors.white),
            onPressed: () {
              // Handle mic press
            },
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter text to generate response',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;

  ChatMessage({required this.text, required this.sender});

  @override
  Widget build(BuildContext context) {
    bool isUser = sender == "PixelPen";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!isUser)
            CircleAvatar(
              child: Text(sender[0]),
              backgroundColor: Colors.blue,
            ),
          if (!isUser) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sender,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blueAccent : Colors.grey[700],
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 10),
          if (isUser)
            CircleAvatar(
              child: Text(sender[0]),
              backgroundColor: Colors.grey,
            ),
        ],
      ),
    );
  }
}
