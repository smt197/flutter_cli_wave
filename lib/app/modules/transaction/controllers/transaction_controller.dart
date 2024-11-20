import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/transationService.dart';

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

    transactionService.sendTransaction();
  }

  @override
  void onClose() {
    transactionService.receiverController.dispose();
    transactionService.amountController.dispose();
    super.onClose();
  }
}