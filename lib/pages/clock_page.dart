import 'package:clock_app/widgets/custom_fab.dart';
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
        ),
        slivers: [],
      ),
      floatingActionButton: CustomFab(icon: Icons.add, onPressed: () => ()),
    );
  }
}
