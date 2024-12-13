import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class LoginController {
  late int id;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserModel userModel = UserModel();
  final FirebaseService _firebaseService = FirebaseService();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  Future<bool> login() async {
    final email = emailController.text;
    String emailAuth = emailController.text.trim();
    String passwordAuth = passwordController.text.trim();
    final user = await userModel.getUserByEmail(email);
    User? userAuth = await _firebaseService.signIn(emailAuth, passwordAuth);
    if (user != null){
        if (userAuth != null){
          id = (await userModel.getUserIdByEmail(email))!;
          return true;
        }
    }
    return false;
  }
}
