import 'package:ai_chat/screens/home/grammar_page.dart';
import 'package:ai_chat/screens/home/league_page.dart';
import 'package:ai_chat/screens/home/listening_page.dart';
import 'package:ai_chat/screens/home/premium_page.dart';
import 'package:ai_chat/screens/home/voca_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _index = 0;

  final List _pages = [
    const VocaPage(),
    const GrammarPage(),
    const ListeningPage(),
    const LeaguePage(),
    const PremiumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen(getUserProvider, (previous, next) {
      if (next == null) {
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('틈새단어'),
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
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/chat');
              },
              child: const ListTile(
                title: Text('채팅하기'),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go('/setting');
              },
              child: const ListTile(
                title: Text('설정'),
              ),
            ),
          ],
        ),
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
