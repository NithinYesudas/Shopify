import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int value;

  const Badge({required this.child, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), color: Colors.red),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontFamily: 'dmsansregular'),
            ),
          ),
        )
      ],
    );
  }
}
