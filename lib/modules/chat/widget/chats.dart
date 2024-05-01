import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({
    super.key,
    required this.alignUser,
    required this.isCurrentUser,
    required this.borderRad,
    required this.data,
    required this.message,
    required this.formattedTime,
  });

  final Alignment alignUser;
  final bool isCurrentUser;
  final double borderRad;
  final Map<String, dynamic> data;
  final QueryDocumentSnapshot<Object?> message;
  final String formattedTime;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String _visibleTimeStamp = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _visibleTimeStamp = _visibleTimeStamp == widget.message.id ? '' : widget.message.id;
        });
      },
      child: Align(
        alignment: widget.alignUser,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //if current user then show the initial letter at the front of the message
            if (!widget.isCurrentUser) ...[
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  widget.data['message'][0],
                  style: TextStyle(color: widget.isCurrentUser ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.isCurrentUser ? Colors.blue[400] : Colors.grey[200],
                borderRadius: widget.isCurrentUser
                    ? BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRad), topRight: Radius.circular(widget.borderRad), bottomLeft: Radius.circular(widget.borderRad))
                    : BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRad),
                        topRight: Radius.circular(widget.borderRad),
                        bottomRight: Radius.circular(widget.borderRad)),
              ),
              child: Column(
                crossAxisAlignment: widget.isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['message'],
                    style: TextStyle(color: widget.isCurrentUser ? Colors.white : Colors.black),
                  ),
                  if (_visibleTimeStamp == widget.message.id)
                    Text(
                      widget.formattedTime,
                      style: TextStyle(color: widget.isCurrentUser ? Colors.white : Colors.black, fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                ],
              ),
            ),
            if (widget.isCurrentUser) ...[
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 10,
                child: Text(
                  widget.data['message'][0],
                  style: TextStyle(color: widget.isCurrentUser ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
