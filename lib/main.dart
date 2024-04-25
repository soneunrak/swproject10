import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final url = Uri.parse('http://localhost:8000/connect_flutter/api/messages/');
  try {
    final response = await http.post(
      url,
      body: {'content': message},
    );
    if (response.statusCode == 200) {
      print('메세지 성공: $message'); // 메시지 출력
    } else {
      print('실패, Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('오류 메시지: $e');
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
                  return Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
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
