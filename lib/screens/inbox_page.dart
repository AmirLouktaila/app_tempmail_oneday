import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:templkt/model/api_mail.dart';
import 'package:templkt/screens/home_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:templkt/widget/showCustomSnackbar.dart';

class InboxPage extends StatefulWidget {
  final String rawMessage;
  final String sender;
  final String email;
  final String subject;
  final String date;
  final String filename;
  final String myemail;

  const InboxPage({
    super.key,
    required this.rawMessage,
    required this.sender,
    required this.email,
    required this.subject,
    required this.date,
    required this.filename,
    required this.myemail,
  });

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late final WebViewController controller;
  bool _isHtml = false;
  late String _content;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();

    _content = cleanQuotedPrintableHtml(widget.rawMessage);
    _isHtml = _checkIsHtml(_content);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            if (!_hasLoaded && _isHtml) {
              _hasLoaded = true;
              controller.loadHtmlString(_wrapHtmlWithViewport(_content));
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      );

    if (_isHtml) {
      controller.loadHtmlString("<html><body></body></html>");
    }
  }
  bool _checkIsHtml(String text) {
    final htmlTags = [
      '<html',
      '<body',
      '<p',
      '<div',
      '<br',
      '<span',
      '<table',
      '<a',
      '<img'
    ];
    final lowered = text.toLowerCase();
    return htmlTags.any((tag) => lowered.contains(tag));
  }

  String cleanQuotedPrintableHtml(String input) {
    String cleaned = input.replaceAll(RegExp(r'=\r?\n'), '');

    final reg = RegExp(r'=([A-Fa-f0-9]{2})');

    List<int> bytes = [];
    int lastIndex = 0;

    for (final match in reg.allMatches(cleaned)) {
      bytes.addAll(utf8.encode(cleaned.substring(lastIndex, match.start)));
      bytes.add(int.parse(match.group(1)!, radix: 16));

      lastIndex = match.end;
    }
    bytes.addAll(utf8.encode(cleaned.substring(lastIndex)));

    return utf8.decode(bytes);
  }

  String _wrapHtmlWithViewport(String htmlContent) {
    return '''
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes" />
        <style>
          body { font-size: 18px; line-height: 1.5; font-family: Arial, sans-serif; margin: 10px; }
        </style>
      </head>
      <body>
        $htmlContent
      </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: ListTile(
          title: Text(
            widget.sender,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.email,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: _isHtml
                  ? WebViewWidget(controller: controller)
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        _content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: false,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(100, 50),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Reply',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 0, 0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(100, 50),
                        ),
                        onPressed: () async {
                          print(widget.filename);
                          final value = await DeleteMessage(widget.filename);

                          if (value['message'] == true) {
                            showCustomSnackbar(
                              context,
                              'The active message has been deleted.',
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          } else {
                            showCustomSnackbar(
                              context,
                              value['error'] ?? 'حدث خطأ حاول لاحقا',
                            );
                          }
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
