import 'dart:async';
import 'dart:io';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/model/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return;

    credential.user?.updateDisplayName(name);
    // credential.user?.updatePhotoURL(photoURL);
  }

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  static ChatUser toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: user.photoURL ?? '',
    );
  }
}
