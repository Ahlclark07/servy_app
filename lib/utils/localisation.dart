import 'package:servy_app/static_test/fr.dart';

class LocalisationHelper {
  String lang;

  LocalisationHelper({required String this.lang});

  get getLangData => lang == "fr" ? FrLanguageData() : null;
}
