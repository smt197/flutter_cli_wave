import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cli/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Instance de Google Sign-In

  final _firebaseUser = Rxn<User>();
  User? get firebaseUser => _firebaseUser.value;

  final RxnString _userRole = RxnString();
  String? get userRole => _userRole.value;

  Future<AuthService> init() async {
    // Modifier le type de retour
    try {
      _auth.authStateChanges().listen((User? user) {
        _firebaseUser.value = user;
        if (user != null) {
          _syncWithFirestore(user);
          if (Get.currentRoute != Routes.HOME) {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          if (Get.currentRoute != Routes.AUTH) {
            Get.offAllNamed(Routes.AUTH);
          }
        }
      });

      return this; // Retourner l'instance de AuthService
    } catch (e) {
      print('Erreur dans AuthService.init(): $e');
      rethrow;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      return data?['role'];
    } catch (e) {
      print("Erreur lors de la récupération du rôle : $e");
      return null;
    }
  }

  // Synchroniser les données Firebase Auth avec Firestore
  Future<void> _syncWithFirestore(User user) async {
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        // Récupérer le rôle de l'utilisateur
        final data = doc.data();
        _userRole.value = data?['role'];
      } else {
        // Créer un document Firestore si inexistant
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName ?? '',
          'telephone': user.phoneNumber ?? '',
          'solde': 10000,
          'plafond': 200000,
          'role': 'CLIENT', // Par défaut
          'createdAt': FieldValue.serverTimestamp(),
        });
        _userRole.value = 'CLIENT';
      }
    } catch (e) {
      print("Erreur lors de la synchronisation avec Firestore: $e");
    }
  }

  // Connexion via Google Sign-In
  Future<User?> loginWithGoogle() async {
    try {
      // Déconnecter tout compte Google existant
      await _googleSignIn.signOut();

      // Afficher le sélecteur de compte
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Connexion annulée';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw 'Erreur lors de la connexion avec Google: $e';
    }
  }

  // Inscription avec email, mot de passe et nom
  Future<User?> register(String email, String password, String name) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajouter des informations utilisateur à Firestore
      await _firestore.collection('users').doc(result.user?.uid).set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<Map<String, dynamic>> signInWithPhoneAndCode(
      String telephone, String secretCode) async {
    try {
      // Rechercher l'utilisateur par numéro de téléphone
      final QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('telephone', isEqualTo: telephone)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Aucun utilisateur trouvé avec ce numéro de téléphone');
      }

      final userData = userQuery.docs.first.data() as Map<String, dynamic>;

      // Vérifier le code secret
      if (userData['secret_code'] != secretCode) {
        throw Exception('Code secret incorrect');
      }

      final User? existingUser = _auth.currentUser;

      if (existingUser == null) {
        // Si pas de connexion active, on pourrait implémenter une reconnexion Google
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw Exception('Connexion Google annulée');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return {
          'user': userCredential.user,
          'userData': userData,
        };
      }

      return {
        'user': existingUser,
        'userData': userData,
      };
    } catch (e) {
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Gérer les erreurs d'authentification
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'L\'adresse email est invalide.';
      case 'email-already-in-use':
        return 'Cette adresse email est déjà utilisée.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'network-request-failed':
        return 'Erreur réseau. Veuillez vérifier votre connexion internet.';
      default:
        return 'Une erreur est survenue: ${e.message}';
    }
  }
}
