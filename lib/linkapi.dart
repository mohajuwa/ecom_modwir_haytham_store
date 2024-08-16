class AppLink {
  // ============================ Server Link  Links ============================//

  static const String server = "https://modwir.shmmry.com";

// ============================ Images Links  Links ============================//

  static const String imageStatic = "$server/upload";
  static const String imageCategories = "$imageStatic/categories";
  static const String imageItems = "$imageStatic/items";

// ============================ Test Data  Links ============================//
  static const String test = "$server/test.php";

// ============================ Auth  Links ============================//
  static const String authLink = "$server/auth";

  static const String signUp = "$authLink/signup.php";
  static const String verfiyCodeSignUp = "$authLink/verfiycode.php";
  static const String resendverfiyCode = "$authLink/resend.php";
  static const String login = "$authLink/login.php";

// ============================ Forget Password  Links ============================//
  static const String forgetPasswordLink = "$server/forgetpassword";
  static const String checkEmail = "$forgetPasswordLink/checkemail.php";
  static const String resetPassword = "$forgetPasswordLink/resetpassword.php";
  static const String verfiyCodeForPass = "$forgetPasswordLink/verifycode.php";

  // ============================ Home  Links ============================//
  static const String homeLink = "$server";
  static const String homePage = "$homeLink/home.php";
  static const String offers = "$homeLink/offers.php";

  // ============================ Items  Links ============================//
  static const String itemsLink = "$server/items";
  static const String items = "$itemsLink/items.php";
  static const String searchitems = "$itemsLink/search.php";

  // ============================ Favorite  Links ============================//
  static const String favoriteLink = "$server/favorite";
  static const String favoriteAdd = "$favoriteLink/add.php";
  static const String favoriteRemove = "$favoriteLink/remove.php";
  static const String favoriteView = "$favoriteLink/view.php";
  static const String deletefromFav = "$favoriteLink/deletefromfavroite.php";

  // ============================ Cart  Links ============================//
  static const String cartLink = "$server/cart";
  static const String cartview = "$cartLink/view.php";
  static const String cartadd = "$cartLink/add.php";
  static const String cartdelete = "$cartLink/delete.php";
  static const String cartUpdatQty = "$cartLink/getcountitems.php";

  // ============================ Address  Links ============================//
  static const String addressLink = "$server/address";
  static const String addressView = "$addressLink/view.php";
  static const String addressAdd = "$addressLink/add.php";
  static const String addressEdit = "$addressLink/edit.php";
  static const String addressDelete = "$addressLink/delete.php";

  // ============================ Coupon  Links ============================//
  static const String checkCoupon = "$server/coupon/checkcoupon.php";

  // ============================ Orders  Links ============================//
  static const String ordersLink = "$server/orders";
  static const String checkout = "$ordersLink/checkout.php";
  static const String ordersPending = "$ordersLink/pending.php";
  static const String ordersArchive = "$ordersLink/archive.php";
  static const String ordersDetails = "$ordersLink/details.php";
  static const String ordersDelete = "$ordersLink/delete.php";

  // ============================ Notification  Links ============================//
  static const String notificationLink = "$server";
  static const String notificatoin = "$notificationLink/notification.php";
}
