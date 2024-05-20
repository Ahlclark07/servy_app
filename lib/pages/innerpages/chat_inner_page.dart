import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:servy_app/components/chat_page.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

class ChatInnerPage extends StatelessWidget {
  const ChatInnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: FirebaseChatCore.instance.rooms(),
      initial: const [],
      waiting: (context) => const Text("Attends"),
      builder: (context, data) {
        inspect(data);
        if (data == null || data.isEmpty) {
          return const Center(child: Text('No conversations'));
        }
        return Column(
          children: [
            ...List<GestureDetector>.generate(
                data.length,
                (index) => GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(color: Palette.blue, width: .5),
                          )),
                          height: 70,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${ServyBackend.basePhotodeProfilURL}/${data[index].metadata["imageUrl"] ?? "1715124451532-bracelet.jpeg"}"),
                                radius: 60,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(data[index].metadata["name"] ==
                                                null ||
                                            data[index].metadata["name"] == ""
                                        ? '#IDdeLaCommandeCree'
                                        : "#C${data[index].metadata["name"]}"),
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
