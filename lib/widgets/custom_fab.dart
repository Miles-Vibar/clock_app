import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({
    super.key,
    this.width,
    required this.icon,
    required this.onPressed,
  });

  final double? width;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 75,
      child: width == null ? AspectRatio(
        aspectRatio: 1 / 1,
        child: FilledButton(
          onPressed: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: 40,
            ),
          ),
        ),
      ) : FilledButton(
        onPressed: onPressed,
        child: Center(
          child: Icon(
            icon,
            size: 40,
          ),
        ),
      ),
    );
  }
}