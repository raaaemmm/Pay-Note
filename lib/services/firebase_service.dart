import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pay_note/models/user_model.dart';

class FirebaseService {

  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String profilePhotoUrl
    }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;

      // save user info data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'profilePhotoUrl': profilePhotoUrl,
        'phone': phone,
      });
      return user.uid;
    } catch (e) {
      debugPrint("Error creating user: $e");
      rethrow; 
    }
  }

  // sign in user
  Future<void> signIn({
    required String email,
    required String password
    }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("Error signing in: $e");
      rethrow;
    }
  }

  // sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error signed out: $e");
      rethrow;
    }
  }

  // forgot password
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Error sending password reset email: $e");
      rethrow;
    }
  }

  // get current user
  Future<UserModel?> getUser({required String userId}) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>, userId);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  // update user on Firestore only
  Future<void> updateUser({
    required String userId,
    required String name,
    required String phone,
    required String profilePhoto
    }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'phone': phone,
        'profilePhotoUrl': profilePhoto,
      });
    } catch (e) {
      print("Error updating user in Firestore: $e");
      rethrow;
    }
  }

  // Delete user profile photo if it exists
  Future<void> deleteUserProfilePhoto(String profilePhotoUrl) async {
    try {
      await _storage.refFromURL(profilePhotoUrl).delete();
    } catch (e) {
      print('Error deleting user profile photo: $e');
      throw e;
    }
  }

  // Delete user document from Firestore
  Future<void> deleteUser({required String userId}) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      throw e;
    }
  }

    // Delete user from Firebase Authentication
  Future<void> deleteAuthUser() async {
    try {
      User? user = _auth.currentUser;
      await user?.delete();
    } catch (e) {
      print('Error deleting user from Authentication: $e');
      throw e;
    }
  }

  // upload user profile to firebase storage
  Future<String?> uploadUserImage(
      String fileName,
      File imageFile
    ) async {
    try {
      final TaskSnapshot uploadTask = await _storage.ref('userProfiles/$fileName').putFile(imageFile);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image to storage: $e");
      return null;
    }
  }

  // upload updated user profile to firebase storage
  Future<String?> uploadUpdatedUserProfile({
    required String fileName,
    required  File imageFile,
  }) async {
    try {
      final TaskSnapshot uploadTask = await _storage.ref('userUpdatedProfiles/$fileName').putFile(imageFile);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading updated image to storage: $e");
      return null;
    }
  }
}