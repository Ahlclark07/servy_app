import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';

class HomeSearchBar extends StatelessWidget {
  final Function() callback;
  const HomeSearchBar({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
        onTap: () => callback(),
        hintText: "Rechercher un service ou un vendeur",
        elevation: const WidgetStatePropertyAll<double>(1),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        trailing: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Palette.cendre,
            ),
            onPressed: () => Navigator.of(context).pushNamed("/page_recherche"),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.mic,
            color: Palette.cendre,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "En cours d'implémentation ! Vous pourrez plus tard faire des recherches en fon"),
              ),
            );
          },
        ));
  }
}
