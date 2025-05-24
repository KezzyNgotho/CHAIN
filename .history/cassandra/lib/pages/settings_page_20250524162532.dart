import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  bool _biometricEnabled = false;
  bool _autoLockEnabled = true;
  int _autoLockTimeout = 5; // minutes

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement settings loading
      // final settings = await starkNetService.getSettings();
      // setState(() {
      //   _darkModeEnabled = settings.darkModeEnabled;
      //   _notificationsEnabled = settings.notificationsEnabled;
      //   _selectedLanguage = settings.language;
      //   _selectedCurrency = settings.currency;
      //   _biometricEnabled = settings.biometricEnabled;
      //   _autoLockEnabled = settings.autoLockEnabled;
      //   _autoLockTimeout = settings.autoLockTimeout;
      // });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement settings saving
      // await starkNetService.updateSettings(
      //   darkModeEnabled: _darkModeEnabled,
      //   notificationsEnabled: _notificationsEnabled,
      //   language: _selectedLanguage,
      //   currency: _selectedCurrency,
      //   biometricEnabled: _biometricEnabled,
      //   autoLockEnabled: _autoLockEnabled,
      //   autoLockTimeout: _autoLockTimeout,
      // );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance
                  Text(
                    'Appearance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingCard(
                    title: 'Dark Mode',
                    subtitle: 'Enable dark theme for the app',
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SettingCard(
                    title: 'Language',
                    subtitle: 'Select your preferred language',
                    icon: Icons.language_outlined,
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: ['English', 'Spanish', 'French', 'German']
                          .map((language) => DropdownMenuItem(
                                value: language,
                                child: Text(language),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Notifications
                  Text(
                    'Notifications',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingCard(
                    title: 'Push Notifications',
                    subtitle:
                        'Receive updates about your markets and proposals',
                    icon: Icons.notifications_outlined,
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Currency
                  Text(
                    'Currency',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingCard(
                    title: 'Display Currency',
                    subtitle: 'Select your preferred currency',
                    icon: Icons.attach_money,
                    trailing: DropdownButton<String>(
                      value: _selectedCurrency,
                      items: ['USD', 'EUR', 'GBP', 'JPY', 'STRK']
                          .map((currency) => DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Security
                  Text(
                    'Security',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingCard(
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face ID to unlock the app',
                    icon: Icons.fingerprint_outlined,
                    trailing: Switch(
                      value: _biometricEnabled,
                      onChanged: (value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SettingCard(
                    title: 'Auto Lock',
                    subtitle: 'Automatically lock the app after inactivity',
                    icon: Icons.lock_outline,
                    trailing: Switch(
                      value: _autoLockEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoLockEnabled = value;
                        });
                      },
                    ),
                  ),
                  if (_autoLockEnabled) ...[
                    const SizedBox(height: 8),
                    _SettingCard(
                      title: 'Auto Lock Timeout',
                      subtitle: 'Set the timeout duration in minutes',
                      icon: Icons.timer_outlined,
                      trailing: DropdownButton<int>(
                        value: _autoLockTimeout,
                        items: [1, 5, 15, 30, 60]
                            .map((minutes) => DropdownMenuItem(
                                  value: minutes,
                                  child: Text('$minutes min'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _autoLockTimeout = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // About
                  Text(
                    'About',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AboutCard(
                    title: 'Version',
                    value: '1.0.0',
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: 8),
                  _AboutCard(
                    title: 'Terms of Service',
                    value: 'View',
                    icon: Icons.description_outlined,
                    onTap: () {
                      // TODO: Navigate to terms of service
                    },
                  ),
                  const SizedBox(height: 8),
                  _AboutCard(
                    title: 'Privacy Policy',
                    value: 'View',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      // TODO: Navigate to privacy policy
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget trailing;

  const _SettingCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _AboutCard({
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
