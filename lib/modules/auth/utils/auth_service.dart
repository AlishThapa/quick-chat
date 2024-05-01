import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    //incase the user is added from firebase itself
    _firestore.collection("users").doc(user.user!.uid).set(
      {
        'uid': user.user!.uid,
        'email': email,
        'password': password,
        'name': 'default name',
        'phone': 'default phone',
        'address': 'default address',
      },
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
  }) async {
    UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("users").doc(user.user!.uid).set({
      'uid': user.user!.uid,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'address': address,
    });
    print('The user credentials are: ${user.user!.uid} ${user.user!.email}');
    return user;
  }

  //sign   out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
