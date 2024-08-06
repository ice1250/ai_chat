import 'package:ai_chat/widgets/grammar_quiz.dart';
import 'package:flutter/material.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  @override
  Widget build(BuildContext context) {
    return const GrammarQuiz();
  }
}
