import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.time,
    required this.location,
    this.trailing,
  });

  final DateTime time;
  final String location;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      tileColor: Theme.of(context).colorScheme.onPrimary,
      title: Row(
        children: [
          Text(
            '${DateFormat('hh:mm a').format(time)} ',
            textScaler: const TextScaler.linear(2.0),
          ),
          Text(location)
        ],
      ),
      subtitle: Text(DateFormat.yMMMd().format(time)),
      trailing: trailing,
    );
  }
}
