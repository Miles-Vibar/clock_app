import 'package:flutter/material.dart';

import '../widgets/default_page_layout.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPageLayout(
        title: const Text(
          'Clock',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        children: [],
      ),
    );
  }
}
