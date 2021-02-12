import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_firestore/'

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _user;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthenticationService();

  Future<void> signUp(
      {String,
      firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      final firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      _user = firebaseUser.user;
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return 'Signed in';
    } on FirebaseException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  Future<void> setUserData() async {}
}
