import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = false;
  final List<_NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement notifications loading
      // final notifications = await starkNetService.getNotifications();
      // setState(() {
      //   _notifications.clear();
      //   _notifications.addAll(notifications.map((n) => _NotificationItem(
      //         id: n.id,
      //         title: n.title,
      //         message: n.message,
      //         type: n.type,
      //         timestamp: n.timestamp,
      //         read: n.read,
      //       )));
      // });

      // Temporary mock data
      setState(() {
        _notifications.clear();
        _notifications.addAll([
          _NotificationItem(
            id: '1',
            title: 'Market Resolved',
            message: 'Your market "Will BTC reach \$100k?" has been resolved.',
            type: NotificationType.market,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            read: false,
          ),
          _NotificationItem(
            id: '2',
            title: 'New Proposal',
            message: 'A new governance proposal has been created.',
            type: NotificationType.governance,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            read: true,
          ),
          _NotificationItem(
            id: '3',
            title: 'Liquidity Reward',
            message: 'You earned 50 STRK from liquidity provision.',
            type: NotificationType.reward,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            read: true,
          ),
        ]);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
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

  Future<void> _markAsRead(String id) async {
    try {
      // TODO: Implement mark as read
      // await starkNetService.markNotificationAsRead(id);
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(read: true);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error marking notification as read: $e')),
        );
      }
    }
  }

  Future<void> _deleteNotification(String id) async {
    try {
      // TODO: Implement delete notification
      // await starkNetService.deleteNotification(id);
      setState(() {
        _notifications.removeWhere((n) => n.id == id);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting notification: $e')),
        );
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
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () => _markAsRead(notification.id),
                      onDelete: () => _deleteNotification(notification.id),
                    );
                  },
                ),
    );
  }
}

enum NotificationType {
  market,
  governance,
  reward,
  system,
}

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool read;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.read,
  });

  _NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? read,
  }) {
    return _NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.red,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: _getTypeColor(notification.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: notification.read
                                    ? Colors.white70
                                    : Colors.white,
                              ),
                            ),
                          ),
                          if (!notification.read)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.market:
        return Colors.blue;
      case NotificationType.governance:
        return Colors.purple;
      case NotificationType.reward:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.market:
        return Icons.analytics_outlined;
      case NotificationType.governance:
        return Icons.how_to_vote_outlined;
      case NotificationType.reward:
        return Icons.attach_money;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
} 