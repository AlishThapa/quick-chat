import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickchat/modules/chat/models/message.dart';

class ChatService {
  //get instance of cloud firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //firebase auth instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<QuerySnapshot> getUsers() {
    return _firestore.collection('users').snapshots();
  }

  //get chat stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //it goes through each document (USERS) in the users collection
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send the message
  Future<void> sendMessage(String receiverId, String message) async {
    final uid = _auth.currentUser!.uid;
    final email = _auth.currentUser!.email;
    final timestamp = Timestamp.now();
    //create a new message from the model just created
    Message newMessage = Message(
      senderId: uid,
      senderEmail: email!,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [uid, receiverId];
    ids.sort();
    String chatroomID = ids.join('_');

    //add to the firestore collection called chat-room
    await _firestore.collection('chat_room').doc(chatroomID).collection('messages').add(newMessage.toMap()).then((value) {
      print(value.id);
    });
  }

  //get the messages
  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    //construct chatroom for 2 users
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatroomID = ids.join('_');
    return _firestore
        .collection('chat_room')
        .doc(chatroomID)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: false,
        )
        .snapshots();
  }
}
