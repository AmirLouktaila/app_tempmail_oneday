import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:templkt/screens/history_page.dart';
import 'package:templkt/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color.fromARGB(0, 255, 255, 255), // نفس لون الخلفية
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppMail(),
    );
  }
}

class AppMail extends StatefulWidget {
  const AppMail({super.key});

  @override
  State<AppMail> createState() => _AppMailState();
}

class _AppMailState extends State<AppMail> with AutomaticKeepAliveClientMixin {
  int currentPageIndex = 0;
  List<Widget> pages = [HomePage(), HistoryPage()];
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.email),
            icon: Icon(Icons.email_outlined),
            label: 'Email',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
