import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class HomeData {
  Crud crud;
  HomeData(this.crud);
  getData(String lang) async {
    var response = await crud.postData(AppLink.homePage, {
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }

  searchData(String search) async {
    var response = await crud.postData(AppLink.searchitems, {
      "search": search,
    });
    return response.fold((l) => l, (r) => r);
  }
}
