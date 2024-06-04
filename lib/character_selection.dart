import 'package:flutter/material.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('캐릭터 선택', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _characterCard('캐릭터1', 'assets/character1.jpg', '까칠함', 'Casual', context),
              _characterCard('캐릭터2', 'assets/character2.jpg', '다정함', 'Formal', context),
              _characterCard('캐릭터3', 'assets/character3.jpg', '소심함', 'Humorous', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _characterCard(String name, String imagePath, String personality, String speechStyle, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCharacterSelected(name, personality, speechStyle);
        Navigator.pushReplacementNamed(context, '/chat');
      },
      child: Column(
        children: [
          Image.asset(imagePath, width: 100, height: 100),
          Text(name, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
