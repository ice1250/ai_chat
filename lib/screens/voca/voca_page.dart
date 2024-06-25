import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
          Container(
            color: Colors.blue,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Lottie.asset('assets/lottie/fish.json'),
                ),
                const Expanded(
                  flex: 1,
                  child: Center(child: Text('어휘 학습')),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/voca');
            },
            child: Text('오늘의 학습'),
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
