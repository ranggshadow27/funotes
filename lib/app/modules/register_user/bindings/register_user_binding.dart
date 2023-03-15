import 'package:get/get.dart';

import '../controllers/register_user_controller.dart';

class RegisterUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterUserController>(
      () => RegisterUserController(),
    );
  }
}
