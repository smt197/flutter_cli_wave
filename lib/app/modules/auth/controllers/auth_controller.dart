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
      Get.offAllNamed('/home'); // Rediriger vers la page d'accueil après connexion
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
