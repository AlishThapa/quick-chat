import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);


    if (imageFile != null) {
      String imageUrl = await _uploadImageToFirebaseStorage(imageFile, user.user!.uid);
      await _firestore.collection("users").doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'address': address,
        'imageUrl': imageUrl,
      });
    } else {
      await _firestore.collection("users").doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'address': address,
      });
    }
    print('User signed up: ${user.user!.uid} ${user.user!.email}');
    return user;
  }

  //upload image to firebase storage
  Future<String> _uploadImageToFirebaseStorage(File imageFile, String userId) async {
    final storageReference = FirebaseStorage.instance.ref().child('user_images').child('$userId.jpg');
    await storageReference.putFile(imageFile);
    final imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
