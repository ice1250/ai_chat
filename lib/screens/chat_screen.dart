import 'dart:io';
import 'dart:typed_data';

import 'package:ai_chat/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../repository/chat_repository.dart';
import 'record_test.dart';
import 'speak_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String userImage;
  final String userName;
  final String message;
  String translatedMessage;
  bool isTranslateLoading;

  ChatMessage({
    required this.userImage,
    required this.userName,
    required this.message,
    this.translatedMessage = '',
    this.isTranslateLoading = false,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final ChatRepository chatRepository = ChatRepository();
  final AudioPlayer audioPlayer = AudioPlayer();

  List<ChatMessage> chatMessages = [];

  bool isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {
        isTextFieldEmpty = messageController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> getAIResponse(String message) async {
    String aiResponse = await chatRepository.sendMessage(
      message: message,
    );

    setState(() {
      chatMessages.add(
        ChatMessage(
          userImage:
              'https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=250',
          userName: 'AI',
          message: aiResponse,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F4F8),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordTestScreen(
                        onStop: (path) {
                          logger.d('Recorded file path: $path');

                          setState(() {
                            // audioPath = path;
                            // showPlayer = true;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'AI 스피킹 트레이너',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final chatMessage = chatMessages[index];
                    return GestureDetector(
                      onTap: () async {
                        if (chatMessage.translatedMessage.isEmpty &&
                            !chatMessage.isTranslateLoading) {
                          chatMessage.isTranslateLoading = true;
                          setState(() {});

                          chatMessage.translatedMessage =
                              await chatRepository.translate(
                            message: chatMessage.message,
                          );

                          chatMessage.isTranslateLoading = false;
                          setState(() {});
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(chatMessage.userImage,
                                    width: 40, height: 40),
                                // 사용자 이미지 표시
                                const SizedBox(width: 10),
                                Text(chatMessage.userName),
                                const Spacer(), // Add this
                                IconButton(
                                  // Add this
                                  icon: const Icon(Icons.headphones),
                                  onPressed: () async {
                                    Uint8List audioData =
                                        await chatRepository.audio(
                                      message: chatMessage.message,
                                    );
                                    final tempDir =
                                        await getTemporaryDirectory();
                                    final file =
                                        File('${tempDir.path}/audio.mp3');
                                    await file.writeAsBytes(audioData,
                                        flush: true);
                                    await audioPlayer
                                        .play(DeviceFileSource(file.path));
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          chatMessage.message,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (chatMessage.isTranslateLoading)
                                    const CircularProgressIndicator(),
                                  if (chatMessage.translatedMessage.isNotEmpty)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chatMessage.translatedMessage,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: isTextFieldEmpty
                          ? IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SpeakScreen()),
                                );
                                if (result is String && result.isNotEmpty) {
                                  final audioPath = result;
                                  final transcription = await chatRepository
                                      .transcriptions(audioPath: audioPath);
                                  setState(() {
                                    chatMessages.add(
                                      ChatMessage(
                                        userImage:
                                            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                        userName: 'You',
                                        message: transcription,
                                      ),
                                    );
                                  });

                                  String aiResponse =
                                      await chatRepository.sendMessage(
                                    message: transcription,
                                  );

                                  setState(() {
                                    chatMessages.add(
                                      ChatMessage(
                                        userImage:
                                            'https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=250',
                                        userName: 'AI',
                                        message: aiResponse,
                                      ),
                                    );
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.mic,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (messageController.text.isNotEmpty) {
                                  String message = messageController.text;

                                  setState(() {
                                    chatMessages.add(
                                      ChatMessage(
                                        userImage:
                                            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                        userName: 'You',
                                        message: message,
                                      ),
                                    );
                                    messageController.clear();
                                  });

                                  String chatGptMessage =
                                      await chatRepository.sendMessage(
                                    message: message,
                                  );
                                  setState(() {
                                    chatMessages.add(
                                      ChatMessage(
                                        userImage:
                                            'https://gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=250',
                                        userName: 'AI',
                                        message: chatGptMessage,
                                      ),
                                    );
                                  });
                                }
                              },
                              child: const Text('전송'),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
