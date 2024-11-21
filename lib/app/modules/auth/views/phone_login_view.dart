import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class PhoneLoginView extends GetView<AuthController> {
  const PhoneLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion avec un numéro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ numéro de téléphone
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Champ mot de passe
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Bouton de connexion
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          final phone = phoneController.text.trim();
                          final password = passwordController.text.trim();

                          if (phone.isNotEmpty && password.isNotEmpty) {
                            controller.signInWithPhoneAndCode(phone, password);
                          } else {
                            Get.snackbar(
                              'Erreur',
                              'Veuillez remplir tous les champs.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Se connecter'),
                ))
          ],
        ),
      ),
    );
  }
}
