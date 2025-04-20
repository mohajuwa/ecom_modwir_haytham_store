import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:http/http.dart' as http;

class Crud {
  Future<Either<StatusRequest, Map>> postData(String linkurl, data) async {
    try {
      // if (!await checkInternet()) {
      //   return const Left(StatusRequest.offlinefailure);
      // }

      final response = await http
          .post(Uri.parse(linkurl), body: data)
          .timeout(const Duration(seconds: 30));

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return Right(jsonDecode(response.body));
        } catch (e) {
          print("JSON Decode Error: $e");
          return Right({'status': 'success', 'raw_data': response.body});
        }
      }
      return const Left(StatusRequest.serverFailure);
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      return const Left(StatusRequest.serverFailure);
    } on TimeoutException {
      return const Left(StatusRequest.serverFailure);
    } catch (e) {
      print("Unexpected Error: $e");
      return const Left(StatusRequest.serverFailure);
    }
  }
}
// class Crud {
//   Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
//     if (await checkInternet()) {
//       var response = await http.post(Uri.parse(linkurl), body: data);
//       print("Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}"); // <-- Add this line

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           Map responsebody = jsonDecode(response.body);
//           print(responsebody);
//           return Right(responsebody);
//         } catch (e) {
//           print("Error decoding JSON: $e");
//           return const Left(StatusRequest.serverFailure);
//         }
//       } else {
//         return const Left(StatusRequest.serverFailure);
//       }
//     } else {
//       return const Left(StatusRequest.offlinefailure);
//     }
//   }
// }








// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:ecom_modwir/core/class/statusrequest.dart';
// import 'package:ecom_modwir/core/functions/checkinternet.dart';
// import 'package:http/http.dart' as http;

// class Crud {
//   Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
//     if (await checkInternet()) {
//       var response = await http.post(Uri.parse(linkurl), body: data);
//       print(response.statusCode);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Map responsebody = jsonDecode(response.body);
//         print(responsebody);

//         return Right(responsebody);
//       } else {
//         return const Left(StatusRequest.serverFailure);
//       }
//     } else {
//       return const Left(StatusRequest.offlinefailure);
//     }
//   }
// }
