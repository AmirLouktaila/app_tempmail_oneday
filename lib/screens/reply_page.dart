import 'package:flutter/material.dart';
import 'package:templkt/model/api_mail.dart';
import 'package:templkt/widget/showCustomSnackbar.dart';

class ReplyPage extends StatefulWidget {
  final String email;
  final String myemail;

  ReplyPage({
    super.key,
    required this.email,
    required this.myemail,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final TextEditingController to = TextEditingController();
  final TextEditingController subject = TextEditingController();
  final TextEditingController body = TextEditingController();

  @override
  void initState() {
    super.initState();
    to.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 4,
        backgroundColor: const Color(0xFF7C3AED),
        title: const Text(
          'Reply',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: to,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: subject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: body,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () {
                  String emailTo = to.text.trim();
                  String emailSubject = subject.text.trim();
                  String emailBody = body.text.trim();

                  if (emailTo.isEmpty || emailBody.isEmpty) {
                    showCustomSnackbar(
                        context, 'Please fill all required fields.');
                    return;
                  }

                  ReplyToMessage(
                      widget.myemail, emailTo, emailSubject, emailBody);
                  showCustomSnackbar(context, 'Reply sent to $emailTo');
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
