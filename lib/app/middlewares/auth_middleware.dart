import 'package:flutter/material.dart';
import 'package:flutter_cli/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../data/services/authService.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Vérifier si l'utilisateur est connecté
    final authService = Get.find<AuthService>();
    
    if (authService.firebaseUser == null) {
      // Si non connecté, rediriger vers la page d'authentification
      return const RouteSettings(name: Routes.AUTH);
    }
    
    // Si connecté, permettre l'accès à la route demandée
    return null;
  }
}