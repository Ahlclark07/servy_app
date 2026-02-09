# Servy (servy_app)

Projet de soutenance (licence) : app mobile de mise en relation **locale** entre clients et prestataires pour des **metiers en presentiel** (menuiserie, mecanique, coiffure, petits travaux, etc.).

## A quoi ca sert

| Role | Ce que l'utilisateur fait |
|---|---|
| Client | Trouve des prestataires proches, consulte des services, passe une commande, discute avec le prestataire |
| Prestataire ("vendeur") | Remplit son profil, soumet une demande vendeur, cree/publie des services (photos + audio + tarif + delai) |

## Fonctionnalites (resume)

| Bloc | Details | Ou dans le code |
|---|---|---|
| Auth | Inscription / connexion (e-mail + mot de passe) | `lib/utils/auth_service.dart`, `lib/pages/page_inscription.dart`, `lib/pages/page_connexion.dart` |
| Profil | Infos perso + telephone + adresse + geolocalisation | `lib/pages/page_remplir_profil.dart`, `lib/utils/servy_backend.dart` |
| Accueil | Categories / vendeurs / services mis en avant | `lib/pages/innerpages/accueil_inner_page.dart` |
| Recherche | Recherche vendeurs + services | `lib/pages/innerpages/recherche_inner_page.dart` |
| Prestataires proches | Carte Google Maps + liste, declenche via shake (secouer le telephone) | `lib/pages/page_vendeurs_proches.dart`, `lib/pages/main_page.dart` |
| Demande vendeur | Profession + photo + piece d'identite, validation cote admin (backend) | `lib/pages/devenir_vendeur.dart`, `lib/utils/servy_backend.dart` |
| Services | Fiche service (images, audio, distance, carte), commande | `lib/pages/page_service.dart`, `lib/components/cards/service_card.dart` |
| Creation service | Photos (jusqu'a 4), tarif/delai/desc, audio enregistre, materiel optionnel | `lib/pages/page_creation_service.dart` |
| Commandes | Creation + annulation | `lib/utils/servy_backend.dart`, `lib/pages/chat_page.dart` |
| Chat | Messagerie Firestore (rooms/messages) | `lib/pages/chat_page.dart`, `lib/pages/innerpages/chat_inner_page.dart` |
| Traduction | Appui long sur un message -> FR -> Fon (API Glosbe) | `lib/components/custom_bubble.dart`, `lib/utils/servy_backend.dart` |

## Architecture technique

| Composant | Role | Techno |
|---|---|---|
| App mobile | UI, navigation, formulaires, audio, maps | Flutter / Dart |
| Firebase | Auth + stockage messages (chat) | Firebase Auth + Firestore (`flutter_firebase_chat_core`) |
| Backend REST (hors depot) | Metier + donnees + uploads (images/audio) | API via `uno` + token Firebase (`Authorization: Bearer <idToken>`) |

## Dependances principales

| Categorie | Packages |
|---|---|
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore` |
| Chat | `flutter_firebase_chat_core`, `flutter_chat_ui`, `flutter_chat_types` |
| Localisation / carte | `geolocator`, `google_maps_flutter` |
| Audio | `flutter_sound`, `audio_video_progress_bar`, `audioplayers` |
| Reseau | `uno` |
| UI | `google_fonts`, `flutter_carousel_widget`, `flutter_animate`, `cached_network_image` |
| Fichiers / permissions | `file_picker`, `permission_handler` |

## Lancer le projet (Android)

Prerequis : Flutter OK (`flutter doctor`), projet Firebase, cle Google Maps, backend REST compatible (ou adapter `baseURL`).

```bash
flutter pub get
flutter run
```

## Configuration

| Sujet | Fichier | A faire |
|---|---|---|
| Firebase (Android) | `android/app/google-services.json` | Mettre le fichier de config Firebase |
| Init Firebase | `lib/main.dart` | `Firebase.initializeApp()` est deja appele |
| Google Maps | `android/app/src/main/AndroidManifest.xml` | Remplacer `YOUR_API_KEY` par la cle |
| Backend REST | `lib/utils/servy_backend.dart` | Ajuster `ServyBackend.baseURL` (prod / local) |

## Organisation du repo

| Dossier / fichier | Contenu |
|---|---|
| `lib/main.dart` | Entree app + routes + init Firebase |
| `lib/utils/` | Services (auth, backend API, fixes) |
| `lib/pages/` | Ecrans |
| `lib/components/` | Widgets reutilisables (cards, forms, boutons, audio, etc.) |
| `assets/images/` | Images (intro) |

## Note a moi meme (non implemente a ce jour)

| Sujet | Etat | Detail |
|---|---|---|
| Paiement | TODO | Bouton present cote commande, integration (ex. Fedapay) a faire |
| SOS | TODO | Bouton present sur "vendeurs proches", logique d'alerte a faire |

## A savoir

| Point | Detail |
|---|---|
| Certificats (dev) | `lib/utils/android_5_fix.dart` desactive la verif TLS (`badCertificateCallback`) |
| Langue | App en francais (`supportedLocales: [Locale('fr')]`) |
