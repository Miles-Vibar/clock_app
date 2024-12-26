import 'package:flutter/material.dart';

import '../widgets/default_page_layout.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPageLayout(
      title: const Text(
        'Timer',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      children: [],
    );
  }
}
