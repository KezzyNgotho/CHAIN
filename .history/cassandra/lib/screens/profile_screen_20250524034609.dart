import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _starknetService = StarkNetService();
  bool _isLoading = true;
  Map<String, dynamic>? _profile;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final profile = await _starknetService
          .getUserProfile(_starknetService.userAddress ?? '');

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const ProfileEditDialog(),
    );

    if (result != null) {
      try {
        setState(() {
          _isLoading = true;
          _error = '';
        });

        await _starknetService.updateProfile(
          username: result['username']!,
          bio: result['bio']!,
          avatar: result['avatar']!,
          socialLinks: result['socialLinks']!,
        );

        await _loadProfile();
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No profile found', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Create Profile'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_profile!['avatar']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _profile!['username'],
                          style: theme.textTheme.headlineSmall,
                        ),
                        if (_profile!['isVerified'])
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.verified,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${_profile!['verificationLevel']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _updateProfile,
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bio
          Text(
            'Bio',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(_profile!['bio']),
          const SizedBox(height: 24),

          // Social Links
          Text(
            'Social Links',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(_profile!['socialLinks']),
          const SizedBox(height: 24),

          // Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stats',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _StatRow(
                    label: 'Total Curated',
                    value: _profile!['totalCurated'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Curation Score',
                    value: _profile!['curationScore'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Governance Power',
                    value:
                        '${(BigInt.parse(_profile!['governancePower']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Account Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Info',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _StatRow(
                    label: 'Created',
                    value: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(_profile!['createdAt']),
                    ).toString().split('.')[0],
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Last Updated',
                    value: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(_profile!['lastUpdated']),
                    ).toString().split('.')[0],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class ProfileEditDialog extends StatefulWidget {
  const ProfileEditDialog({super.key});

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _avatarController = TextEditingController();
  final _socialLinksController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _avatarController.dispose();
    _socialLinksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avatarController,
                decoration: const InputDecoration(
                  labelText: 'Avatar URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an avatar URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _socialLinksController,
                decoration: const InputDecoration(
                  labelText: 'Social Links (one per line)',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter social links';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'username': _usernameController.text,
                'bio': _bioController.text,
                'avatar': _avatarController.text,
                'socialLinks': _socialLinksController.text,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
