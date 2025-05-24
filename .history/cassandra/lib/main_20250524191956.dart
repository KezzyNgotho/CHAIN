import 'package:flutter/material.dart';
import 'pages/create_market_page.dart';
import 'pages/liquidity_page.dart';
import 'pages/admin_page.dart';
import 'pages/governance_page.dart';
import 'pages/profile_page.dart';
import 'pages/help_page.dart';
import 'pages/notifications_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cassandra',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.purple,
          tertiary: Colors.orange,
          surface: Colors.grey[900]!,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900]!.withOpacity(0.92),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const CreateMarketPage(),
    const LiquidityPage(),
    const GovernancePage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Liquidity',
          ),
          NavigationDestination(
            icon: Icon(Icons.how_to_vote_outlined),
            selectedIcon: Icon(Icons.how_to_vote),
            label: 'Governance',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Navigate to create market page
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// Universal App Bar Widget
class UniversalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;

  const UniversalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface.withOpacity(0.92),
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Universal Bottom Sheet Widget
class UniversalBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  const UniversalBottomSheet({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Universal Dialog Widget
class UniversalDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;

  const UniversalDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.contentPadding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
      contentPadding: contentPadding ?? const EdgeInsets.all(16),
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }
}

// Universal Snackbar Widget
class UniversalSnackBar extends SnackBar {
  final String message;
  final SnackBarAction? action;
  final Duration duration;
  final Color? backgroundColor;

  UniversalSnackBar({
    super.key,
    required this.message,
    this.action,
    this.duration = const Duration(seconds: 4),
    this.backgroundColor,
  }) : super(
          content: Text(message),
          action: action,
          duration: duration,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
}
