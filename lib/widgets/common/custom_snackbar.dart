import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final Function callBack;
  final Function undoCallBack;
  final String text;
  final bool undoable;
  CustomSnackBar({
    this.callBack,
    this.undoCallBack,
    this.text,
    this.undoable,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text(text),
            action: undoable
                ? SnackBarAction(
                    label: 'Annuler',
                    onPressed: undoCallBack,
                  )
                : null,
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}
