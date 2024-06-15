import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MasgWidgets extends StatelessWidget {
  const MasgWidgets(
      {super.key,
      required this.iamge,
      required this.fromuser,
      required this.text});
  final Image? iamge;
  final bool fromuser;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          fromuser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        fromuser
            ? SizedBox()
            : const CircleAvatar(
                backgroundImage: AssetImage("assets/bot.png"),
                radius: 15,
              ),
        Flexible(
            child: Container(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: fromuser ? Colors.white : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (text case final text?)
                  MarkdownBody(
                      data: text,
                      styleSheet: MarkdownStyleSheet(
                        a: TextStyle(
                          color: fromuser ? Colors.black : Colors.white,
                        ),
                      )),
                if (iamge case final image?) image
              ],
            ),
          ),
        ))
      ],
    );
  }
}
