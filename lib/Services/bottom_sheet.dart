import 'package:chatgpt_app/Constants/theme_color.dart';
import 'package:chatgpt_app/Widgets/drop_down.dart';
import 'package:chatgpt_app/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget {
  static Future<void> ShowModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        backgroundColor: scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: 'Choose Model',
                    fontSize: 15,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ModalDropDownWidget(),
                ),
              ],
            ),
          );
        });
  }
}
