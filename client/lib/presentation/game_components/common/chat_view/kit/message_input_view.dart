import 'package:flutter/material.dart';

class MessageInputView extends StatelessWidget {
  final double width;
  final double height;

  final void Function(String) onClickSend;

  const MessageInputView({
    super.key,
    required this.width,
    required this.onClickSend,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            constraints: BoxConstraints(maxWidth: width * 0.8),
            child: TextField(
              focusNode: focusNode,
              onSubmitted: (value) {
                onClickSend(value.trim());
                _messageController.clear();
                focusNode.requestFocus();
              },
              autofocus: true,
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message",
              ),
              style: TextStyle(fontSize: 15),
              keyboardType: TextInputType.text,
              maxLength: 200,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.grey[700]),
            iconSize: 25,
            onPressed: () {
              onClickSend(_messageController.text.trim());
              _messageController.clear();
              focusNode.requestFocus();
            },
          ),
        ],
      ),
    );
  }
}
