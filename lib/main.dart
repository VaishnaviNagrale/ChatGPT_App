import 'package:chatgpt_app/Constants/theme_color.dart';
import 'package:chatgpt_app/Providers/chat_provider.dart';
import 'package:chatgpt_app/Providers/modals_provider.dart';
import 'package:chatgpt_app/Screens/splash_screen.dart';
import 'package:chatgpt_app/Widgets/tts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ModalsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ChatProvider();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
       home: const SplashScreen(),
      ),
    );
  }
}
