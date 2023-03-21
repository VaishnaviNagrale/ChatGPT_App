import 'package:chatgpt_app/Constants/theme_color.dart';
import 'package:chatgpt_app/Models/modals_models.dart';
import 'package:chatgpt_app/Providers/modals_provider.dart';
import 'package:chatgpt_app/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalDropDownWidget extends StatefulWidget {
  const ModalDropDownWidget({super.key});

  @override
  State<ModalDropDownWidget> createState() => _ModalDropDownWidgetState();
}

class _ModalDropDownWidgetState extends State<ModalDropDownWidget> {
  String? currentModal;
  @override
  Widget build(BuildContext context) {
    final modalsProvider = Provider.of<ModalsProvider>(context, listen: false);
    currentModal = modalsProvider.getCurrentModal;
    return FutureBuilder<List<ModalModel>>(
        future: modalsProvider.getModals(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextWidget(label: snapshot.error.toString());
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                      dropdownColor: scaffoldBackgroundColor,
                      iconEnabledColor: Colors.white,
                      items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                          value: snapshot.data![index].id,
                          child: TextWidget(
                            label: snapshot.data![index].id,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      value: currentModal,
                      onChanged: (value) {
                        setState(() {
                          currentModal = value.toString();
                        });
                        modalsProvider.setCurrentModel(value.toString());
                      }),
                );
        });
  }
}


// class DropdownButtonExample extends StatefulWidget {
//   const DropdownButtonExample({super.key});
//   @override
//   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// }
// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//   late String dropdownValue;
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ModalModel>>(
//       future: ApIService.getModels(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: TextWidget(label: snapshot.error.toString()));
//         }
//         return snapshot.data == null || snapshot.data!.isEmpty
//             ? SizedBox.shrink()
//             : DropdownButton<String>(
//                 value: snapshot.data![index].id,
//                 dropdownColor: scaffoldBackgroundColor,
//                 icon: const Icon(
//                   Icons.arrow_downward,
//                   color: Colors.white,
//                 ),
//                 elevation: 16,
//                 style: const TextStyle(color: Colors.white),
//                 underline: Container(
//                   height: 2,
//                   color: Colors.grey,
//                 ),
//                 onChanged: (String? value) {
//                   // This is called when the user selects an item.
//                   setState(() {
//                     dropdownValue = value!;
//                   });
//                 },
//                 items: snapshot.data![index].id.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: snapshot.data![index].id,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               );
//       },
//     );
//   }
// }
