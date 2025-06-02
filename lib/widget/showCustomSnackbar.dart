import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String text) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).viewPadding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: const Color.fromARGB(0, 247, 247, 247),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF7C3AED),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 3)).then((_) => overlayEntry.remove());
}
