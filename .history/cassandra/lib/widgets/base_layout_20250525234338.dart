import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const BaseLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton ? null : const SizedBox.shrink(),
        actions: actions,
      ),
      body: child,
    );
  }
}
