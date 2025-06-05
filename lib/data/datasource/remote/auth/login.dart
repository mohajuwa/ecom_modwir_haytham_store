import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/core/constant/keys.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginData {
  Crud crud;
  // Initialize code with a default value
  String code = "0000";

  LoginData(this.crud) {
    // Generate a random 4-digit code
    // code = (Random().nextInt(9000) + 1000).toString();
  }
  postData(String phone) async {
    // final code = (Random().nextInt(9000) + 1000).toString();

    var response = await crud.postData(AppLink.login, {
      "phone": phone,
      "verfiyCode": code,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<bool> sendWhatsAppVerification(String phoneNumber) async {
    try {
      debugPrint(
          'Sending verification code $code to WhatsApp number: $phoneNumber');

      final response = await http.post(
        Uri.parse('https://graph.facebook.com/v18.0/$fromNumberId/messages'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messaging_product": "whatsapp",
          "to": phoneNumber,
          "type": "template",
          "template": {
            "name": "amper",
            "language": {"code": "ar"},
            "components": [
              {
                "type": "body",
                "parameters": [
                  {
                    "type": "text",
                    "text": code // الكود المراد إرساله
                  }
                ]
              },
              {
                "type": "button",
                "sub_type": "url",
                "index": 0,
                "parameters": [
                  {
                    "type": "text",
                    "text": code // Replace with your actual URL
                  }
                ]
              }
            ]
          }
        }),
      );

      debugPrint("Response code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint('WhatsApp verification template sent successfully!');
        return true;
      } else {
        debugPrint('Failed to send WhatsApp template.');
        return false;
      }
    } catch (e) {
      debugPrint('Exception while sending WhatsApp template: $e');
      return false;
    }
  }

  // Helper method to ensure phone number is properly formatted for WhatsApp
  String formatPhoneForWhatsApp(String phone) {
    // Remove any non-digit characters
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Make sure it has Yemen country code (966)
    if (!digits.startsWith('+') && !digits.startsWith('966')) {
      // Add Yemen country code
      digits = '966$digits';
    }

    // Remove any '+' as WhatsApp API doesn't use it
    digits = digits.replaceAll('+', '');

    return digits;
  }

  // Simplified method for login flow - just call this from your UI
  Future<Map<String, dynamic>> loginWithVerification(String phone) async {
    try {
      // This single call will:
      // 1. Generate a verification code
      // 2. Store it in your database via API
      // 3. If API call succeeds, automatically send WhatsApp message
      return await postData(phone);
    } catch (e) {
      debugPrint('Error in login verification process: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }
}

// Example usage in your login screen:
/*
void sendVerificationCode() async {
  Crud crud = Crud();
  LoginData loginData = LoginData(crud);
  
  // Just call this one method - it handles everything
  var result = await loginData.loginWithVerification(phoneController.text);
  
  if (result['status'] == 'success') {
    // Show success message and navigate to verification page
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => VerificationScreen(phoneController.text)
    ));
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification failed. Please try again.'))
    );
  }
}
*/