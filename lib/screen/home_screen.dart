import 'package:flutter/material.dart';

import '../repository/chat_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ChatMessage {
  final String userImage;
  final String userName;
  final String message;

  ChatMessage({
    required this.userImage,
    required this.userName,
    required this.message,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController 인스턴스 생성
  final messageController = TextEditingController();
  final ChatRepository chatRepository = ChatRepository();

  List<ChatMessage> chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F4F8),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20), // 텍스트 주변에 20픽셀의 패딩 추가
                child: const Text(
                  'AI 스피킹 트레이너',
                  style: TextStyle(
                    fontSize: 24, // 글꼴 크기를 24로 설정
                    fontWeight: FontWeight.bold, // 글꼴 두께를 bold로 설정
                    color: Colors.blue, // 글꼴 색상을 파란색으로 설정
                  ),
                ),
              ),
              Expanded(
                // 가운데는 남은 영역을 꽉 채우는 영역
                child: ListView.builder(
                  itemCount: chatMessages.length, // 리스트의 항목 수
                  itemBuilder: (context, index) {
                    final chatMessage = chatMessages[index];
                    return Container(
                      margin: const EdgeInsets.all(10), // 전체적으로 10픽셀의 마진 추가
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(chatMessage.userImage,
                                  width: 40, height: 40),
                              // 사용자 이미지 표시
                              const SizedBox(width: 10),
                              // 이미지와 이름 사이에 간격 추가
                              Text(chatMessage.userName),
                              // 사용자 이름 표시
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            // 메시지의 시작 위치를 사용자 이름과 맞추기 위한 패딩 추가
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chatMessage.message,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ), // 메시지 텍스트 표시
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20), // 전체적으로 20픽셀의 마진 추가
                child: Row(
                  // Row 위젯 추가
                  children: [
                    Expanded(
                      // TextField 위젯이 남은 공간을 모두 차지하도록 Expanded 위젯 사용
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: messageController, // 컨트롤러 설정
                          decoration: InputDecoration(
                            hintText: 'Message',
                            filled: true,
                            fillColor: Colors.grey[200], // 배경색을 좀 더 연한 회색으로 변경
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
                      child: ElevatedButton(
                        onPressed: () async {
                          if (messageController.text.isNotEmpty) {
                            String message =
                                messageController.text; // 메시지를 별도의 변수에 저장

                            setState(() {
                              chatMessages.add(
                                ChatMessage(
                                  userImage:
                                      'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                  userName: 'You',
                                  message: message, // 저장해둔 변수를 사용
                                ),
                              );
                              messageController.clear(); // TextField의 입력 값을 초기화
                            });

                            // 메시지를 API로 보내기
                            String chatGptMessage =
                                await chatRepository.sendMessage(
                              message: message, // 저장해둔 변수를 사용
                            );
                            // AI의 응답을 chatMessages에 추가
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
                        child: const Text('전송'), // 버튼에 표시될 텍스트
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
