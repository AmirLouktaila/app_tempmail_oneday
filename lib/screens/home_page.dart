import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templkt/model/api_mail.dart';
import 'package:templkt/screens/inbox_page.dart';
import 'package:templkt/widget/showCustomSnackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cusMail = TextEditingController();
  String? mailFuture;
  String? dateFuture;
  bool isnew = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  String generateRandomCode({int length = 9}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> SaveEmail(String mail, String datemail) async {
    final prefe = await SharedPreferences.getInstance();
    await prefe.setString('email', mail);
    await prefe.setString('datemail', datemail.toString());
  }

  Future<String?> ReadEmail() async {
    final prefe = await SharedPreferences.getInstance();
    return prefe.getString('email');
  }

  Future<String?> ReadDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('datemail');
  }

  Future<void> Savehistory(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingHistory = prefs.getStringList('history') ?? [];

    if (!existingHistory.contains(newEmail)) {
      existingHistory.add(newEmail);
      await prefs.setStringList('history', existingHistory);
    }
  }

  Future<void> init() async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    String? savedMail = await ReadEmail();
    String? savedDate = await ReadDate();
    print(savedMail);
    print('date: $savedDate');
    print('date2: $formattedDate ');
    if (savedMail != null && savedDate != formattedDate) {
      await Savehistory(savedMail);

      String newCode = generateRandomCode();
      Map<String, dynamic> newMail = await GenerateRandomMail(newCode);

      await SaveEmail(newMail['email']!, newMail['datemail']);

      setState(() {
        mailFuture = newMail['email']!;
        dateFuture = newMail['datemail'];
      });

      return;
    }

    if (savedMail == null) {
      String code = generateRandomCode();
      Map<String, dynamic> newMail = await GenerateRandomMail(code);

      await SaveEmail(newMail['email']!, newMail['datemail']);

      setState(() {
        mailFuture = newMail['email']!;
        dateFuture = newMail['datemail'];
      });

      return;
    }

    setState(() {
      mailFuture = savedMail;
      dateFuture = savedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Image.asset('assets/images/sync.png',
                  color: Colors.white, width: 20, height: 20),
              onPressed: () async {
                setState(() {});
              },
            )
          ],
          shadowColor: Colors.black,
          elevation: 4,
          backgroundColor: Color(0xFF7C3AED),
          centerTitle: true,
          title: Text(
            'Mail',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 30, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          // Color(0xFF4DB5FF),
                          // Color.fromARGB(255, 108, 189, 236),
                          Color(0xFF7C3AED),
                          Color(0xFFA78BFA),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Your temporary email',
                                    style: TextStyle(
                                      color: Color.fromARGB(240, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(66, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer,
                                              color: Colors.white, size: 15),
                                          SizedBox(width: 4),
                                          Text(
                                            'One day',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            )),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: mailFuture == null
                                    ? Text(
                                        'Wait ...',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    : Text(
                                        mailFuture.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      )),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: mailFuture.toString(),
                                ));
                                showCustomSnackbar(
                                    context, 'Email copied to clipboard!');
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Image.asset('assets/images/copy.png',
                                        color: Color(0xFF7C3AED),
                                        width: 15,
                                        height: 15),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF7C3AED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 40),
                          ),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Random Email'),
                                    content: const Text('Random email '),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          String code = generateRandomCode();
                                          Map<String, dynamic> newMail =
                                              await GenerateRandomMail(code);
                                          print(newMail);
                                          await SaveEmail(newMail['email']!,
                                              newMail['datemail']);
                                          setState(() {
                                            mailFuture = newMail['email']!;
                                            dateFuture = newMail['datemail'];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Random'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF7C3AED),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize: Size(50, 40),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Custom email'),
                                                  content: TextField(
                                                    controller: cusMail,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'email With out @',
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xFF7C3AED),
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        minimumSize:
                                                            Size(50, 40),
                                                      ),
                                                      onPressed: () async {
                                                        var username =
                                                            cusMail.text;
                                                        String code =
                                                            generateRandomCode();
                                                        Map<String, dynamic>
                                                            newMail =
                                                            await GenerateCustomMail(
                                                                code,
                                                                "${username}@saibrasoft.com");
                                                        if (newMail['email'] ==
                                                            'Email already exists') {
                                                          showCustomSnackbar(
                                                              context,
                                                              'Email already exists');
                                                        } else {
                                                          print(newMail);
                                                          await SaveEmail(
                                                              newMail['email']!,
                                                              newMail[
                                                                  'datemail']);
                                                          setState(() {
                                                            mailFuture =
                                                                newMail[
                                                                    'email']!;
                                                            dateFuture =
                                                                newMail[
                                                                    'datemail'];

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            cusMail.clear();
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        'Custom email',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          'Custom email',
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Generate New Address'),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Inbox',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(150, 40),
                        ),
                        onPressed: () async {
                          setState(() {});
                        },
                        child: Text(
                          'Refresh Inbox',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: MessageMail(mailFuture ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No messages found.'));
                    } else {
                      final messages =
                          snapshot.data!['messages'] as List<dynamic>? ?? [];

                      if (messages.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/empty.png',
                                width: 150, height: 150),
                            Text(
                              'No emails yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: Text(
                                'Waiting for new messages. Use this email address to sign up for services and receive emails instantly.',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(150, 40),
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                'Refresh Inbox',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      }

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return buildMessageCard(
                            context,
                             msg['email']?.toString() ?? 'Unknown Sender',
                            msg['from']?.toString() ?? 'Unknown Sender',
                            msg['subject']?.toString() ?? 'No Subject',
                            msg['date']?.toString() ?? 'No date',
                            msg['shortMsg']?.toString() ?? 'No shortMsg',
                            msg['filename']?.toString() ?? 'No filename',
                            msg['message']?.toString() ?? 'No Content',
                            false,
                          );
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

Map<String, String> parseSender(String sender) {
  final regex = RegExp(r'^(.*?)\s*<([^>]+)>$');
  final match = regex.firstMatch(sender);

  if (match != null) {
    return {
      'name': match.group(1)?.trim() ?? '',
      'email': match.group(2)?.trim() ?? '',
    };
  } else {
    return {
      'name': sender.trim(),
      'email': '',
    };
  }
}

Widget buildMessageCard(
  BuildContext context,
    String myemail,
  String sender,
  String subject,
  String date,
  String shortMsg,
  String filename,
  String body,
  bool isRead,
) {
  final parsed = parseSender(sender);
  String displayName = parsed['name']!;
  String email = parsed['email']!;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          if (body.trim().isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InboxPage(
                  rawMessage: body,
                  subject: subject,
                  sender: displayName,
                  email: email,
                  date: date,
                  filename: filename,
                  myemail: myemail,
                  
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(158, 158, 158, 158)
                      .withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 0.2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(178, 224, 224, 224),
                        child: Image.asset(
                          'assets/images/user.png',
                          width: 20,
                          height: 20,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isRead ? Colors.grey : Colors.black,
                              ),
                            ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: TextStyle(
                                  color: isRead ? Colors.grey : Colors.black54,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        date.substring(5, 16).toString(),
                        style: TextStyle(
                          color: Color.fromARGB(192, 114, 114, 114),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    shortMsg,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}