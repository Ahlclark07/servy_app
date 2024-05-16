class AppText {
  static const String titre = "Servy";
}

class IntroText {
  static const String titre_1 = "Experts";
  static const String description_1 =
      "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.";
  static const String titre_2 = "Services";
  static const String description_2 =
      "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.";
  static const String titre_3 = "Statisfactions";
  static const String description_3 =
      "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.";
  static const String actionpasser = "Passer l'intro";
}

class InscriptionText {
  static const String titre = "Inscription";
  static const String labelTitleEmail = "Email";
  static const String labelDescEmail = "Entrez votre adresse mail";
  static const String labelTitleMdp = "Mot de passe";
  static const String labelDescMdp = "Entrez votre mot de passe";
  static const String labelTitleMdp2 = "Confirmez votre mot de passe";
  static const String labelDescMdp2 = "Entrez le même mot de passe";
  static const String actionButton = "S'inscrire";
  static const String conditions =
      "J'accepte les conditions générales et la politique de confidentialité";
  static const String haveAccount = "Avez vous un compte ?";
  static const String actionTextButton = "Se connecter";
}

class ConnexionText {
  static const String titre = "Connexion";
  static const String labelTitleEmail = "Email";
  static const String labelDescEmail = "Entrez votre adresse mail";
  static const String labelTitleMdp = "Mot de passe";
  static const String labelDescMdp = "Entrez votre mot de passe";
  static const String haveAccount = "Vous n'avez pas un compte ?";
  static const String actionButton = "Se connecter";
  static const String actionTextButton = "S'inscrire";
}

class AuthErrorText {
  static const String weakPassword = "Votre mot de passe est trop faible";
  static const String emailAlreadyUsed =
      "Votre adresse email a déjà été utilisée";
  static const String userNotFound =
      "Aucun utilisateur trouvé avec ces identifiants";
  static const String incorrectPassword = "Votre mot de passe est incorrect.";
}

class FrLanguageData {
  static const String titre = "Servy";

  static const Map<String, String> contenuPageIntro = {
    "titre_1": "Experts",
    "description_1":
        "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.",
    "titre_2": "Services",
    "description_2":
        "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.",
    "titre_3": "Statisfactions",
    "description_3":
        "Ajebuta allows you to access a wide range of everyday people offering services you are constantly in need of.",
    "actionpasser": "Passer l'intro",
  };

  static const Map<String, String> contenuPageInscription = {
    "titre": "Inscription",
    "labelTitleEmail": "Email",
    "labelDescEmail": "Entrez votre adresse mail",
    "labelTitleMdp": "Mot de passe",
    "labelDescMdp": "Entrez votre mot de passe",
    "labelTitleMdp2": "Confirmez votre mot de passe",
    "labelDescMdp2": "Entrez le même mot de passe",
    "actionButton": "S'inscrire",
    "conditions":
        "J'accepte les conditions générales et la politique de confidentialité",
    "haveAccount": "Avez vous un compte ?",
    "actionTextButton": "Se connecter",
  };

  static const Map<String, String> contenuPageConnexion = {
    "titre": "Connexion",
    "labelTitleEmail": "Email",
    "labelDescEmail": "Entrez votre adresse mail",
    "labelTitleMdp": "Mot de passe",
    "labelDescMdp": "Entrez votre mot de passe",
    "haveAccount": "Vous n'avez pas un compte ?",
    "actionButton": "Se connecter",
    "actionTextButton": "S'inscrire",
  };

  static const Map<String, String> contenuAuthError = {
    "weakPassword": "Votre mot de passe est trop faible",
    "emailAlreadyUsed": "Votre adresse email a déjà été utilisée",
    "userNotFound": "Aucun utilisateur trouvé avec ces identifiants",
    "incorrectPassword": "Votre mot de passe est incorrect.",
  };
}
