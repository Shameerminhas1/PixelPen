import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void dispose() {
    _listScrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, sender: "User"));
      _isTyping = true;
    });
    _simulateBotResponse(text);
    _scrollListToEnd();
  }

  void _simulateBotResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.insert(0,
            ChatMessage(text: "Bot response to: $userMessage", sender: "Bot"));
        _isTyping = false;
      });
      _scrollListToEnd();
    });
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
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
        title: Text(
          'AI Generator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
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
        color: Colors.grey[900],
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
    bool isUser = sender == "User";
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
