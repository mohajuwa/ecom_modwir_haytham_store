class AppLink {
  // ============================ Server Link  Links ============================//

  static const String server = "https://modwir.com/haytham_store";
  // static const String server = "http://192.168.167.187/haytham_store";

// ============================ Images Links  Links ============================//
  static const String unifonicLink =
      "https://el.cloud.unifonic.com/rest/SMS/messages";

  static const String imageStatic = "$server/upload";
  static const String imageCategories = "$imageStatic/categories";
  static const String vehiclesImgLink = "$imageStatic/vehicles";
  static const String offerImgLink = "$imageStatic/offers";
  static const String carMakeLogo = "$imageStatic/cars";

// ============================ Auth  Links ============================//
  static const String authLink = "$server/auth";

  static const String signUp = "$authLink/signup.php";
  static const String verfiyCodeSignUp = "$authLink/verfiycode.php";
  static const String resendverfiyCode = "$authLink/resend.php";
  static const String login = "$authLink/login.php";

  // ============================ Home  Links ============================//
  static const String homeLink = server;
  static const String homePage = "$homeLink/home.php";
  static const String offers = "$homeLink/offers.php";
  static const String homeOffers = "$homeLink/offers.php";

  // ============================ Services  Links ============================//
  static const String linkServices = "$server/services";
  static const String searchitems = "$linkServices/search.php";
  static const String serviceDisplay = "$linkServices/services_display.php";
  static const String subserviceDisplay =
      "$linkServices/sub_services_display.php";
  static const String faultType = "$linkServices/fault_type.php";

  // ============================ Cars  Links ============================//
  static const String carsMakeLink = "$server/cars";
  static const String carsMakeDisplay = "$carsMakeLink/view.php";
  static const String updateVehicleWithLang =
      "$carsMakeLink/updateWithLang.php";
  static const String createVehicle = "$carsMakeLink/create.php";

  static const String updateVehicle = "$carsMakeLink/update.php";
  static const String getVehicleEssentials = "$carsMakeLink/view.php";
  // ============================ Vehicles  Links ============================//
  static const String vehiclesLink = "$server/vehicles";
  static const String vehicleAdd = "$vehiclesLink/add.php";
  static const String vehicleUpdate = "$vehiclesLink/update.php";
  static const String vehicleRemove = "$vehiclesLink/remove.php";
  static const String vehicleView = "$vehiclesLink/view.php";
  static const String deleteFromVe = "$vehiclesLink/delete_from_vehicles.php";

  // ============================ Product By Car Links ============================//
  static const String productByCar = "$carsMakeLink/product_by_car.php";

  // ============================ Address  Links ============================//
  static const String addressLink = "$server/address";
  static const String addressView = "$addressLink/view.php";
  static const String addressAdd = "$addressLink/add.php";
  static const String addressEdit = "$addressLink/edit.php";
  static const String addressStatus = "$addressLink/status.php";

  // ============================ Coupon  Links ============================//
  static const String checkCoupon = "$server/coupon/checkcoupon.php";

  // ============================ Orders  Links ============================//
  static const String ordersLink = "$server/orders";
  static const String checkout = "$ordersLink/checkout.php";
  static const String pendingOrders = "$ordersLink/pending.php";
  static const String archiveOrders = "$ordersLink/archive.php";
  static const String detailsOrders = "$ordersLink/details.php";
  static const String orderDetailsView = "$ordersLink/details.php";
  static const String deleteOrder = "$ordersLink/delete.php";
  static const String cancelOrder = "$ordersLink/cancel.php";
  static const String attachmentsUpload =
      "$ordersLink/save_attachment_files.php";

  // ============================ Orders Rating Links ============================//
  static const String ratingLink = server;
  static const String rating = "$ratingLink/rating.php";

  // ============================ Notification  Links ============================//
  static const String notificationLink = "$server/notifications";
  static const String notificatoin = "$notificationLink/notification.php";
  static const String markNotiRead = "$notificationLink/mark_read.php";
  static const String markAllNotiRead = "$notificationLink/mark_all_read.php";

  static const String processPayment = "$server/payments";
}
