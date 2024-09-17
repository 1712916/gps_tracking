import 'package:flutter/material.dart';
import 'package:gps_speed/widget/request_permission_dialog/request_location_service_dialog.dart';

class OpenSettingDialog extends StatelessWidget with ShowDialog {
  const OpenSettingDialog({
    super.key,
    this.titleString,
    this.contentString,
    required this.onConfirm,
  });

  final String? titleString;
  final String? contentString;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(titleString ?? 'Open setting'),
      content: Text(contentString ?? 'This function need granted permission'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Oke'),
        ),
      ],
    );
  }
}
