import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final VoidCallback? onLike;

  const LikeButton({this.onLike});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : Colors.grey,
        size: 28,
      ),
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
        });
        widget.onLike?.call();
      },
    );
  }
}
