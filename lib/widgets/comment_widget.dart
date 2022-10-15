import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commenterBody;
  final String commenterImageUrl;
  const CommentWidget({
    super.key,
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commenterBody,
    required this.commenterImageUrl,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepOrange,
  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _colors[1],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.commenterImageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.commenterName,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade300,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.commenterBody,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
