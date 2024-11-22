import 'package:flutter_cli/app/data/models/transaction.dart';
import 'package:get/get.dart';
import '../../../data/services/transationService.dart';
import '../../../data/services/authService.dart';

class HomeController extends GetxController {
  final TransactionService _transactionService = Get.find<TransactionService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxDouble balance = 0.0.obs;
  var transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBalance();
    fetchUserTransactions();
  }

  Future<void> fetchUserBalance() async {
    try {
      balance.value = await _transactionService.getUserBalance();
    } catch (e) {
      print('Erreur lors de la récupération du solde: $e');
      balance.value = 0.0;
    }
  }

  Future<void> fetchUserTransactions() async {
    try {
      // Récupérer les transactions de l'utilisateur via le service
      List<Map<String, dynamic>> rawData =
          await _transactionService.getUserTransactions();

      // Mapper les données brutes en objets Transaction
      transactions.value =
          rawData.map((data) => Transaction.fromMap(data)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des transactions: $e');
      transactions.value = [];
    }
  }

  Future<void> cancelTransaction(String transactionId) async {
    try {
      await _transactionService.cancelTransaction(transactionId);

      // Mettre à jour la liste des transactions après annulation
      await fetchUserTransactions();
      await fetchUserBalance();

      Get.snackbar(
        'Succès',
        'Transaction annulée avec succès',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de l\'annulation',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Erreur lors de l\'annulation: $e');
    }
  }

  void logout() {
    _authService.logout();
  }
}
