import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();
    widget.callback(pos);
    return pos;
  }

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      child: const Text('Fournir votre localisation actuelle'),
      onPressed: () async {
        await _determinePosition();
      },
      builder: (context, child, callback, buttonState) {
        if (buttonState == const ButtonState.success()) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              dejaRempli = true;
            });
          });
        }
        return dejaRempli
            ? ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor:
                        MaterialStatePropertyAll(Palette.background),
                    foregroundColor: MaterialStatePropertyAll(Palette.blue)),
                onPressed: null,
                child: const Text('Localisation fournie avec succès'),
              )
            : ElevatedButton(
                onPressed: callback,
                child: child,
              );
      },
    );
  }
}
