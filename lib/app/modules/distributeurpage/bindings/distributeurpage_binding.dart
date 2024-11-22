import 'package:get/get.dart';

import '../controllers/distributeurpage_controller.dart';

class DistributeurpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DistributeurpageController>(
      () => DistributeurpageController(),
    );
  }
}
