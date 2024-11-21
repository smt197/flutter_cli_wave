import 'package:get/get.dart';

import '../../../data/services/transationService.dart';
import '../../home/controllers/home_controller.dart';

class TransactionController extends GetxController {
  final TransactionService transactionService = Get.put(TransactionService());

  void sendTransaction() {
    String receiver = transactionService.receiverController.text;
    String amount = transactionService.amountController.text;

    if (receiver.isEmpty || amount.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    transactionService.sendTransaction(onSuccess: () {
      Get.find<HomeController>()
          .fetchUserTransactions(); // Rafraîchir les transactions
    });
  }

  @override
  void onClose() {
    transactionService.receiverController.dispose();
    transactionService.amountController.dispose();
    super.onClose();
  }
}
