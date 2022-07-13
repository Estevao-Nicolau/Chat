import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/model/chat_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticationPage extends StatelessWidget {
  const NoticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNotificationService>(context);
    final items = service.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Notificações'),
      ),
      body: ListView.builder(
        itemCount: service.itemsCount,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(items[i].title),
          subtitle: Text(items[i].body),
          onTap: () => service.remove(i),
        ),
      ),
    );
  }
}
