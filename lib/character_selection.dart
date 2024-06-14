// character_selection.dart

import 'package:flutter/material.dart';
import 'main.dart'; // ChatPage를 정의한 파일을 import

class CharacterSelectionPage extends StatelessWidget {
  final Function(String, String, String) onCharacterSelected;

  CharacterSelectionPage({required this.onCharacterSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캐릭터 선택'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/personaselection.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6), // 오버레이
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('캐릭터 선택',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _characterCard('의사소통 전문가 김교수', 'assets/Professor_Kim.webp',
                        '이해심 많고 설득력이 뛰어남', '명확하고 이해하기 쉬운 언어를 사용', context),
                    _characterCard('혁신가 이박사', 'assets/Innovator_Lee.webp',
                        '창의적이고 도전적인 성격', '신선하고 혁신적인 아이디어를 제시', context),
                    _characterCard('건강 전문가 박트레이너', 'assets/Trainer_Park.webp',
                        '활기차고 긍정적인 성격', '항상 격려하고 동기부여', context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterCard(String name, String imagePath, String personality,
      String speechStyle, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Character selected: $name, $personality, $speechStyle');
        onCharacterSelected(name, personality, speechStyle);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              character: name,
              personality: personality,
              speechStyle: speechStyle,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 220, // 카드의 너비를 넓게 설정
          height: 340, // 카드의 높이를 늘려서 텍스트가 잘리지 않도록 설정
          padding: EdgeInsets.all(16.0), // 카드 내부의 패딩 설정
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath,
                    width: 150, height: 180, fit: BoxFit.cover), // 이미지 크기 확대
              ),
              SizedBox(height: 8), // 이미지와 텍스트 사이의 간격
              Text(name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(personality,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              SizedBox(height: 4),
              Text(speechStyle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
