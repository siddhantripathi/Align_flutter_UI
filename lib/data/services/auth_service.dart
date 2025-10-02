import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user model
  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    // Try to get stored tokens
    final idToken = await _secureStorage.read(key: 'id_token');
    final accessToken = await _secureStorage.read(key: 'access_token');

    return UserModel.fromFirebaseUser(
      user,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Store tokens securely
        if (googleAuth.idToken != null) {
          await _secureStorage.write(key: 'id_token', value: googleAuth.idToken!);
        }
        if (googleAuth.accessToken != null) {
          await _secureStorage.write(key: 'access_token', value: googleAuth.accessToken!);
        }

        // Store user data
        final userModel = UserModel.fromFirebaseUser(
          user,
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        
        await _secureStorage.write(key: 'user_data', value: jsonEncode(userModel.toJson()));

        return userModel;
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      // Clear stored data
      await _secureStorage.deleteAll();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get stored user data
  Future<UserModel?> getStoredUserData() async {
    try {
      final userData = await _secureStorage.read(key: 'user_data');
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      print('Error getting stored user data: $e');
      return null;
    }
  }

  // Get ID token for API calls
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = currentUser;
      if (user != null) {
        return await user.getIdToken(forceRefresh);
      }
      return null;
    } catch (e) {
      print('Error getting ID token: $e');
      return null;
    }
  }

  // Refresh tokens
  Future<void> refreshTokens() async {
    try {
      final user = currentUser;
      if (user != null) {
        // Force refresh the ID token
        final idToken = await user.getIdToken(true);
        if (idToken != null) {
          await _secureStorage.write(key: 'id_token', value: idToken);
        }
      }
    } catch (e) {
      print('Error refreshing tokens: $e');
    }
  }
}
