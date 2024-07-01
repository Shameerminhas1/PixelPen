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
      apiKey: 'AIzaSyBX7BHTNXm6d5O4Pv_jbSbQ1A55f2kiJfQ',
    );
    _controller.text = widget.initialText;
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

  void _addSuggestionAndSubmit(String suggestion) {
    final text = _controller.text + '\n' + suggestion;
    _handleSubmitted(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'AI Generator',
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
                _buildTextComposer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 160,
                child: ElevatedButton(
                  onPressed: () => _addSuggestionAndSubmit(
                      "generate context-based text of the text given above"),
                  child: Text(
                    "Generate Context",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () =>
                      _addSuggestionAndSubmit("paraphrase the above text"),
                  child: Text(
                    "Paraphrase",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 0.1,
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: TextField(
                    maxLines: null,
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter text to generate response',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                  child: FloatingActionButton.small(
                    onPressed: () => _handleSubmitted(_controller.text),
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
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
                    color: isUser ? Colors.white : Colors.white70,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.white,
                      //   blurRadius: 4.0,
                      //   offset: Offset(2, 2),
                      // ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.black),
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
