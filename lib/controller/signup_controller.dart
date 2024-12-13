import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(value)) {
      return "Enter a valid phone number";
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<bool> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      final user = Userr(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text
      );
      final userModel = UserModel();
      User? userr = await _firebaseService.signUp(emailController.text, passwordController.text);
      if (userr != null) {
        await userModel.insertUser(user);
        return true;
      }
    }
    return false;
  }
}
