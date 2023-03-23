import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();
  static initTTS() {
    tts.setLanguage('hi-IN');
    tts.setPitch(1.0);
    tts.setSpeechRate(1.0);
  }

  static speak(String text) async {
    tts.setErrorHandler((error) {
      print(error);
    });
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}
