import 'package:flutter/material.dart';

class DismissInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 16.0),
      color: Colors.grey.withOpacity(0.8),
      child: Text(
        'Swipe left to delete',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
