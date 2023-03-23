import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_app/Constants/theme_color.dart';
import 'package:chatgpt_app/Providers/chat_provider.dart';
import 'package:chatgpt_app/Providers/modals_provider.dart';
import 'package:chatgpt_app/Services/assets_manager.dart';
import 'package:chatgpt_app/Services/bottom_sheet.dart';
import 'package:chatgpt_app/Widgets/chat_widget.dart';
import 'package:chatgpt_app/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = true;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController listScrollController;
  var isListening = false;
  SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  //List<ChatModal> chatListOut = [];
  @override
  Widget build(BuildContext context) {
    final modalsProvider = Provider.of<ModalsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text(
          'ChatGPT',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetManager.appLogoImage),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await BottomSheetWidget.ShowModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: listScrollController,
                scrollDirection: Axis.vertical,
                itemCount:
                    chatProvider.getChatList.length, //chatListOut.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider
                        .getChatList[index].msg, //chatListOut[index].msg,
                    chatIndex: chatProvider.getChatList[index]
                        .chatIndex, //chatListOut[index].chatIndex,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            AvatarGlow(
              endRadius: 30.0,
              animate: isListening,
              duration: Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              showTwoGlows: true,
              child: GestureDetector(
                onTapDown: (details) async {
                  if (!isListening) {
                    var avaliable = await speechToText.initialize();
                    if (avaliable) {
                      setState(() {
                        isListening = true;
                        speechToText.listen(onResult: (result) {
                          setState(() {
                            textEditingController.text = result.recognizedWords;
                          });
                        });
                      });
                    }
                  }
                },
                onTapUp: (dtails) {
                  setState(() {
                    isListening = false;
                  });
                  speechToText.stop();
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: scaffoldBackgroundColor,
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: textEditingController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 25,
                        onSubmitted: (value) async {
                          await sendMessageFunction(
                            modalsProvider: modalsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: 'How can I help you!',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFunction(
                          modalsProvider: modalsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFunction(
      {required ModalsProvider modalsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send mutiple messages at a time",
          ),
          backgroundColor: Colors.blueGrey,
        ),
      );
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send empty message",
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatListOut
        //     .add(ChatModal(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      print("Request has been sent");
      await chatProvider.sendBotAnsMessage(
        msg: msg,
        choosenModalId: modalsProvider.getCurrentModal,
      );
      // chatListOut.addAll(
      //   await ApIService.sendMessage(
      //     message: textEditingController.text,
      //     modelId: modalsProvider.getCurrentModal,
      //   ),
      // );
      setState(() {});
    } catch (error) {
      print("ERROR $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
