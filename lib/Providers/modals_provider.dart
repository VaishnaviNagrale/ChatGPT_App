import 'package:chatgpt_app/Models/modals_models.dart';
import 'package:chatgpt_app/Services/api_services.dart';
import 'package:flutter/material.dart';

class ModalsProvider with ChangeNotifier {
  List<ModalModel> modalsList = [];
  String currentModel = "text-davinci-003";
  List<ModalModel> get getModalList {
    return modalsList;
  }

  String get getCurrentModal {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<ModalModel>> getModals() async {
    modalsList = await ApIService.getModels();
    return modalsList;
  }
}
