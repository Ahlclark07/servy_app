import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:servy_app/utils/auth_service.dart';

class ChatPage extends StatelessWidget {
  final types.Room room;

  const ChatPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            room.metadata?["name"] != null ? room.metadata!["name"] : 'Chat'),
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(room),
        initialData: const [],
        builder: (context, snapshot) {
          return Chat(
            messages: snapshot.data!,
            onSendPressed: (partialText) async {
              final message = types.PartialText(text: partialText.text);
              FirebaseChatCore.instance.sendMessage(message, room.id);
            },
            user: types.User(id: AuthService().currentUser!.uid),
          );
        },
      ),
    );
  }
}
