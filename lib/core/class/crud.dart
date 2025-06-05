import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;

String _basicAuth =
    'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfsdfsdfsdfsdf'))}';
Map<String, String> _myheaders = {
  // 'content-type': 'application/json',
  'accept': 'application/json',
  'authorization': _basicAuth
};

class Crud {
  /// Makes a POST request to the specified URL with the provided data
  ///
  /// Returns Either<StatusRequest, Map<String, dynamic>> to properly handle errors
  /// and ensure type safety throughout the application.
  Future<Either<StatusRequest, Map<String, dynamic>>> postData(
      String linkurl, dynamic data) async {
    try {
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

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

  Future<Either<StatusRequest, Map<String, dynamic>>> uploadFiles(
    String url, {
    required List<File> files,
    required String fieldName,
    Map<String, String>? fields, // <-- هذا الجديد
  }) async {
    try {
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_myheaders);

      // Attach files
      for (var file in files) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          fieldName,
          stream,
          length,
          filename: file.path.split("/").last,
        );
        request.files.add(multipartFile);
      }

      // Attach additional fields like orderId
      if (fields != null) {
        request.fields.addAll(fields);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map) {
          return Right(Map<String, dynamic>.from(decoded));
        } else {
          return Right({"data": decoded});
        }
      } else {
        return const Left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print("Upload error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }

  Future<Either<StatusRequest, Map<String, dynamic>>> uploadFilesWithProgress(
    String url, {
    required List<File> files,
    required String fieldName,
    Map<String, String>? fields,
    required void Function(double progress) onProgress,
  }) async {
    try {
      if (!await checkInternet()) {
        return const Left(StatusRequest.offlinefailure);
      }

      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_myheaders);

      int totalBytes = 0;
      int bytesSent = 0;

      for (var file in files) {
        int fileLength = await file.length();
        totalBytes += fileLength;
      }

      for (var file in files) {
        int fileLength = await file.length();

        var stream = http.ByteStream(file.openRead().transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              bytesSent += data.length;
              double progress = (bytesSent / totalBytes) * 100;
              onProgress(progress);
              sink.add(data);
            },
          ),
        ));

        var multipartFile = http.MultipartFile(
          '$fieldName[]',
          stream,
          fileLength,
          filename: file.path.split('/').last,
        );

        request.files.add(multipartFile);
      }

      if (fields != null) {
        request.fields.addAll(fields);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return Right(decoded);
        } else {
          return Right({'data': decoded});
        }
      } else {
        return const Left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print("Upload error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }
}
