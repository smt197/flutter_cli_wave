import 'package:get/get.dart';

import '../../../data/services/transationService.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut(()=>TransactionService());
  }
}
