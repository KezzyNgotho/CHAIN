import 'package:flutter/material.dart';
import 'wallet_connect_button.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const BaseLayout({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> appBarActions = [
      const WalletConnectButton(),
      if (actions != null) ...actions!,
    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: appBarActions,
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        elevation: 0,
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}
