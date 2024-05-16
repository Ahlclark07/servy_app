import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
        hintText: "Rechercher un service ou un vendeur",
        elevation: const MaterialStatePropertyAll<double>(1),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              SnackBar(
                content: Text(
                    "En cours d'implémentation ! Vous pourrez plus tard faire des recherches en fon"),
              ),
            );
          },
        ));
  }
}
