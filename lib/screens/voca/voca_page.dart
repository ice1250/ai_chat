import 'package:flutter/material.dart';

/// 어휘 메인페이지
class VocaPage extends StatefulWidget {
  const VocaPage({super.key});

  @override
  State<VocaPage> createState() => _VocaPageState();
}

class _VocaPageState extends State<VocaPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Column(
        children: [
          Text('어휘 학습'),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/voca');
            },
            child: Text('어휘 학습 시작'),
          ),
          Text('나의 영어 어휘력은 어느 정도일까?'),
          Text('학습 정보'),
          Text('출석 체크'),
          Text('캐릭터 상점'),
          Text('정확하게 발음하지 못한 어휘'),
          Text('일별 학습 어휘'),
          Text('최근에 잊어버린 어휘'),
          Text('역대 가장 많이 잊어버린 어휘'),
          Text('길게 기억했다 잊어버린 어휘'),
          Text('복습이 필요없는 어휘'),
          Text('내가 만든 단어장'),
        ],
      ),
    );
  }
}
