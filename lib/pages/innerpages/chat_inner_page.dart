import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:servy_app/components/chat_page.dart';
import 'package:servy_app/utils/servy_backend.dart';
import 'package:servy_app/design/design_data.dart';

class ChatInnerPage extends StatelessWidget {
  const ChatInnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: FirebaseChatCore.instance.rooms(),
      initial: const [],
      waiting: (context) => const Center(child: CircularProgressIndicator()),
      builder: (context, data) {
        if (data == null || data.isEmpty) {
          return const Center(child: Text('Pas de conversations'));
        }
        return Column(
          children: [
            ...List<GestureDetector>.generate(
                data.length,
                (index) => GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Palette.blue.withOpacity(.05)
                                  : Palette.background),
                          height: 100,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    "${ServyBackend.basePhotodeProfilURL}/${data[index].metadata?["imageUrl"] ?? "1715124451532-bracelet.jpeg"}"),
                                radius: 60,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index].metadata?["name"] == null ||
                                              data[index].metadata["name"] == ""
                                          ? '#IDdeLaCommandeCree'
                                          : "#C${data[index].metadata["name"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 259,
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data[index].lastMessages == null
                                                ? 'Pas de méssages récents à afficher pour le moment.'
                                                : data[index].name,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(room: data[index]),
                          ),
                        );
                      },
                    ))
          ],
        );
      },
    );
  }
}
