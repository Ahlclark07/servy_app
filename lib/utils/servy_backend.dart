import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:uno/uno.dart';

class ServyBackend {
  static late final ServyBackend _instance;
  static String baseURL = "http://localhost:300";
  static String basePhotoURL = "http://192.168.1.105:300";
  static const String echec = "echec";
  static const String success = "success";
  Map<String, dynamic> user = Map();
  ServyBackend._internal() {
    _initBackend();
  }

  factory ServyBackend() {
    return _instance;
  }
  Future<void> _initBackend() async {
    try {
      final token = await AuthService().currentUser?.getIdToken();
      if (token != null) {
        _instance.uno = Uno(
          baseURL: "http://10.0.2.2:300",
          headers: {"Authorization": "Bearer $token"},
        );
      } else {
        _instance.uno = Uno(
          baseURL: baseURL,
        );
      }
    } catch (e) {
      print("Erreur lors de l'initialisation du backend : $e");
    }
  }

  late final Uno uno;

  Future<String> userExist() async {
    try {
      return ServyBackend.success;
    } on UnoError catch (error) {
      return "${error.response?.status} ${error.message}";
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
      await uno.post("/users/becomeClient", data: formData);
      return ServyBackend.success;
    } on UnoError catch (error) {
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
      return ServyBackend.success;
    } on UnoError catch (error) {
      return "${ServyBackend.echec} : ${error.message}";
    }
  }

  Future<Map<String, dynamic>> getConnectedUser() async {
    if (user.isNotEmpty) return user;

    try {
      final response = await uno.get("/users/getUser");
      user = response.data["user"];
    } catch (error) {
      inspect(error);
    }
    return user;
  }

  Future<List<Map<dynamic, dynamic>>> getListOfServices() async {
    try {
      final response = await uno.get("/users/servicesList");

      return List<Map<dynamic, dynamic>>.from(response.data);
    } on UnoError catch (error) {
      inspect(error);
      return [];
    }
  }

  static void initialize() {
    _instance = ServyBackend._internal();
  }
}
