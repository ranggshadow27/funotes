import 'package:get/get.dart';

import '../controllers/all_details_controller.dart';

class AllDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllDetailsController>(
      () => AllDetailsController(),
    );
  }
}
