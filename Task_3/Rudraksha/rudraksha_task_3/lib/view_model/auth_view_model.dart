import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';



enum AuthStatus { Uninitialized, Authenticated, Authenticating, Unauthenticated, Error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;


  AuthStatus _status = AuthStatus.Uninitialized;
  User? _user;
  String? _errorMessage;


  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthViewModel({required AuthRepository authRepository}) : _authRepository = authRepository {
    _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }


  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = AuthStatus.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = AuthStatus.Authenticated;
    }
    notifyListeners();
  }


  Future<void> signIn({required String email, required String password}) async {
    _status = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signIn(email: email, password: password);

    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.Error;
      notifyListeners();
    }
  }

  // Sign up method
  Future<void> signUp({required String email, required String password}) async {
    _status = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signUp(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.Error;
      notifyListeners();
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _authRepository.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }
}
