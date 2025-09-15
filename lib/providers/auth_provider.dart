import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isInitial => _status == AuthStatus.initial;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isUnauthenticated => _status == AuthStatus.unauthenticated;
  bool get hasError => _status == AuthStatus.error;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      } else {
        _setUnauthenticated();
      }
    });
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoadingWithoutClearingUser() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setAuthenticated(UserModel user) {
    _status = AuthStatus.authenticated;
    _user = user;
    _errorMessage = null;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _status = AuthStatus.unauthenticated;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String errorMessage) {
    _status = AuthStatus.error;
    _user = null;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _setLoadingWithoutClearingUser();

      final userData = await _authService.getUserData(uid);
      if (userData != null) {
        final user = UserModel.fromMap(userData);
        _setAuthenticated(user);
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _setLoading();

      final result = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (result?.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _setLoading();

      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result?.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading();

      final result = await _authService.signInWithGoogle();

      if (result?.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading();

      await _authService.signOut();
      _setUnauthenticated();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> updateProfile({String? fullName, String? email}) async {
    if (user == null) {
      _setError('User not authenticated. Please sign in again.');
      return false;
    }

    try {
      _setLoadingWithoutClearingUser();

      // Check if email is being changed
      if (email != null && email != user!.email) {
        // Show warning about email change
        _setError(
          'Email changes require re-authentication. Please sign out and sign in with your new email.',
        );
        return false;
      }

      await _authService.updateUserProfile(
        uid: user!.uid,
        fullName: fullName,
        email: email,
      );

      await _loadUserData(user!.uid);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void clearError() {
    if (hasError) {
      _errorMessage = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }
}
