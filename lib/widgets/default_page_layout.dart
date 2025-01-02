import 'package:flutter/material.dart';

class DefaultPageLayout extends StatelessWidget {
  const DefaultPageLayout({
    super.key,
    required this.title,
    required this.slivers,
    this.physics,
  });

  final Widget title;
  final List<Widget> slivers;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          floating: false,
          expandedHeight: 150.0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          flexibleSpace: FlexibleSpaceBar(
            title: title,
            centerTitle: true,
            titlePadding: const EdgeInsets.only(
              bottom: 16.0,
            ),
            expandedTitleScale: 2.0,
            background: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        for (Widget child in slivers)
          child,
      ],
    );
  }
}
