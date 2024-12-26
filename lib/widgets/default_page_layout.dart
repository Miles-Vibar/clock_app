import 'package:flutter/material.dart';

class DefaultPageLayout extends StatelessWidget {
  const DefaultPageLayout({
    super.key,
    required this.title,
    required this.children,
    this.physics,
  });

  final Widget title;
  final List<Widget> children;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          expandedHeight: 150.0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          flexibleSpace: FlexibleSpaceBar(
            title: title,
            titlePadding: const EdgeInsets.only(
              left: 16.0,
              bottom: 16.0,
            ),
            expandedTitleScale: 2.0,
            background: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        for (Widget child in children)
          child,
      ],
    );
  }
}
