import 'package:get/get.dart';

import '../../../data/services/transationService.dart';

class HomeController extends GetxController {
  final TransactionService _transactionService = Get.find<TransactionService>();
  final RxDouble balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBalance();
  }

  Future<void> fetchUserBalance() async {
    try {
      balance.value = await _transactionService.getUserBalance();
    } catch (e) {
      print('Erreur lors de la récupération du solde: $e');
      balance.value = 0.0;
    }
  }
}
