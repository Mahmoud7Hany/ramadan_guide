import 'package:flutter/material.dart';

class PrayersScreen extends StatefulWidget {
  const PrayersScreen({super.key});

  @override
  PrayersScreenState createState() => PrayersScreenState();
}

class PrayersScreenState extends State<PrayersScreen> {
  List<String> prayers = [];
  TextEditingController prayerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأدعية'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: prayers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: ListTile(
                    title: Text(prayers[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          prayers.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: prayerController,
                    decoration: const InputDecoration(
                      hintText: 'أضف دعاء...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (prayerController.text.isNotEmpty) {
                        prayers.add(prayerController.text);
                        prayerController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}