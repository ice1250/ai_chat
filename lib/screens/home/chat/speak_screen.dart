import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';

class SpeakScreen extends StatefulWidget {
  const SpeakScreen({super.key});

  @override
  State<SpeakScreen> createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initRecorder();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation =
        Tween<double>(begin: 50, end: 100).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _animationController.repeat(reverse: true);
  }

  Future<void> _initRecorder() async {
    // await _recorder.openRecorder();
    _startRecording();
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      // if (await _recorder!.isEncoderSupported(Codec.pcm16WAV)) {
      //   final tempDir = await getTemporaryDirectory();
      //   final audioPath = '${tempDir.path}/my_voice_recording.wav';
      //
      //   await _recorder.startRecorder(
      //     toFile: audioPath,
      //     codec: Codec.pcm16WAV,
      //   );
      //   setState(() {
      //     _isRecording = true;
      //   });
      //   _animationController.forward();
      // } else {
      //   print('지원하지 않는 포맷?');
      // }
    } else {
      logger.d('녹음 권한이 거부되었습니다.');
    }
  }

  Future<void> _stopRecording() async {
    // await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _animationController.reverse();
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/my_voice_recording.wav';
    if (!mounted) return;
    Navigator.pop(context, audioPath);
  }

  @override
  void dispose() {
    // _recorder.closeRecorder();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speak'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isRecording ? '녹음하세요' : '준비중',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? Colors.green : Colors.red,
              ),
            ),
            if (_isRecording)
              ElevatedButton(
                onPressed: _stopRecording,
                child: const Text('녹음 완료'),
              ),
          ],
        ),
      ),
    );
  }
}
