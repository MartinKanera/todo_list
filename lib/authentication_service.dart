import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loggedIn = false;

  Map<String, String> userData = {
    'id': '',
    'displayName': '',
  };

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthenticationService();

  Future<void> signUp(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      final firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      firebaseUser.user;
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential user =
          await _firebaseAuth.signInWithCredential(credential);

      await setUserData(userId: user.user.uid, fullName: user.user.displayName);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  Future<void> setUserData({String userId, String fullName}) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    print(fullName);

    Map<String, dynamic> fetchedUserData =
        await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);

      if (snapshot.exists) return snapshot.data();

      Map<String, String> newUserDoc = {
        'displayName': fullName,
      };

      transaction.set(userRef, newUserDoc);
      return newUserDoc;
    });

    print(fetchedUserData['displayName']);

    userData = {
      'id': userId,
      'displayName': fetchedUserData['displayName'],
    };
  }
}
