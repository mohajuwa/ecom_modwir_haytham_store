import 'dart:io';
import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class AttachmentData {
  Crud crud;
  AttachmentData(this.crud);
  Future<Map<String, dynamic>> uploadFileAttachments(
      List<File> attachments, String orderId) async {
    var response = await crud.uploadFiles(
      AppLink.attachmentsUpload,
      files: attachments,
      fieldName: "files",
      fields: {
        "order_id": orderId, // <-- كأنك في $_POST["order_id"]
      },
    );
    return response.fold((l) => {"status": "fail"}, (r) => r);
  }
}
