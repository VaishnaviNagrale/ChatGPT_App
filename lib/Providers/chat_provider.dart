import 'package:chatgpt_app/Models/chat_modal.dart';
import 'package:chatgpt_app/Services/api_services.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModal> chatList = [];
  List<ChatModal> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModal(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendBotAnsMessage(
      {required String msg, required String choosenModalId}) async {
    chatList.addAll(
      await ApIService.sendMessage(
        message: msg,
        modelId: choosenModalId,
      ),
    );
    notifyListeners();
  }
}
