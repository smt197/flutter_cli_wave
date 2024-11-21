import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child:
                  Icon(Icons.person, color: Colors.orange.shade700, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Send Money',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Solde Disponible',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Text(
                              '${controller.balance.value.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Services fréquents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildServiceButton(
                          icon: Icons.send,
                          label: 'Envoi\nd\'argent',
                          color: Colors.orange.shade600,
                          onPressed: () {
                            Get.toNamed(
                                '/transaction'); // Navigation vers la vue Transaction
                          },
                        ),
                        _buildServiceButton(
                          icon: Icons.account_balance_wallet,
                          label: 'Retrait\nd\'argent',
                          color: Colors.blue.shade600,
                        ),
                        _buildServiceButton(
                          icon: Icons.payment,
                          label: 'Paiement\nfacture',
                          color: Colors.purple.shade600,
                        ),
                        _buildServiceButton(
                          icon: Icons.phone_android,
                          label: 'Forfait\nmobile',
                          color: Colors.green.shade600,
                        ),
                        _buildServiceButton(
                          icon: Icons.qr_code_scanner,
                          label: 'Scanner\nQR Code',
                          color: Colors.red.shade600,
                        ),
                        _buildServiceButton(
                          icon: Icons.more_horiz,
                          label: 'Plus de\nservices',
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Liste transactions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Ajoutez une action pour "Voir tout"
                              },
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Obx(() {
                          if (controller.transactions.isEmpty) {
                            return const Center(
                              child: Text(
                                'Aucune transaction disponible.',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.transactions.length,
                            itemBuilder: (context, index) {
                              var transaction = controller.transactions[index];

                              // Utilisez DateFormat pour formater le timestamp
                              String formattedDate =
                                  DateFormat('dd MMM yyyy, HH:mm')
                                      .format(transaction.timestamp);

                              return ListTile(
                                leading: Icon(
                                  transaction.sender ==
                                          controller.transactions[index].sender
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: transaction.sender ==
                                          controller.transactions[index].sender
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                title: Text(
                                  transaction.receiver ==
                                          controller
                                              .transactions[index].receiver
                                      ? 'Envoyé à ${transaction.receiver}'
                                      : 'Reçu de ${transaction.sender}',
                                ),
                                subtitle: Text(
                                  formattedDate, // Affichez la date formatée ici
                                ),
                                trailing: Text(
                                  '${transaction.amount.toStringAsFixed(0)} FCFA',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            // The logout item is at index 2
            controller.logout();
            Get.offAllNamed(
                '/login'); // Navigate to login and remove all previous routes
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Déconnexion',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
