import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xFFF6F6F6),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0.0, 1.0),
              blurRadius: 5.0,
              spreadRadius: 0.2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? ("Untitled Task"),
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "no description",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF121212).withOpacity(0.5),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Todowidget extends StatelessWidget {
  final String text;
  final bool isDone;
  Todowidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            child: Icon(
              isDone
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: isDone ? Color(0xFFC22CFC) : Color(0xFFEC8374),
              size: 30,
            ),
          ),
          Flexible(
            child: Text(
              text ?? "{unnamed todo}",
              style: TextStyle(
                color: isDone ? Color(0xFFC22CFC) : Color(0xFFEC8374),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
