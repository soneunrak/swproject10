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

  Future<void> _sendMessage(String message) async {
    final messageUrl = Uri.parse('http://localhost:8000/connect_flutter/api/messages/');
    try {
      final response = await http.post(
        messageUrl,
        body: {'content': message},
      );
      if (response.statusCode == 201) {
        print('메세지 성공: $message');
        final responseData = json.decode(response.body);
        final gptResponse = responseData['gpt_response'];
        setState(() {
          messages.add('사용자 : $message');
          messages.add('GPT답번 : $gptResponse');
        });
      } else {
        print('메세지 실패, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 메시지: $e');
    }
  }

  void _submitMessage(String text) async {
    if (text.isNotEmpty) {
      _sendMessage(text);
      _controller.clear();
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
                  return Align(
                    alignment: index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.blueGrey : Colors.green,
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
