import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDemo extends StatefulWidget {
  const FirestoreDemo({Key? key}) : super(key: key);

  @override
  State<FirestoreDemo> createState() => _FirestoreDemoState();
}

class _FirestoreDemoState extends State<FirestoreDemo> {
  final TextEditingController _msgController = TextEditingController();
  final CollectionReference _messages = FirebaseFirestore.instance.collection(
    'messages',
  );

  Future<void> _addMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    await _messages.add({
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _msgController.clear();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Demo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  onPressed: _addMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text('Error loading messages'));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty)
                  return const Center(child: Text('No messages yet'));
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final text = data['text'] ?? '<no-text>';
                    return ListTile(
                      title: Text(text),
                      subtitle: Text(docs[index].id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
