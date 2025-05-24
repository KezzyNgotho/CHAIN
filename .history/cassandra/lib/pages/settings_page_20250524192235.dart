import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';
  double _fontSize = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        elevation: 0,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SectionHeader(
            title: 'Appearance',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsSwitch(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    // TODO: Implement theme change
                  },
                ),
                const Divider(),
                _SettingsSlider(
                  title: 'Font Size',
                  subtitle: 'Adjust text size',
                  value: _fontSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                    // TODO: Implement font size change
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _SectionHeader(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsSwitch(
                  title: 'Enable Notifications',
                  subtitle: 'Receive alerts and updates',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    // TODO: Implement notifications toggle
                  },
                ),
                const Divider(),
                _SettingsSwitch(
                  title: 'Market Updates',
                  subtitle: 'Get notified about market changes',
                  value: _notificationsEnabled,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          // TODO: Implement market notifications toggle
                        }
                      : null,
                ),
                const Divider(),
                _SettingsSwitch(
                  title: 'Governance Alerts',
                  subtitle: 'Receive governance proposal updates',
                  value: _notificationsEnabled,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          // TODO: Implement governance notifications toggle
                        }
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Security Section
          _SectionHeader(
            title: 'Security',
            icon: Icons.security_outlined,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsSwitch(
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face ID',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                    // TODO: Implement biometric toggle
                  },
                ),
                const Divider(),
                _SettingsButton(
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {
                    // TODO: Navigate to password change
                  },
                ),
                const Divider(),
                _SettingsButton(
                  title: 'Export Private Key',
                  subtitle: 'Backup your wallet key',
                  onTap: () {
                    // TODO: Navigate to key export
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preferences Section
          _SectionHeader(
            title: 'Preferences',
            icon: Icons.settings_outlined,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsDropdown<String>(
                  title: 'Currency',
                  subtitle: 'Select your preferred currency',
                  value: _selectedCurrency,
                  items: const [
                    DropdownMenuItem(
                      value: 'USD',
                      child: Text('USD'),
                    ),
                    DropdownMenuItem(
                      value: 'EUR',
                      child: Text('EUR'),
                    ),
                    DropdownMenuItem(
                      value: 'GBP',
                      child: Text('GBP'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                      // TODO: Implement currency change
                    }
                  },
                ),
                const Divider(),
                _SettingsDropdown<String>(
                  title: 'Language',
                  subtitle: 'Select your preferred language',
                  value: _selectedLanguage,
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'Spanish',
                      child: Text('Spanish'),
                    ),
                    DropdownMenuItem(
                      value: 'French',
                      child: Text('French'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      // TODO: Implement language change
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(
            title: 'About',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsButton(
                  title: 'Version',
                  subtitle: '1.0.0',
                  onTap: null,
                ),
                const Divider(),
                _SettingsButton(
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () {
                    // TODO: Navigate to terms
                  },
                ),
                const Divider(),
                _SettingsButton(
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Danger Zone
          _SectionHeader(
            title: 'Danger Zone',
            icon: Icons.warning_amber_outlined,
            color: Colors.red,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsButton(
                  title: 'Clear Cache',
                  subtitle: 'Remove temporary data',
                  onTap: () {
                    // TODO: Implement cache clearing
                  },
                  isDestructive: true,
                ),
                const Divider(),
                _SettingsButton(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap: () {
                    // TODO: Navigate to account deletion
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: child,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SettingsSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsButton({
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? Colors.red : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: isDestructive ? Colors.red : Colors.white70,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDropdown<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const _SettingsDropdown({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
