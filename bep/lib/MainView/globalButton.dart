import 'package:flutter/material.dart';

class globalButton extends StatelessWidget {
  final bool isQuizOpen;
  final ValueChanged<bool> onToggleActive;

  globalButton({
    required this.isQuizOpen,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
        child: IconButton(
          iconSize: 40,
          icon: Image.asset('assets/images/global.gif'),
          onPressed: () {
            onToggleActive(!isQuizOpen);
          },
        ),
      ),
    );
  }
}
