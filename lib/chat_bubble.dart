import 'package:flutter/material.dart';
import 'dart:io';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUserBot;


  ChatBubble({this.text, this.isUserBot});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      isUserBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: isUserBot
              ? EdgeInsets.fromLTRB(20, 16, 0, 0)
              : EdgeInsets.fromLTRB(0, 16, 16, 0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: isUserBot
                    ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))
                    : BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0))),
            color: isUserBot ? Color(0xffEFEFEF) : Colors.indigo,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Text(
                text,
                textAlign: isUserBot ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                    color: isUserBot ? Colors.black : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
