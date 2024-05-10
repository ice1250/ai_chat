import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeakScreen extends StatefulWidget {
  const SpeakScreen({super.key});

  @override
  State<SpeakScreen> createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen> {
  late FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      if (await _recorder!.isEncoderSupported(Codec.pcm16WAV)) {
        final tempDir = await getTemporaryDirectory();
        final audioPath = '${tempDir.path}/my_voice_recording.wav';

        await _recorder!.startRecorder(
          toFile: audioPath,
          codec: Codec.pcm16WAV,
        );
        setState(() {
          _isRecording = true;
        });
      } else {
        print('지원하지 않는 포맷?');
      }
    } else {
      print('녹음 권한이 거부되었습니다.');
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (!mounted) return;
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/my_voice_recording.wav';
    Navigator.pop(context, audioPath);
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
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
            FloatingActionButton(
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            SizedBox(height: 20),
            Text(
              '00:00',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
