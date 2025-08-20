import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final double childAspectRatio;

  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.spacing = 10,
    this.runSpacing = 10,
    this.mobileCrossAxisCount = 1,
    this.tabletCrossAxisCount = 2,
    this.childAspectRatio = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mobileCrossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
      tablet: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: tabletCrossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}
