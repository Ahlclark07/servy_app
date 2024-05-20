import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';

class HomeSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> queryNotifier;
  HomeSearchBar({super.key, required this.queryNotifier});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
        controller: controller,
        autoFocus: true,
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
            onPressed: () => queryNotifier.value = controller.text,
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

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
