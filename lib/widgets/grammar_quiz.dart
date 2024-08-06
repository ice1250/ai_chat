import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GrammarQuiz extends StatefulWidget {
  const GrammarQuiz({super.key});

  @override
  State<StatefulWidget> createState() => _GrammarQuizState();

}

class _GrammarQuizState extends State<GrammarQuiz> {
  int? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '문제: 다음 중 올바른 문법은?',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          _buildAnswerTile(0, '답변 1'),
          _buildAnswerTile(1, '답변 2'),
          _buildAnswerTile(2, '답변 3'),
          _buildAnswerTile(3, '답변 4'),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _selectedAnswer != null ? _confirmAnswer : null,
              child: const Text('확인'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerTile(int index, String answer) {
    return ListTile(
      title: Text(answer),
      leading: Radio<int>(
        value: index,
        groupValue: _selectedAnswer,
        onChanged: (int? value) {
          setState(() {
            _selectedAnswer = value;
          });
        },
      ),
    );
  }

  void _confirmAnswer() async{
    // Handle answer confirmation logic here
    print('Selected answer: $_selectedAnswer');

    final directory = await getApplicationDocumentsDirectory();
    print('Directory path: ${directory.path}');
  }


}