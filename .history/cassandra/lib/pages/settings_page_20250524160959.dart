import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              // TODO: Show help dialog
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: 'Dark',
                onTap: () {
                  // TODO: Show theme options
                },
              ),
              _SettingsTile(
                icon: Icons.text_fields_outlined,
                title: 'Text Size',
                subtitle: 'Medium',
                onTap: () {
                  // TODO: Show text size options
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account Settings
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  // TODO: Navigate to profile
                },
              ),
              _SettingsTile(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () {
                  // TODO: Navigate to security
                },
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Support
          _SettingsSection(
            title: 'Support',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Danger Zone
          _SettingsSection(
            title: 'Danger Zone',
            children: [
              _SettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                textColor: theme.colorScheme.error,
                onTap: () {
                  // TODO: Handle sign out
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor?.withOpacity(0.7) ?? Colors.white70,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
