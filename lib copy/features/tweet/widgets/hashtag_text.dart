import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:courtfinder/features/tweet/views/hashtag_view.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:markdown/markdown.dart' as md;
// import 'package:flutter_markdown/flutter_markdown.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    // final v = Markdown(data: text);
    // return textspans

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.orangeColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  HashtagView.route(element),
                );
              },
          ),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
        // Handle markdown lists
      } else if (element.startsWith('-')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(color: Pallete.blackColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      } else if (element.startsWith('*') && element.endsWith('*')) {
        // Handle markdown bold text
        textspans.add(
          TextSpan(
            text: '${element.substring(1, element.length - 1)} ',
            style: const TextStyle(
              color: Pallete.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (element.startsWith('_') && element.endsWith('_')) {
        // Handle markdown italic text
        textspans.add(
          TextSpan(
            text: '${element.substring(1, element.length - 1)} ',
            style: const TextStyle(
              color: Pallete.blackColor,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      } else if (element.startsWith('~~') && element.endsWith('~~')) {
        // Handle markdown strike through text
        textspans.add(
          TextSpan(
            text: '${element.substring(2, element.length - 2)} ',
            style: const TextStyle(
              color: Pallete.blackColor,
              fontSize: 18,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        );
      } else if (element.startsWith('==') && element.endsWith('==')) {
        // Handle markdown highlight text
        textspans.add(
          TextSpan(
            text: '${element.substring(2, element.length - 2)} ',
            style: const TextStyle(
              color: Pallete.blackColor,
              fontSize: 18,
              backgroundColor: Colors.yellow,
            ),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blackColor,
              fontSize: 18,
            ),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(
        children: textspans,
      ),
    );
  }
}
