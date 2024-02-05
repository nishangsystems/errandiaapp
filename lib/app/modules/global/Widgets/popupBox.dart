import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

enum PopupType { success, error, warning }

class PopupBox extends StatelessWidget {
  final String title;
  final String description;
  final PopupType type;

   PopupBox({
    required this.title,
    required this.description,
    required this.type,
  });

  IconData _getIcon() {
    switch (type) {
      case PopupType.success:
        return Icons.check_circle;
      case PopupType.error:
        return Icons.error;
      case PopupType.warning:
        return Icons.warning;
    }
  }

  Color _getColor() {
    switch (type) {
      case PopupType.success:
        return Colors.green;
      case PopupType.error:
        return Colors.red;
      case PopupType.warning:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can return an empty container as the PopupBox widget doesn't need to build anything
    return Container();
  }

  // @override
  void showPopup(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: _getDialogType(),
      animType: AnimType.bottomSlide,
      title: title,
      width: 290,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      desc: description,
      btnOkOnPress: () {},

      headerAnimationLoop: false,
    ).show();
  }

  DialogType _getDialogType() {
    switch (type) {
      case PopupType.success:
        return DialogType.success;
      case PopupType.error:
        return DialogType.error;
      case PopupType.warning:
        return DialogType.warning;
    }
  }
}