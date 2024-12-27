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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: width,
        height: 75,
        child: width == null
            ? AspectRatio(
                aspectRatio: 1 / 1,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon,
                    size: 40,
                  ),
                ),
              )
            : IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  size: 40,
                ),
              ),
      ),
    );
  }
}
