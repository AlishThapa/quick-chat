import 'package:flutter/material.dart';
import 'package:quickchat/modules/auth/utils/auth_service.dart';
import 'package:quickchat/modules/chat/services/chat_services.dart';
import 'package:quickchat/modules/chat/widget/chats.dart';

import '../../utils.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String _visibleTimeStamp = '';

  void _sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final senderId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _chatService.getMessages(senderId, widget.receiverId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  //empty state
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No messages'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((message) {
                      Map<String, dynamic> data = message.data() as Map<String, dynamic>;
                      bool isCurrentUser = data['senderId'] == senderId;
                      var alignUser = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
                      var borderRad = 18.0;
                      DateTime timestamp = data['timestamp'].toDate();
                      String formattedTime = formatChatTimestamp(timestamp);

                      return Chats(
                        alignUser: alignUser,
                        isCurrentUser: isCurrentUser,
                        borderRad: borderRad,
                        data: data,
                        formattedTime: formattedTime,
                        message: message,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter your message',
                      hintStyle: const TextStyle(color: Colors.black),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () => _sendMessage(),
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
