
class ModalModel {
  final String id;
  final String root;
  final int created;

  ModalModel({
    required this.id,
    required this.root,
    required this.created,
  });

  factory ModalModel.fromJson(Map<String, dynamic> json) {
    return ModalModel(
        id: json["id"], root: json["root"], created: json["created"]);
  }
  static List<ModalModel> modalSnapshot(List modalSnapshot) {
    return modalSnapshot.map((data) => ModalModel.fromJson(data)).toList();
  }
}
