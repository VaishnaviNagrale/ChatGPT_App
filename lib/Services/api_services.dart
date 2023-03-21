import 'dart:io';
import 'package:chatgpt_app/Models/chat_modal.dart';
import 'package:chatgpt_app/Models/modals_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chatgpt_app/Constants/api_constants.dart';

class ApIService {
  // for getting modals :
  static Future<List<ModalModel>> getModels() async {
    try {
      http.Response response =
          await http.get(Uri.parse("$Base_Url/models"), headers: {
        "Authorization": "Bearer $ApI_Key",
      });
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var element in jsonResponse["data"]) {
        temp.add(element);
        //print("temp ${element["id"]}");
      }
      return ModalModel.modalSnapshot(temp);
    } catch (error) {
      print("ERROR $error");
      rethrow;
    }
  }

  // for getting messages
  static Future<List<ChatModal>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$Base_Url/chat/completions"),
        headers: {
          "Authorization": "Bearer $ApI_Key",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
            // {"model": modelId, "prompt": message, "max_tokens": 100}
            {
              "model": modelId,
              "messages": [
                {"role": "user", "content": message },
              ]
            }),
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModal> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // print(
        //     "jsonResponse[choices][text] ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModal(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      print("ERROR $error");
      rethrow;
    }
  }
}
