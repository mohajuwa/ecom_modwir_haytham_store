import 'dart:async';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/data/datasource/remote/auth/login.dart';
import 'package:ecom_modwir/view/widget/custom_title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/view/widget/primary_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecom_modwir/data/datasource/remote/auth/signup.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ecom_modwir/data/datasource/remote/address_data.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AuthService extends GetxController {
  final MyServices myServices = Get.find();
  final AddressData addressData = AddressData(Get.find());

  // Controllers for login/signup
  final SignupData signupData = SignupData(Get.find());
  final LoginData loginData = LoginData(Get.find());

  // Text controllers - initialized lazily
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Map controllers and properties
  Completer<GoogleMapController>? completercontroller;
  final List<Marker> markers = [];
  CameraPosition? cameraPosition;
  Position? position;

  // Address data
  double? latitude;
  double? longitude;
  String? address;
  String? city;
  String? street;

  // States
  final RxBool isLoading = false.obs;
  final RxBool isLoginMode = true.obs;
  final RxBool isLoginFor = true.obs;
  final RxBool isVerifying = false.obs;
  final RxBool needsAddress = false.obs;
  final RxBool editingInfo = false.obs;

  // Store the current context to handle dialog dismissal properly
  BuildContext? _dialogContext;

  // For storing the callback to execute after successful auth
  Function? onAuthSuccess;
  Timer? _loadingTimer;

  final int _loadingTimeoutSeconds = 15; // 15 second timeout

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _loadingTimer?.cancel();

    super.onClose();
  }

  void _startLoadingTimer() {
    _loadingTimer?.cancel();

    _loadingTimer = Timer(Duration(seconds: _loadingTimeoutSeconds), () {
      if (isLoading.value) {
        isLoading.value = false;
        showErrorSnackbar('error'.tr, 'request_timed_out'.tr);
      }
    });
  }

  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
  }

  // Reset state when showing auth dialog
  void _resetState() {
    isVerifying.value = false;
    needsAddress.value = false;
    editingInfo.value = false;
    isLoading.value = false;

    // Clear controllers
    phoneController.clear();
    firstNameController.clear();
    lastNameController.clear();
    otpController.clear();
  }

  // Show auth dialog with a callback for after completion
  void showAuthDialog(BuildContext context, {Function? onSuccess}) {
    _resetState();
    onAuthSuccess = onSuccess;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _dialogContext = dialogContext; // Store the context for later dismissal
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _dialogContext = null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (isVerifying.value) {
                      return _buildOtpVerification(dialogContext);
                    } else if (needsAddress.value) {
                      return _buildAddressCollection(dialogContext);
                    } else if (editingInfo.value && !isLoginMode.value) {
                      return _buildEditSignupInfo(dialogContext);
                    } else {
                      return isLoginMode.value
                          ? _buildLoginForm(dialogContext)
                          : _buildSignupForm(dialogContext);
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to dismiss dialog safely
  void _dismissDialog() {
    if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
      Navigator.pop(_dialogContext!);
      _dialogContext = null;
      // Clear the callback to prevent it from being used later
      onAuthSuccess = null;
    }
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'login_to_continue'.tr,
            style: MyTextStyle.styleBold(context),
          ),
        ),
        SizedBox(height: AppDimensions.largeSpacing),
        _buildPhoneField(context),
        SizedBox(height: AppDimensions.largeSpacing),
        Obx(() => PrimaryButton(
              text: 'login'.tr,
              onTap: () => _handleLoginSubmit(),
              isLoading: isLoading.value,
            )),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Center(
          child: TextButton(
            onPressed: toggleMode,
            child: Text(
              'new_user_register'.tr,
              style: MyTextStyle.meduimBold(context)
                  .copyWith(color: AppColor.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'create_account'.tr,
            style: MyTextStyle.styleBold(context),
          ),
        ),
        const SizedBox(height: 20),
        _buildNameFields(context),
        const SizedBox(height: AppDimensions.mediumSpacing),
        _buildPhoneField(context),
        SizedBox(height: AppDimensions.largeSpacing),
        Obx(() => PrimaryButton(
              text: 'sign_up'.tr,
              onTap: () => _handleSignupSubmit(),
              isLoading: isLoading.value,
            )),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Center(
          child: TextButton(
            onPressed: toggleMode,
            child: Text(
              'already_have_account'.tr,
              style: MyTextStyle.meduimBold(context)
                  .copyWith(color: AppColor.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerification(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'verify_phone'.tr,
            style: MyTextStyle.styleBold(context),
          ),
        ),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Text(
          '${'code_sent_to'.tr} ${phoneController.text}',
          style: MyTextStyle.meduimBold(context),
        ),
        SizedBox(height: AppDimensions.largeSpacing),
        _buildOtpField(context),
        SizedBox(height: AppDimensions.largeSpacing),
        Obx(() => PrimaryButton(
              text: 'verify'.tr,
              onTap: () => _verifyOtp(),
              isLoading: isLoading.value,
            )),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _resendCode,
              child: Text(
                'resend_code'.tr,
                style: MyTextStyle.meduimBold(context)
                    .copyWith(color: AppColor.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                editingInfo.value = true;
                isLoginMode.value = true;
                isVerifying.value = false;
              },
              child: Text(
                'edit_info'.tr,
                style: MyTextStyle.meduimBold(context)
                    .copyWith(color: AppColor.primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditSignupInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'edit_information'.tr,
            style: MyTextStyle.styleBold(context),
          ),
        ),
        const SizedBox(height: 20),
        _buildNameFields(context),
        const SizedBox(height: AppDimensions.mediumSpacing),
        _buildPhoneField(context),
        SizedBox(height: AppDimensions.largeSpacing),
        Obx(() => PrimaryButton(
              text: 'update_info'.tr,
              onTap: () => _updateSignupInfo(),
              isLoading: isLoading.value,
            )),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Center(
          child: TextButton(
            onPressed: () {
              editingInfo.value = false;
              isVerifying.value = true;
            },
            child: Text(
              'back_to_verification'.tr,
              style: MyTextStyle.meduimBold(context)
                  .copyWith(color: AppColor.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCollection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'add_delivery_address'.tr,
            style: MyTextStyle.styleBold(context),
          ),
        ),
        const SizedBox(height: AppDimensions.mediumSpacing),
        Text(
          'we_need_your_address'.tr,
          style: MyTextStyle.meduimBold(context),
        ),
        const SizedBox(height: 20),
        if (address != null && address!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'current_location'.tr,
                  style: MyTextStyle.smallBold(context),
                ),
                const SizedBox(height: 4),
                Text(
                  address!,
                  style: MyTextStyle.meduimBold(context),
                ),
                if (latitude != null && longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Lat: ${latitude!.toStringAsFixed(6)}, Long: ${longitude!.toStringAsFixed(6)}',
                      style: MyTextStyle.smallBold(context),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: AppDimensions.largeSpacing),
        Obx(() => PrimaryButton(
              text: 'use_my_location'.tr,
              onTap: () => _getCurrentLocation(),
              isLoading: isLoading.value,
            )),
        const SizedBox(height: AppDimensions.mediumSpacing),
        OutlinedButton(
          onPressed: () => _showManualAddressDialog(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            side: BorderSide(color: AppColor.primaryColor),
          ),
          child: Text(
            'enter_manually'.tr,
            style: MyTextStyle.meduimBold(context)
                .copyWith(color: AppColor.primaryColor),
          ),
        ),
        if (address != null && address!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: PrimaryButton(
              text: 'continue'.tr,
              onTap: () => _finalizeAuth(),
            ),
          ),
      ],
    );
  }

  Widget _buildNameFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'first_name'.tr,
                subTitle: true,
              ),
              SizedBox(height: AppDimensions.smallSpacing),
              Container(
                height: AppDimensions.inputHeight,
                decoration: AppDecorations.inputContainer,
                child: TextField(
                  controller: firstNameController,
                  style: MyTextStyle.meduimBold(context),
                  decoration: InputDecoration(
                    hintText: 'first_name'.tr,
                    hintStyle: MyTextStyle.bigCapiton(context),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'last_name'.tr,
                subTitle: true,
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              Container(
                height: AppDimensions.inputHeight,
                decoration: AppDecorations.inputContainer,
                child: TextField(
                  controller: lastNameController,
                  style: MyTextStyle.meduimBold(context),
                  decoration: InputDecoration(
                    hintText: 'last_name'.tr,
                    hintStyle: MyTextStyle.bigCapiton(context),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'phone_number'.tr,
          subTitle: true,
        ),
        const SizedBox(height: AppDimensions.smallSpacing),
        Container(
          height: AppDimensions.inputHeight,
          decoration: AppDecorations.inputContainer,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: MyTextStyle.meduimBold(context),
                  decoration: InputDecoration(
                    hintText: '5XXXXXXXX',
                    hintStyle: MyTextStyle.bigCapiton(context),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'verification_code'.tr,
          style: MyTextStyle.meduimBold(context).copyWith(fontSize: 18),
        ),
        const SizedBox(height: AppDimensions.smallSpacing),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              controller: otpController,
              autoDisposeControllers: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              enableActiveFill: true,
              cursorColor: AppColor.primaryColor,
              textStyle: MyTextStyle.meduimBold(context).copyWith(fontSize: 20),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                fieldHeight: 60,
                fieldWidth: 50,
                activeFillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                inactiveFillColor: Colors.grey.shade100,
                selectedFillColor:
                    theme.colorScheme.onPrimary.withOpacity(0.05),
                activeColor: AppColor.primaryColor,
                selectedColor: AppColor.primaryColor,
                inactiveColor: Colors.grey,
              ),
              onChanged: (_) {},
              onCompleted: (code) {
                // you can auto‑verify here:
                // _verifyOtp();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleLoginSubmit() async {
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      showErrorSnackbar('error'.tr, 'please_enter_valid_phone'.tr);
      return;
    }

    isLoading.value = true;
    _startLoadingTimer();

    try {
      var response = await loginData.postData(phoneController.text);

      if (response['status'] == "success") {
        try {
          loginData.sendWhatsAppVerification(
              loginData.formatPhoneForWhatsApp(response['data']['phone']));
        } catch (e) {
          return;
        }
        myServices.sharedPreferences.setString("step", "2");
        myServices.sharedPreferences
            .setString("userId", response['data']['user_id'].toString());
        String userId = myServices.sharedPreferences.getString("userId")!;
        myServices.sharedPreferences
            .setString("username", response['data']['full_name'].toString());
        myServices.sharedPreferences
            .setString("phone", response['data']['phone'].toString());

        isLoginFor.value = true;
        isVerifying.value = true;

        FirebaseMessaging.instance.subscribeToTopic("users");
        FirebaseMessaging.instance.subscribeToTopic("users${userId}");
      } else {
        showErrorSnackbar('error'.tr, 'login_failed'.tr);
      }
    } catch (e) {
      showErrorSnackbar('error'.tr, 'failed_to_send_code'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  void _handleSignupSubmit() async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      showErrorSnackbar('error'.tr, 'please_enter_your_name'.tr);
      return;
    }

    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      showErrorSnackbar('error'.tr, 'please_enter_valid_phone'.tr);
      return;
    }

    isLoading.value = true;
    _startLoadingTimer();

    try {
      var response = await signupData.postData(
          "${firstNameController.text} ${lastNameController.text}",
          phoneController.text);

      if (response['status'] == "success") {
        myServices.sharedPreferences
            .setString("userId", response['data']['user_id'].toString());
        isLoginFor.value = false;
        isVerifying.value = true;
      } else {
        Get.defaultDialog(
            title: "warning".tr, middleText: "phone_number_already_exist".tr);
      }
    } catch (e) {
      showErrorSnackbar('error'.tr, 'failed_to_register'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  void _updateSignupInfo() async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      showErrorSnackbar('error'.tr, 'please_enter_your_name'.tr);
      return;
    }

    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      showErrorSnackbar('error'.tr, 'please_enter_valid_phone'.tr);
      return;
    }

    isLoading.value = true;
    _startLoadingTimer();

    try {
      var response = await signupData.postData(
          "${firstNameController.text} ${lastNameController.text}",
          phoneController.text);

      if (response['status'] == "success") {
        editingInfo.value = false;
        isVerifying.value = true;
        showSuccessSnackbar('success'.tr, 'information_updated'.tr);
      } else {
        Get.defaultDialog(
            title: "warning".tr, middleText: "phone_number_already_exist".tr);
      }
    } catch (e) {
      showErrorSnackbar('error'.tr, 'failed_to_update_info'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  void _verifyOtp() async {
    if (otpController.text.isEmpty || otpController.text.length < 4) {
      showErrorSnackbar('error'.tr, 'please_enter_valid_code'.tr);
      return;
    }

    isLoading.value = true;
    _startLoadingTimer();

    try {
      var response;

      if (isLoginFor.value) {
        response = await signupData.loginWithOtp(
            otpController.text, phoneController.text);
      } else {
        response = await signupData.getVerfiyCode(
            otpController.text, phoneController.text);
      }

      if (response['status'] == "success") {
        // Get location automatically after OTP verification
        await _getCurrentLocation();

        if (isLoginMode.value) {
          // Check if user has address using the existing method
          bool hasAddress = await _checkIfUserHasAddress();

          if (!hasAddress) {
            // User doesn't have an address, show address screen
            needsAddress.value = true;
            isVerifying.value = false;
          } else {
            // User has address, set login state and finalize
            await myServices.sharedPreferences.setBool("isLogin", true);
            _finalizeAuth();
          }
        } else {
          // For signup, always show address screen
          needsAddress.value = true;
          isVerifying.value = false;
        }
      } else {
        Get.defaultDialog(
            title: "warning".tr, middleText: "verfiy_code_not_match".tr);
      }
    } catch (e) {
      showErrorSnackbar('error'.tr, 'invalid_verification_code'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    isLoading.value = true;
    _startLoadingTimer();

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorSnackbar('error'.tr, 'location_permission_denied'.tr);
        return;
      }

      // Get current position
      position = await Geolocator.getCurrentPosition();
      latitude = position!.latitude;
      longitude = position!.longitude;

      // Create camera position
      cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 12.4746,
      );

      // Add marker
      addMarkers(LatLng(position!.latitude, position!.longitude));

      // Get address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        city = place.locality;
        street = place.street;
        address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      } else {
        address = 'location_found'.tr;
      }

      update();
    } catch (e) {
      showErrorSnackbar('error'.tr, 'failed_to_get_location'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  void addMarkers(LatLng latLng) {
    markers.clear();
    markers.add(Marker(markerId: const MarkerId("1"), position: latLng));
    latitude = latLng.latitude;
    longitude = latLng.longitude;
    update();
  }

  void _showManualAddressDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController streetController = TextEditingController();

    // Pre-fill with existing values if available
    if (city != null) cityController.text = city!;
    if (street != null) streetController.text = street!;
    if (address != null) addressController.text = address!;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'enter_address'.tr,
                style: MyTextStyle.styleBold(context),
              ),
              const SizedBox(height: AppDimensions.mediumSpacing),

              // City field
              Text(
                'city'.tr,
                style: MyTextStyle.meduimBold(context),
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'city_hint'.tr,
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.smallSpacing),

              // Street field
              Text(
                'street'.tr,
                style: MyTextStyle.meduimBold(context),
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                    hintText: 'street_hint'.tr,
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.smallSpacing),

              // Full address field
              Text('full_address'.tr, style: MyTextStyle.meduimBold(context)),
              const SizedBox(height: AppDimensions.smallSpacing),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'address_hint'.tr,
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.largeSpacing),

              PrimaryButton(
                text: 'save'.tr,
                onTap: () {
                  if (addressController.text.isNotEmpty &&
                      cityController.text.isNotEmpty &&
                      streetController.text.isNotEmpty) {
                    city = cityController.text;
                    street = streetController.text;
                    address = addressController.text;
                    // Default lat/long for manual entry if not already set
                    latitude = latitude ?? 0.0;
                    longitude = longitude ?? 0.0;
                    update();

                    Get.back();
                  } else {
                    showErrorSnackbar('error'.tr, 'please_complete_address'.tr);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _checkIfUserHasAddress() async {
    String userId = myServices.sharedPreferences.getString("userId") ?? "";
    if (userId.isEmpty) return false;

    try {
      var response = await addressData.getData(userId);

      if (response['status'] == "success" && response['data'] != null) {
        // Check if data is a list and has items
        if (response['data'] is List && (response['data'] as List).isNotEmpty) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print("Error checking user address: $e");
      return false;
    }
  }

  void _resendCode() async {
    isLoading.value = true;
    _startLoadingTimer();

    try {
      // Call your resend code API here
      if (isLoginFor.value) {
        await loginData.postData(phoneController.text);
      } else {
        await signupData.postData(
            "${firstNameController.text} ${lastNameController.text}",
            phoneController.text);
      }

      showSuccessSnackbar('success'.tr, 'code_resent_successfully'.tr);
    } catch (e) {
      showErrorSnackbar('error'.tr, 'failed_to_resend_code'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }

  void _finalizeAuth() async {
    isLoading.value = true;
    _startLoadingTimer();

    try {
      // Set login flag first
      await myServices.sharedPreferences.setBool("isLogin", true);

      // Only save address if we have one
      if (address != null && address!.isNotEmpty) {
        String userId = myServices.sharedPreferences.getString("userId") ?? "";

        if (userId.isNotEmpty) {
          var addressName = "home";

          // Save address to backend
          var response = await addressData.addData(
              userId,
              addressName,
              city ?? "",
              street ?? "",
              latitude.toString(),
              longitude.toString());

          if (response['status'] == "success") {
            // Cache address locally
            myServices.sharedPreferences.setString("userAddress", address!);
            myServices.sharedPreferences
                .setString("userLat", latitude.toString());
            myServices.sharedPreferences
                .setString("userLng", longitude.toString());
          } else {
            showErrorSnackbar('warning'.tr, 'failed_to_save_address'.tr);
          }
        }
      }

      // Execute callback if provided
      if (onAuthSuccess != null) {
        // Add a small delay to ensure SharedPreferences has time to persist
        await Future.delayed(Duration(milliseconds: 100));

        // Create a local reference to the callback before clearing it
        final callback = onAuthSuccess;
        onAuthSuccess = null;

        // Call the callback
        callback!();
      }

      // Close dialog and show success message
      _dismissDialog();
      showSuccessSnackbar('success'.tr, 'login_successful'.tr);
    } catch (e) {
      showErrorSnackbar('error'.tr, 'authentication_failed'.tr);
    } finally {
      _loadingTimer?.cancel();
      isLoading.value = false;
    }
  }
}
