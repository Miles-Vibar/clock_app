import 'package:flutter/material.dart';

import '../widgets/default_page_layout.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPageLayout(
      title: const Text('Alarm'),
      children: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                title: Text(
                  'Item ${1 + index}',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
