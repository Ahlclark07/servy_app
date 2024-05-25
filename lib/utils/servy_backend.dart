import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:uno/uno.dart';

class ServyBackend {
  static late final ServyBackend _instance;
  static String baseURL = "https://viensfaireducash.com";
  // static String baseURL = "http://192.168.1.103:300";
  static String basePhotodeProfilURL = "$baseURL/uploads/images/photodeprofils";
  static String basePhotodeServicesPrestataires =
      "$baseURL/uploads/images/servicesprestataires";
  static String basePhotodeMateriau = "$baseURL/uploads/images/materiaux";
  static String baseAudio = "$baseURL/uploads/audios/servicesprestataires";
  static const String echec = "echec";
  static const String success = "success";
  bool enTransition = false;
  Map<String, dynamic> user = {};
  Uno uno = Uno(
    baseURL: baseURL,
  );
  ServyBackend._internal() {
    _initBackend();
  }

  factory ServyBackend() {
    return _instance;
  }

  static void initialize() async {
    _instance = ServyBackend._internal();
  }

  Future<void> _initBackend() async {
    try {
      final token = await AuthService().currentUser?.getIdToken();
      if (token != null) {
        _instance.uno = Uno(
          baseURL: baseURL,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        );
        await userExist();
      } else {
        _instance.uno = Uno(
          baseURL: baseURL,
        );
      }
    } catch (e) {
      print("Erreur lors de l'initialisation du backend : $e");
    }
  }

  Future<String> userExist() async {
    try {
      await setUnoHeader();
      if (user.isEmpty) {
        final response = await uno.get("/users/getUser");
        user = response.data["user"];
      }

      return ServyBackend.success;
    } on UnoError catch (error) {
      return "${error.response?.status} ${error.message}";
    }
  }

  Future<void> setUnoHeader() async {
    if (uno.headers.isEmpty) {
      final token = await AuthService().currentUser?.getIdToken();
      if (token != null) {
        _instance.uno = Uno(
          baseURL: baseURL,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        );
      }
    }
  }

  Future<String> remplirProfil(
      {required String nom,
      required String prenoms,
      required String departement,
      required String ville,
      required String date,
      required String quartier,
      required Position pos,
      required String telephone}) async {
    final Map<String, String?> data = {
      "nom": nom,
      "prenoms": prenoms,
      "email": AuthService().currentUser?.email,
      "telephone": telephone,
      "dateDeNaissance": date,
      "departement": departement,
      "ville": ville,
      "quartier": quartier,
      "informations": "informations",
      "localisationMap": "${pos.longitude} | ${pos.latitude}",
    };
    final formData = FormData();
    data.forEach((key, value) {
      formData.add(key, value);
    });

    try {
      await uno.post("/users/becomeClient",
          data: formData, responseType: ResponseType.arraybuffer);

      await FirebaseChatCore.instance.createUserInFirestore(types.User(
          id: AuthService().currentUser!.uid,
          firstName: prenoms,
          lastName: nom));

      return ServyBackend.success;
    } on UnoError catch (error) {
      inspect(error);
      return "${ServyBackend.echec} : ${error.message}";
    }
  }

  Future<String> becomeSeller(
      {required File carte,
      required File photo,
      required String profession}) async {
    try {
      final formData = FormData();
      formData.addFile("photodeprofil", photo.path);
      formData.add("profession", profession);
      formData.addFile("carteidentite", carte.path);
      await uno.post("/users/becomeSeller", data: formData);
      enTransition = true;
      await rafraichir();
      return ServyBackend.success;
    } on UnoError catch (error) {
      return "${ServyBackend.echec} : ${error.message}";
    }
  }

  Future<List<String>> createMateriel(
      {required File photo,
      required String nom,
      required String prix,
      required String minidesc}) async {
    try {
      final formData = FormData();
      formData.addFile("image", photo.path);
      formData.add("nom", nom);
      formData.add("prix", prix);
      formData.add("miniDescription", minidesc);
      final response = await uno.post("/users/materiel", data: formData);
      return [ServyBackend.success, response.data["materiel"]["_id"]];
    } on UnoError catch (error) {
      return ["${ServyBackend.echec} : ${error.message}", ""];
    }
  }

  Future<List<String>> passerCommande({
    required String serviceprestataire,
  }) async {
    try {
      final formData = FormData();

      formData.add("service", serviceprestataire);
      final response = await uno.post("/users/placeOrder", data: formData);
      return [ServyBackend.success, response.data["commande"]["_id"]];
    } on UnoError catch (error) {
      return ["${ServyBackend.echec} : ${error.message}", ""];
    }
  }

  Future<List<String>> createServicePrestataire(
      {required List<File> photos,
      required File audio,
      required String service,
      required String delai,
      required List<String> materiels,
      required String tarif,
      required String desc}) async {
    try {
      final formData = FormData();

      for (File photo in photos) {
        formData.addFile("images", photo.path);
      }
      for (String materiel in materiels) {
        formData.add("materiaux", materiel);
      }
      formData.addFile("audio", audio.path);
      formData.add("delai", delai);
      formData.add("service", service);
      formData.add("tarif", tarif);
      formData.add("description", desc);

      final response =
          await uno.post("/users/createserviceprestataire", data: formData);
      return [ServyBackend.success, response.data["service"]["_id"]];
    } on UnoError catch (error) {
      return ["${ServyBackend.echec} : ${error.message}", ""];
    }
  }

  Future<Map<String, dynamic>> getConnectedUser() async {
    // A régler plus tard if (user.isNotEmpty && !enTransition) return user;
    if (user.isNotEmpty) return user;

    try {
      final response = await uno.get("/users/getUser");

      user = response.data["user"];

      user["demande"] = response.data["demande"];
      enTransition = user["enTransition"];

      await FirebaseChatCore.instance.createUserInFirestore(types.User(
        id: AuthService().currentUser!.uid,
      ));
    } on UnoError catch (error) {
      if (error.response?.status == 401) {
        final token = await AuthService().currentUser?.getIdToken();
        if (token != null) {
          uno = Uno(
            baseURL: baseURL,
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            },
          );
          final response = await uno.get("/users/getUser");
          user = response.data["user"];
          user["demande"] = response.data["demande"];
          enTransition = user["enTransition"];

          await FirebaseChatCore.instance.createUserInFirestore(types.User(
            id: AuthService().currentUser!.uid,
          ));
        }
      } else {
        throw "Une erreur s'est produite";
      }
    } catch (error) {
      inspect(error);
    }
    return user;
  }

  Future<void> rafraichir() async {
    try {
      final response = await uno.get("/users/getUser");
      user = response.data["user"];
      user["demande"] = response.data["demande"];
      enTransition = user["enTransition"];
    } on UnoError catch (error) {
      if (error.response?.status == 401) {
        final token = await AuthService().currentUser?.getIdToken();
        if (token != null) {
          uno = Uno(
            baseURL: baseURL,
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            },
          );
          final response = await uno.get("/users/getUser");
          user = response.data["user"];
          user["demande"] = response.data["demande"];
          enTransition = user["enTransition"];
        }
      } else {
        throw "Une erreur s'est produite";
      }
    } catch (error) {
      inspect(error);
    }
  }

  Future<List<Map<dynamic, dynamic>>> getUserServices(String id) async {
    try {
      final response = await uno.get("/users/getservicesofaprestataire/$id");

      return List<Map<dynamic, dynamic>>.from(response.data["services"]);
    } catch (error) {
      inspect(error);
      return [];
    }
  }

  Future<List<Map<dynamic, dynamic>>> getCommandes() async {
    try {
      final response = await uno.get("/users/listcommandes");
      return List<Map<dynamic, dynamic>>.from(response.data["commandes"]);
    } catch (error) {
      inspect(error);
      return [];
    }
  }

  Future<Map<String, List<Map<dynamic, dynamic>>>> getResearch(
      String query) async {
    try {
      final response = await uno
          .get("/users/getVendeurServiceBySearch/${query == "" ? " " : query}");

      return {
        "services": List<Map<dynamic, dynamic>>.from(response.data["services"]),
        "vendeurs": List<Map<dynamic, dynamic>>.from(response.data["vendeurs"])
      };
    } catch (error) {
      inspect(error);
      return {"services": [], "vendeurs": []};
    }
  }

  Future<List<Map<dynamic, dynamic>>> getListOfServices() async {
    try {
      final response = await uno.get("/users/servicesList");

      return List<Map<dynamic, dynamic>>.from(response.data["services"]);
    } on UnoError catch (error) {
      if (error.response?.status == 401) {
        final token = await AuthService().currentUser?.getIdToken();
        if (token != null) {
          uno = Uno(
            baseURL: baseURL,
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            },
          );
          final response = await uno.get("/users/servicesList");

          return List<Map<dynamic, dynamic>>.from(response.data["services"]);
        }
      }
      inspect(error);
      return [];
    }
  }

  Future<List<Map<dynamic, dynamic>>> getListOfVendeurs() async {
    try {
      final response = await uno.get("/users/vendeursList");

      return List<Map<dynamic, dynamic>>.from(response.data["vendeurs"]);
    } on UnoError catch (error) {
      inspect(error);
      return [];
    }
  }

  Future<List<Map<dynamic, dynamic>>> getListOfServicesPrestataires() async {
    try {
      final response = await uno.get("/users/servicesPrestatairesList");

      return List<Map<dynamic, dynamic>>.from(response.data["services"]);
    } on UnoError catch (error) {
      inspect(error);
      return [];
    }
  }
}
