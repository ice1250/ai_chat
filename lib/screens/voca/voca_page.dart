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
    return Text('어휘 학습');
  }
}
