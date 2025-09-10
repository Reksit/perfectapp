import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../common/loading_widget.dart';
import '../common/custom_card.dart';

class ConnectionManagerWidget extends StatefulWidget {
  const ConnectionManagerWidget({super.key});

  @override
  State<ConnectionManagerWidget> createState() =>
      _ConnectionManagerWidgetState();
}

class _ConnectionManagerWidgetState extends State<ConnectionManagerWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = false;
  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _acceptedConnections = [];
  List<Map<String, dynamic>> _sentRequests = [];
  int _connectionCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadConnectionData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadConnectionData() async {
    setState(() {
      _loading = true;
    });

    try {
      // Load all connection data in parallel
      final futures = await Future.wait([
        ApiService.instance.getPendingConnectionRequests(),
        ApiService.instance.getAcceptedConnections(),
        ApiService.instance.getSentConnectionRequests(),
        ApiService.instance.getConnectionCount(),
      ]);

      setState(() {
        _pendingRequests = List<Map<String, dynamic>>.from(futures[0] as List);
        _acceptedConnections = List<Map<String, dynamic>>.from(
          futures[1] as List,
        );
        _sentRequests = List<Map<String, dynamic>>.from(futures[2] as List);
        _connectionCount = (futures[3] as Map<String, dynamic>)['count'] ?? 0;
      });
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to load connection data: ${e.toString()}',
        ToastType.error,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _acceptConnection(String connectionId) async {
    try {
      await ApiService.instance.acceptConnectionRequest(connectionId);
      context.read<ToastProvider>().showToast(
        'Connection accepted successfully',
        ToastType.success,
      );
      _loadConnectionData();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to accept connection: ${e.toString()}',
        ToastType.error,
      );
    }
  }

  Future<void> _rejectConnection(String connectionId) async {
    try {
      await ApiService.instance.rejectConnectionRequest(connectionId);
      context.read<ToastProvider>().showToast(
        'Connection rejected',
        ToastType.info,
      );
      _loadConnectionData();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to reject connection: ${e.toString()}',
        ToastType.error,
      );
    }
  }

  Future<void> _removeConnection(String connectionId) async {
    final confirmed = await _showConfirmDialog(
      'Remove Connection',
      'Are you sure you want to remove this connection?',
    );

    if (confirmed) {
      try {
        await ApiService.instance.removeConnection(connectionId);
        context.read<ToastProvider>().showToast(
          'Connection removed',
          ToastType.info,
        );
        _loadConnectionData();
      } catch (e) {
        context.read<ToastProvider>().showToast(
          'Failed to remove connection: ${e.toString()}',
          ToastType.error,
        );
      }
    }
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with stats
        CustomCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Manager',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your professional network',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_connectionCount',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      'Total Connections',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Pending (${_pendingRequests.length})',
              icon: const Icon(Icons.pending_actions, size: 20),
            ),
            Tab(
              text: 'Connections (${_acceptedConnections.length})',
              icon: const Icon(Icons.people, size: 20),
            ),
            Tab(
              text: 'Sent (${_sentRequests.length})',
              icon: const Icon(Icons.send, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPendingRequestsTab(),
              _buildConnectionsTab(),
              _buildSentRequestsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingRequestsTab() {
    if (_loading) {
      return const Center(child: LoadingWidget());
    }

    if (_pendingRequests.isEmpty) {
      return _buildEmptyState(
        Icons.inbox,
        'No Pending Requests',
        'You have no pending connection requests.',
      );
    }

    return ListView.builder(
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        return _buildPendingRequestCard(request);
      },
    );
  }

  Widget _buildConnectionsTab() {
    if (_loading) {
      return const Center(child: LoadingWidget());
    }

    if (_acceptedConnections.isEmpty) {
      return _buildEmptyState(
        Icons.people_outline,
        'No Connections',
        'Start connecting with alumni, professors, and students.',
      );
    }

    return ListView.builder(
      itemCount: _acceptedConnections.length,
      itemBuilder: (context, index) {
        final connection = _acceptedConnections[index];
        return _buildConnectionCard(connection);
      },
    );
  }

  Widget _buildSentRequestsTab() {
    if (_loading) {
      return const Center(child: LoadingWidget());
    }

    if (_sentRequests.isEmpty) {
      return _buildEmptyState(
        Icons.send_outlined,
        'No Sent Requests',
        'Your sent connection requests will appear here.',
      );
    }

    return ListView.builder(
      itemCount: _sentRequests.length,
      itemBuilder: (context, index) {
        final request = _sentRequests[index];
        return _buildSentRequestCard(request);
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestCard(Map<String, dynamic> request) {
    final sender = request['sender'] ?? {};

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: sender['profilePicture'] != null
                    ? NetworkImage(sender['profilePicture'])
                    : null,
                child: sender['profilePicture'] == null
                    ? Text(
                        (sender['name'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender['name'] ?? 'Unknown User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (sender['role'] != null) ...[
                      Text(
                        _formatRole(sender['role']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                    if (sender['department'] != null) ...[
                      Text(
                        sender['department'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (request['message'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request['message'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _rejectConnection(request['id']),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _acceptConnection(request['id']),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    final user =
        connection['user'] ??
        connection['recipient'] ??
        connection['sender'] ??
        {};

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: user['profilePicture'] != null
                ? NetworkImage(user['profilePicture'])
                : null,
            child: user['profilePicture'] == null
                ? Text(
                    (user['name'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] ?? 'Unknown User',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user['role'] != null) ...[
                  Text(
                    _formatRole(user['role']),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
                if (user['department'] != null) ...[
                  Text(
                    user['department'],
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'view':
                  _viewProfile(user);
                  break;
                case 'message':
                  _messageUser(user);
                  break;
                case 'remove':
                  _removeConnection(connection['id']);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'message',
                child: Row(
                  children: [
                    Icon(Icons.message, size: 18),
                    SizedBox(width: 8),
                    Text('Send Message'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.remove_circle, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Remove Connection',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentRequestCard(Map<String, dynamic> request) {
    final recipient = request['recipient'] ?? {};
    final status = request['status'] ?? 'pending';

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: recipient['profilePicture'] != null
                ? NetworkImage(recipient['profilePicture'])
                : null,
            child: recipient['profilePicture'] == null
                ? Text(
                    (recipient['name'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient['name'] ?? 'Unknown User',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (recipient['role'] != null) ...[
                  Text(
                    _formatRole(recipient['role']),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
                if (recipient['department'] != null) ...[
                  Text(
                    recipient['department'],
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStatusColor(status).withOpacity(0.3),
              ),
            ),
            child: Text(
              _formatStatus(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    switch (role.toUpperCase()) {
      case 'STUDENT':
        return 'Student';
      case 'PROFESSOR':
        return 'Professor';
      case 'ALUMNI':
        return 'Alumni';
      case 'MANAGEMENT':
        return 'Management';
      default:
        return role;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Declined';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewProfile(Map<String, dynamic> user) {
    Navigator.pushNamed(
      context,
      '/user-profile',
      arguments: {'userId': user['id']},
    );
  }

  void _messageUser(Map<String, dynamic> user) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {'userId': user['id'], 'userName': user['name']},
    );
  }
}
