import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;

class Crud {
  /// Makes a POST request to the specified URL with the provided data
  ///
  /// Returns Either<StatusRequest, Map<String, dynamic>> to properly handle errors
  /// and ensure type safety throughout the application.
  Future<Either<StatusRequest, Map<String, dynamic>>> postData(
      String linkurl, dynamic data) async {
    try {
      // Internet connectivity check (uncomment when needed)
      // if (!await checkinternet()) {
      //   return const Left(StatusRequest.offlinefailure);
      // }

      // Make the HTTP request
      final response = await http
          .post(Uri.parse(linkurl), body: data)
          .timeout(const Duration(seconds: 30));

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Handle successful response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          // Parse JSON response and ensure it's Map<String, dynamic>
          final decodedResponse = jsonDecode(response.body);

          if (decodedResponse is Map) {
            return Right(Map<String, dynamic>.from(decodedResponse));
          } else {
            // Handle unexpected response format (not a Map)
            return Right(<String, dynamic>{
              'status': 'success',
              'data': decodedResponse,
            });
          }
        } catch (e) {
          print("JSON Decode Error: $e");
          return Right(<String, dynamic>{
            'status': 'success',
            'raw_data': response.body
          });
        }
      }

      // Handle server failures
      return const Left(StatusRequest.serverFailure);
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      return const Left(StatusRequest.serverFailure);
    } on TimeoutException {
      print("Request Timeout");
      return const Left(StatusRequest.serverFailure);
    } catch (e) {
      print("Unexpected Error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }

  /// Helper method to check internet connectivity
  Future<bool> checkinternet() async {
    try {
      return await checkInternet();
    } catch (e) {
      print("Error checking internet: $e");
      return false;
    }
  }
}
