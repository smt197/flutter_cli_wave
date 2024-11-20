import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseTime(dynamic date) {
  return Platform.isAndroid ? (date as Timestamp).toDate() : (date as DateTime);
}


class Transaction {
  final String sender;
  final String receiver;
  final double amount;
  final DateTime timestamp;

  Transaction({
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.timestamp,
  });

  // Méthode pour convertir une Map en Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      timestamp: parseTime(map['timestamp']), // Utilisation de parseTime pour gérer la conversion
    );
  }
}

class JsonSerializable {
  const JsonSerializable();
}
