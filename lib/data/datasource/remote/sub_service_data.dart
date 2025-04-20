import 'package:dartz/dartz.dart';
import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/linkapi.dart';

class ServiceItemsData {
  final Crud crud;
  ServiceItemsData(this.crud);

  // Method to fetch service details based on serviceId and language
  Future<Either<StatusRequest, Map<String, dynamic>>> getServiceDetails(
      String serviceId, String lang) async {
    try {
      // Making the POST request to the serviceDisplay API
      final result = await crud.postData(AppLink.serviceDisplay, {
        "serviceId": serviceId,
        "lang": lang,
      });

      // Handling success or failure via the fold method
      return result.fold(
        (left) =>
            Left(left), // In case of failure (left), return the status request
        (right) => Right(right as Map<String,
            dynamic>), // In case of success (right), return the data as a map
      );
    } catch (e) {
      // Catching any exception and returning a server failure status
      return Left(StatusRequest.serverFailure);
    }
  }

  // Method to fetch car makes based on the language
  Future<Either<StatusRequest, Map<String, dynamic>>> getCarMakes(
      String lang) async {
    try {
      // Making the POST request to the carsMakeDisplay API
      final result = await crud.postData(AppLink.carsMakeDisplay, {
        "lang": lang,
      });

      // Handling success or failure via the fold method
      return result.fold(
        (left) =>
            Left(left), // In case of failure (left), return the status request
        (right) => Right(right as Map<String,
            dynamic>), // In case of success (right), return the data as a map
      );
    } catch (e) {
      // Catching any exception and returning a server failure status
      return Left(StatusRequest.serverFailure);
    }
  }

  Future<Either<StatusRequest, bool>> updateDataWithLang({
    required String table,
    required Map<String, dynamic> data,
    required String where,
  }) async {
    try {
      final response = await crud.postData(
        AppLink.updateVehicleWithLang,
        {'table': table, 'data': data, 'where': where},
      );

      return response.fold(
        (failure) => Left(failure),
        (responseData) {
          if (responseData['status'] == 'success') {
            return const Right(true);
          }

          return Left(StatusRequest.serverFailure);
        },
      );
    } catch (e) {
      return Left(StatusRequest.serverException);
    }
  }
}
