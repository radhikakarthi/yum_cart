// ─────────────────────────────────────────────────────────────────────────────
// providers/auth_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: 'dummy-client-id.apps.googleusercontent.com');

  late final StreamController<dynamic> _authStateController;
  StreamSubscription<User?>? _authSubscription;
  bool _isFakeLoggedIn = false;

  AuthProvider() {
    _authStateController = StreamController<dynamic>.broadcast(
      onListen: () {
        if (_isFakeLoggedIn) {
          _authStateController.add('FakeUser');
        }
      },
    );
    
    // Attempt to listen to Firebase auth changes
    try {
      _authSubscription = _auth.authStateChanges().listen((user) {
        if (!_isFakeLoggedIn) {
          _authStateController.add(user);
        }
      });
    } catch (_) {
      // Ignore if Firebase isn't fully initialized
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authStateController.close();
    super.dispose();
  }

  dynamic get currentUser => _isFakeLoggedIn ? 'FakeUser' : _auth.currentUser;
  Stream<dynamic> get authStateChanges => _authStateController.stream;

  bool _isLoading = false;
  String? _error;
  String? _verificationId;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Google Sign‑In ──────────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _error = null;

    // --- FAKE GOOGLE SIGN-IN FOR MACHINE TEST ---
    await Future.delayed(const Duration(seconds: 1));
    _isFakeLoggedIn = true;
    _authStateController.add('FakeUser');
    _setLoading(false);
    return true;
  }

  // ── Phone – send OTP ────────────────────────────────────────────────────────
  Future<void> sendOtp({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required void Function(String) onError,
  }) async {
    _setLoading(true);
    _error = null;

    // --- FAKE OTP FLOW FOR MACHINE TEST ---
    // If the user enters a specific test number or we just bypass it
    if (phoneNumber.replaceAll(RegExp(r'[^0-9]'), '').length >= 10) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      _verificationId = 'fake_verification_id';
      _setLoading(false);
      onCodeSent();
      notifyListeners();
      return;
    }

    // Original Firebase flow (fallback)
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _setLoading(false);
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          _error = e.message;
          _setLoading(false);
          onError(e.message ?? 'Verification failed');
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _setLoading(false);
          onCodeSent();
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      onError(e.toString());
      notifyListeners();
    }
  }

  // ── Phone – verify OTP ──────────────────────────────────────────────────────
  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) return false;
    _setLoading(true);
    _error = null;

    // --- FAKE OTP VERIFICATION ---
    if (_verificationId == 'fake_verification_id') {
      await Future.delayed(const Duration(seconds: 1));
      if (otp == '123456') {
        _isFakeLoggedIn = true;
        _authStateController.add('FakeUser');
        _setLoading(false);
        return true;
      } else {
        _error = 'Invalid test OTP. Please use 123456.';
        _setLoading(false);
        return false;
      }
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ── Sign Out ────────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    if (_isFakeLoggedIn) {
      _isFakeLoggedIn = false;
      _authStateController.add(null);
    } else {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }
    notifyListeners();
  }
}
