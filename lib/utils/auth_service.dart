import 'package:firebase_auth/firebase_auth.dart';
import 'package:servy_app/static_test/fr.dart';

class AuthService {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  Future<String?> get token async => currentUser?.getIdToken();
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthErrorText.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return AuthErrorText.emailAlreadyUsed;
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthErrorText.userNotFound;
      } else if (e.code == 'wrong-password') {
        return AuthErrorText.incorrectPassword;
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Un e-mail de réinitialisation de mot de passe a été envoyé à $email';
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs spécifiques à Firebase Auth
      return 'Erreur lors de la réinitialisation du mot de passe : ${e.message}';
    } catch (e) {
      // Gérer les erreurs générales
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
