import 'package:ai_chat/screens/grammar/grammar_page.dart';
import 'package:ai_chat/screens/league_page.dart';
import 'package:ai_chat/screens/listening/listening_page.dart';
import 'package:ai_chat/screens/premium_page.dart';
import 'package:ai_chat/screens/voca/voca_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;

  final List _pages = [
    VocaPage(),
    GrammarPage(),
    ListeningPage(),
    LeaguePage(),
    PremiumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('틈새단어'),
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Icon(Icons.podcasts), Text('0')],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Icon(Icons.star), Text('5')],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amber,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: '어휘',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: '문법',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: '리스닝',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.museum_outlined),
            label: '리그',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            label: '프리미엄',
          ),
        ],
      ),
    );
  }
}
