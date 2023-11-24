import 'package:flutter/material.dart';

Future<bool?> showConfirmDialong(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Bạn có chắc'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Không'),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        TextButton(
          child: const Text('Đòng ý'),
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('An Error Occurred!'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Đồng ý'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
