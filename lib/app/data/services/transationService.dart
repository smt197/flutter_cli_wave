import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionService extends GetxController {
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendTransaction() async {
    String receiver = receiverController.text;
    String amount = amountController.text;

    if (receiver.isEmpty || amount.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Récupérer l'ID de l'utilisateur connecté
      String currentUserID = _auth.currentUser!.uid;

      // Vérifier que le destinataire existe dans la base de données
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _firestore
          .collection('users')
          .where('telephone', isEqualTo: receiver)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        Get.snackbar(
          'Erreur',
          'Le destinataire n\'existe pas dans la base de données',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Récupérer le document du destinataire
      DocumentSnapshot<Map<String, dynamic>> receiverSnapshot =
          usersSnapshot.docs.first;
      String receiverID = receiverSnapshot.id;
      double receiverBalance =
          receiverSnapshot.data()!['solde']?.toDouble() ?? 0.0;
      double senderBalance =
          (await _firestore.collection('users').doc(currentUserID).get())
                  .data()!['solde']
                  ?.toDouble() ??
              0.0;

      // Vérifier si le solde du sender est suffisant
      double transactionAmount = double.parse(amount);
      if (senderBalance < transactionAmount) {
        Get.snackbar(
          'Erreur',
          'Votre solde est insuffisant pour effectuer cette transaction',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Mettre à jour les soldes
      await _firestore
          .collection('users')
          .doc(currentUserID)
          .update({'solde': senderBalance - transactionAmount});
      await _firestore
          .collection('users')
          .doc(receiverID)
          .update({'solde': receiverBalance + transactionAmount});

      // Enregistrer la transaction dans la base de données
      await _firestore.collection('transactions').add({
        'sender': currentUserID,
        'receiver': receiverID,
        'amount': transactionAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Succès',
        'Transaction envoyée à $receiver pour $amount FCFA',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Réinitialiser les champs de saisie
      receiverController.clear();
      amountController.clear();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors de l\'envoi de la transaction',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Erreur lors de l\'envoi de la transaction: $e');
    }
  }

  Future<double> getUserBalance() async {
    try {
      String currentUserID = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(currentUserID).get();

      return userSnapshot.data()?['solde']?.toDouble() ?? 0.0;
    } catch (e) {
      print('Erreur lors de la récupération du solde: $e');
      return 0.0;
    }
  }

  @override
  void onClose() {
    receiverController.dispose();
    amountController.dispose();
    super.onClose();
  }

  
}
