import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;


  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;


  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }


  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign up: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}