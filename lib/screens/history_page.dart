import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templkt/model/api_mail.dart';
import 'package:templkt/widget/showCustomSnackbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String generateRandomCode({int length = 9}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  List<String> history = [];

  Future<void> Savehistory(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingHistory = prefs.getStringList('history') ?? [];

    if (!existingHistory.contains(newEmail)) {
      existingHistory.add(newEmail);
      await prefs.setStringList('history', existingHistory);
    }
  }

  Future<void> SaveEmail(String mail) async {
    final prefe = await SharedPreferences.getInstance();
    await prefe.setString('email', mail);
  }

  Future<void> readHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hist = prefs.getStringList('history');
    setState(() {
      history = hist ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    readHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 4,
        backgroundColor: const Color(0xFF7C3AED),
        centerTitle: true,
        title: const Text(
          'History mail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text("No history found."))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.history,
                                  color: Colors.deepPurple),
                              title: Text(history[index],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text('Renew email :${history[index]}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      RenewMail(
                                          generateRandomCode(), history[index]);
                                      SaveEmail(history[index]);
                                      removeMail(index);
                                      showCustomSnackbar(context,
                                          'Email renewed successfully: ${history[index]}');
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                132, 192, 192, 192),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Image.asset(
                                              'assets/images/sync.png',
                                              color: Color.fromARGB(
                                                  255, 17, 17, 17),
                                              width: 15,
                                              height: 15),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: const Text(
                                                  'Are you sure you want to delete this email from history?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 0, 0),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    minimumSize: Size(50, 40),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      removeMail(index);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                127, 255, 33, 33),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Image.asset(
                                              'assets/images/delete.png',
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              width: 15,
                                              height: 15),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void removeMail(int index) async {
    final prefs = await SharedPreferences.getInstance();
    history.removeAt(index);
    await prefs.setStringList('history', history);
    setState(() {});
  }
}
