import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../data/providers/user_provider.dart';

/// 어휘 메인페이지
class VocaPage extends ConsumerStatefulWidget {
  const VocaPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VocaPageState();
}

class _VocaPageState extends ConsumerState<VocaPage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getUserProvider);

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
                Expanded(
                  flex: 1,
                  child: Center(child: Text('어휘 학습 ${userInfo?.nickName} ${userInfo?.isPremium == true ? '프리미엄' : ''}')),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/voca');
            },
            child: const Text('오늘의 학습'),
          ),
          const Text('나의 영어 어휘력은 어느 정도일까?'),
          const Text('학습 정보'),
          const Text('출석 체크'),
          const Text('캐릭터 상점'),
          const Text('정확하게 발음하지 못한 어휘'),
          const Text('일별 학습 어휘'),
          const Text('최근에 잊어버린 어휘'),
          const Text('역대 가장 많이 잊어버린 어휘'),
          const Text('길게 기억했다 잊어버린 어휘'),
          const Text('복습이 필요없는 어휘'),
          const Text('내가 만든 단어장'),
        ],
      ),
    );
  }
}
