import 'dart:developer';

import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servy_app/design/design_data.dart';

class LocalisationButton extends StatefulWidget {
  final void Function(Position pos) callback;
  const LocalisationButton({super.key, required this.callback});

  @override
  State<LocalisationButton> createState() => _LocalisationButtonState();
}

class _LocalisationButtonState extends State<LocalisationButton> {
  bool dejaRempli = false;
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    inspect(permission);
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (await Geolocator.isLocationServiceEnabled() == false) {
      await Geolocator.openLocationSettings();
      return Future.error("GPS");
    }

    inspect(await Geolocator.isLocationServiceEnabled());
    try {
      Position pos = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );
      widget.callback(pos);
      return pos;
    } catch (e) {
      inspect(e);
      throw (e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      child: const Text(
        'Fournir votre localisation actuelle',
        textAlign: TextAlign.center,
      ),
      onPressed: () async {
        try {
          await _determinePosition();
          setState(() {
            dejaRempli = true;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Veuillez accepter la localisation"),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            dejaRempli = false;
          });
          // Geolocator.openAppSettings();
        }
      },
      builder: (context, child, callback, buttonState) {
        // if (buttonState == const ButtonState.success()) {
        //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //     setState(() {
        //       dejaRempli = true;
        //     });
        //   });
        // }
        return dejaRempli
            ? ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(Palette.background),
                    foregroundColor: WidgetStatePropertyAll(Palette.blue)),
                onPressed: null,
                child: const Text(
                  'Localisation fournie avec succès',
                  textAlign: TextAlign.center,
                ),
              )
            : ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.black)),
                onPressed: callback,
                child: child,
              );
      },
    );
  }
}
