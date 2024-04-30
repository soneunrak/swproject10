import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final String gptApiKey = '';
  final String gptApiEndpoint = 'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions'; // GPT API 엔드포인트
  String responseMessage = '';

  Future<void> _sendMessage(String message) async {
  final url = Uri.parse('http://localhost:8000/connect_flutter/api/messages/');
  try {
    final response = await http.post(
      url,
      body: {'content': message},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('메세지 성공: $message');
      if (messages.isEmpty || messages.last != message) {
        setState(() {
          messages.add(message);
        });
      }
      _getBotResponse(message);
    } else {
      print('실패, Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('오류 메시지: $e');
  }
}

  Future<void> _getBotResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(gptApiEndpoint), // GPT API 엔드포인트 사용
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $gptApiKey'
        },
        body: jsonEncode({
          'prompt': message,
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // JSON 응답을 맵으로 디코딩
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // 필요한 데이터 추출
        final String botResponse = responseData['choices'][0]['text'];
        setState(() {
          responseMessage = botResponse;
          messages.add(responseMessage);
        });
      } else {
        print('GPT API 요청 실패, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('GPT API 오류: $e');
    }
  }

  void _submitMessage(String text) {
    if (text.isNotEmpty) {
      _sendMessage(text);
      setState(() {
        messages.add(text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SWproject10'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    // User's message
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(20),
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
                  } else {
                    // Bot's response
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
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
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메세지를 입력해주세요.',
                      ),
                      onSubmitted: _submitMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _submitMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}