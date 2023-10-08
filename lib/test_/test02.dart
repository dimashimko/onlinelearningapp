import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('messagesBox');
  runApp(MyApp());
}

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  late String content;

  Message(this.content);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hive Local Messages'),
        ),
        body: MessageList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addMessage('New Message ${DateTime.now()}');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

void addMessage(String content) async {
  var messagesBox = await Hive.openBox('messagesBox');
  var message = Message(content);
  messagesBox.add(message);
}

List<Message> getAllMessages() {
  var messagesBox = Hive.box('messagesBox');
  return messagesBox.values.cast<Message>().toList();
}

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Message> messages = getAllMessages();

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index].content),
        );
      },
    );
  }
}
