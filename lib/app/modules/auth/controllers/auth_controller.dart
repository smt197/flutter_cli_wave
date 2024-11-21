import 'package:flutter_cli/app/data/services/authService.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService.to;
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;
      error.value = '';
      await _authService.loginWithGoogle();
      Get.offAllNamed(
          '/home'); // Rediriger vers la page d'accueil après connexion
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithPhoneAndCode(
      String telephone, String secretCode) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Appeler la méthode de l'AuthService
      Map<String, dynamic> result =
          await _authService.signInWithPhoneAndCode(telephone, secretCode);

      // Vérifications supplémentaires si nécessaire
      if (result['user'] == null) {
        throw Exception('Échec de la connexion');
      }

      // Rediriger vers la page d'accueil
      Get.offAllNamed('/home');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur de connexion',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
