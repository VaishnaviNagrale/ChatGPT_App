import 'dart:async';
import 'package:chatgpt_app/Constants/theme_color.dart';
import 'package:chatgpt_app/Screens/chat_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),() {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ChatScreen(),),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: scaffoldBackgroundColor,
        child:const Center(child: Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 25.0),),),
      ),
    );
  }
}