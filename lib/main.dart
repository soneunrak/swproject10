// main.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'character_selection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => CharacterSelectionPage(
              onCharacterSelected: (character, personality, speechStyle) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      character: character,
                      personality: personality,
                      speechStyle: speechStyle,
                    ),
                  ),
                );
              },
            ),
        '/chat': (context) => ChatPage(
              character: '',
              personality: '',
              speechStyle: '',
            ),
      },
    );
  }
}

class ChatPage extends StatefulWidget {
  final String character;
  final String personality;
  final String speechStyle;

  ChatPage(
      {required this.character,
      required this.personality,
      required this.speechStyle});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _speechText = '';
  bool _messageSubmitted = false;
  Timer? _timer;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    print(
        'Character: ${widget.character}, Personality: ${widget.personality}, SpeechStyle: ${widget.speechStyle}');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    final messageUrl =
        Uri.parse('http://localhost:8000/connect_flutter/api/messages/');
    try {
      print(
          'Sending data: ${widget.character}, ${widget.personality}, ${widget.speechStyle}');
      final response = await http.post(
        messageUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': message,
          'character': widget.character,
          'personality': widget.personality,
          'speechStyle': widget.speechStyle,
        }),
      );
      if (response.statusCode == 201) {
        print('메세지 성공: $message');
        final responseData = json.decode(response.body);
        final gptResponse = responseData['gpt_response'];
        setState(() {
          messages.add('사용자 : $message');
          messages.add('답변: $gptResponse');
        });
        await _tts.speak(gptResponse); // GPT 답변 -> TTS
        _focusNode.requestFocus(); // 메시지 전송 후 포커스를 맞추기
      } else {
        print('메세지 실패, Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('오류 메시지: $e');
    }
  }

  void _submitMessage(String text) async {
    if (text.isNotEmpty && !_messageSubmitted) {
      _sendMessage(text);
      _controller.clear();
      _messageSubmitted = true;
      // 메시지 제출 후 플래그 초기화
      setState(() {
        _messageSubmitted = false;
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _startTimer(); // 2초 말없으면 중지 타이머
        _speech.listen(
          onResult: (val) {
            setState(() {
              _speechText = val.recognizedWords;
              _controller.text = _speechText;
            });
            _resetTimer(); // 타이머 리셋
            if (val.finalResult) {
              _submitMessage(_speechText); // 마이크 종료 채팅 전달
              _stopListening();
            }
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 2), () {
      if (_isListening) {
        _stopListening(); // 2초 동안 말 없으면 중지
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel(); // 타이머 취소
    _startTimer(); // 타이머 재설정
  }

  void _stopListening() {
    _speech.stop();
    _timer?.cancel(); // 타이머 취소
    setState(() {
      _isListening = false;
      _messageSubmitted = false; // 플래그 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SW 프로젝트 10 ${widget.character}'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.blueGrey : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode, // 포커스 노드 설정
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메세지를 입력해주세요.',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: _submitMessage,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueGrey),
                  onPressed: () => _submitMessage(_controller.text),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.blueGrey),
                  onPressed: _listen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
