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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
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
                Text('캐릭터 선택', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 40),
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
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(personality, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(speechStyle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
          ],
        ),
      ),
    );
  }
}
