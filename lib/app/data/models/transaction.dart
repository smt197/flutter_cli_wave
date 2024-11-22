import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseTime(dynamic date) {
  return Platform.isAndroid ? (date as Timestamp).toDate() : (date as DateTime);
}


class Transaction {
  final String id;
  final String sender;
  final String receiver;
  final double amount;
  final String status;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  // Méthode pour convertir une Map en Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      status: map['status']?? 'completed',
      timestamp: parseTime(map['timestamp']), // Utilisation de parseTime pour gérer la conversion
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'amount': amount,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
