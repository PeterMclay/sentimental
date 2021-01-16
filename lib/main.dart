import 'package:flutter/material.dart';
import 'package:sentimental/screens/voice_input_screen.dart';

void main() => runApp(Sentimental());

class Sentimental extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: VoiceInputScreen.id, routes: {
      VoiceInputScreen.id: (context) => VoiceInputScreen(),
    });
  }
}
