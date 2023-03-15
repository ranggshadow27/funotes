import 'package:get/get.dart';

import '../controllers/input_page_controller.dart';

class InputPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputPageController>(
      () => InputPageController(),
    );
  }
}
