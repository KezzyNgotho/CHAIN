import 'package:flutter/material.dart';
import '../pages/help_page.dart';
import '../pages/notifications_page.dart';
import '../pages/settings_page.dart';
import '../pages/create_market_page.dart';
import '../pages/liquidity_page.dart';
import '../pages/admin_page.dart';
import '../pages/governance_page.dart';
import '../pages/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: Icons.analytics_outlined,
      label: 'Markets',
      page: const CreateMarketPage(),
    ),
    _NavigationItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Liquidity',
      page: const LiquidityPage(),
    ),
    _NavigationItem(
      icon: Icons.how_to_vote_outlined,
      label: 'Governance',
      page: const GovernancePage(),
    ),
    _NavigationItem(
      icon: Icons.person_outline,
      label: 'Profile',
      page: const ProfilePage(),
    ),
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
        children: _navigationItems.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        destinations: _navigationItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget? _buildFloatingActionButton() {
    // Only show FAB on Markets page
    if (_currentIndex != 0) return null;

    return FloatingActionButton(
      onPressed: () {
        // TODO: Navigate to create market page
      },
      child: const Icon(Icons.add),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.page,
  });
} 