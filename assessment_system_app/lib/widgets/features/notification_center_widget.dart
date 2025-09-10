import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../common/loading_widget.dart';
import '../common/custom_card.dart';

class NotificationCenterWidget extends StatefulWidget {
  const NotificationCenterWidget({super.key});

  @override
  State<NotificationCenterWidget> createState() =>
      _NotificationCenterWidgetState();
}

class _NotificationCenterWidgetState extends State<NotificationCenterWidget> {
  bool _loading = true;
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  String _selectedFilter = 'all';

  final List<String> _filters = [
    'all',
    'unread',
    'assessments',
    'events',
    'connections',
    'system',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await ApiService.instance.getNotifications(
        _selectedFilter,
      );
      setState(() {
        _notifications = response['notifications'] ?? [];
        _unreadCount = response['unread_count'] ?? 0;
      });
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to load notifications: ${e.toString()}',
        ToastType.error,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await ApiService.instance.markNotificationAsRead(notificationId);
      _loadNotifications(); // Refresh the list
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to mark notification as read',
        ToastType.error,
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ApiService.instance.markAllNotificationsAsRead();
      context.read<ToastProvider>().showToast(
        'All notifications marked as read',
        ToastType.success,
      );
      _loadNotifications();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to mark all as read',
        ToastType.error,
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await ApiService.instance.deleteNotification(notificationId);
      context.read<ToastProvider>().showToast(
        'Notification deleted',
        ToastType.success,
      );
      _loadNotifications();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to delete notification',
        ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        CustomCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Center',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_unreadCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$_unreadCount unread notifications',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (_unreadCount > 0) ...[
                    TextButton.icon(
                      onPressed: _markAllAsRead,
                      icon: const Icon(Icons.done_all, size: 18),
                      label: const Text('Mark all read'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    onPressed: _loadNotifications,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter Chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == _filters.length - 1 ? 0 : 8,
                ),
                child: FilterChip(
                  label: Text(_getFilterDisplayName(filter)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadNotifications();
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Notifications List
        if (_loading) ...[
          const Center(child: LoadingWidget()),
        ] else if (_notifications.isEmpty) ...[
          CustomCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFilter == 'unread'
                        ? 'No unread notifications'
                        : 'No notifications found',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll see new notifications here when they arrive',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] == true;
    final type = notification['type'] ?? 'system';
    final createdAt = DateTime.tryParse(notification['created_at'] ?? '');

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (!isRead) {
            _markAsRead(notification['id']);
          }
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead
                  ? Colors.transparent
                  : Theme.of(context).primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: _getNotificationColor(type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] ?? 'Notification',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                          ),
                        ),
                        if (!isRead) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (notification['message'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTimestamp(createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getNotificationColor(
                                  type,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getTypeDisplayName(type),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getNotificationColor(type),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 16),
                              onSelected: (value) {
                                switch (value) {
                                  case 'mark_read':
                                    _markAsRead(notification['id']);
                                    break;
                                  case 'delete':
                                    _deleteNotification(notification['id']);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                if (!isRead)
                                  const PopupMenuItem(
                                    value: 'mark_read',
                                    child: Row(
                                      children: [
                                        Icon(Icons.mark_email_read, size: 16),
                                        SizedBox(width: 8),
                                        Text('Mark as read'),
                                      ],
                                    ),
                                  ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All';
      case 'unread':
        return 'Unread';
      case 'assessments':
        return 'Assessments';
      case 'events':
        return 'Events';
      case 'connections':
        return 'Connections';
      case 'system':
        return 'System';
      default:
        return filter
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'assessment':
        return Icons.assignment;
      case 'event':
        return Icons.event;
      case 'connection':
        return Icons.people;
      case 'message':
        return Icons.message;
      case 'system':
        return Icons.settings;
      case 'achievement':
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'assessment':
        return Colors.blue;
      case 'event':
        return Colors.green;
      case 'connection':
        return Colors.purple;
      case 'message':
        return Colors.teal;
      case 'system':
        return Colors.orange;
      case 'achievement':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'assessment':
        return 'Assessment';
      case 'event':
        return 'Event';
      case 'connection':
        return 'Connection';
      case 'message':
        return 'Message';
      case 'system':
        return 'System';
      case 'achievement':
        return 'Achievement';
      default:
        return type
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    final data = notification['data'];

    // Navigate based on notification type
    switch (type) {
      case 'assessment':
        if (data?['assessment_id'] != null) {
          Navigator.pushNamed(
            context,
            '/assessment-details',
            arguments: {'assessmentId': data['assessment_id']},
          );
        }
        break;
      case 'event':
        if (data?['event_id'] != null) {
          Navigator.pushNamed(
            context,
            '/event-details',
            arguments: {'eventId': data['event_id']},
          );
        }
        break;
      case 'connection':
        if (data?['user_id'] != null) {
          Navigator.pushNamed(
            context,
            '/user-profile',
            arguments: {'userId': data['user_id']},
          );
        }
        break;
      case 'message':
        if (data?['user_id'] != null) {
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: {'userId': data['user_id']},
          );
        }
        break;
    }
  }
}
