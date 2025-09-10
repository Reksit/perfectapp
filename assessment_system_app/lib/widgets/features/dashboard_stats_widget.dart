import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../common/loading_widget.dart';
import '../common/custom_card.dart';

class DashboardStatsWidget extends StatefulWidget {
  const DashboardStatsWidget({super.key});

  @override
  State<DashboardStatsWidget> createState() => _DashboardStatsWidgetState();
}

class _DashboardStatsWidgetState extends State<DashboardStatsWidget> {
  bool _loading = true;
  Map<String, dynamic>? _statsData;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = context.read<AuthProvider>().user;
      Map<String, dynamic> data;

      switch (user?.role) {
        case 'STUDENT':
          data = await ApiService.instance.getStudentDashboardStats();
          break;
        case 'PROFESSOR':
          data = await ApiService.instance.getProfessorDashboardStats();
          break;
        case 'ALUMNI':
          data = await ApiService.instance.getAlumniDashboardStats();
          break;
        case 'MANAGEMENT':
          data = await ApiService.instance.getManagementDashboardStats();
          break;
        default:
          data = {};
      }

      setState(() {
        _statsData = data;
      });
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to load dashboard stats: ${e.toString()}',
        ToastType.error,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    if (_loading) {
      return const Center(child: LoadingWidget());
    }

    if (_statsData == null) {
      return const CustomCard(
        child: Center(child: Text('No statistics available')),
      );
    }

    switch (user?.role) {
      case 'STUDENT':
        return _buildStudentStats();
      case 'PROFESSOR':
        return _buildProfessorStats();
      case 'ALUMNI':
        return _buildAlumniStats();
      case 'MANAGEMENT':
        return _buildManagementStats();
      default:
        return const CustomCard(
          child: Center(child: Text('Role-specific statistics not available')),
        );
    }
  }

  Widget _buildStudentStats() {
    final stats = _statsData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Performance Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // First Row - Academic Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Completed Assessments',
                stats['completed_assessments']?.toString() ?? '0',
                Icons.assignment_turned_in,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Average Score',
                '${stats['average_score']?.toStringAsFixed(1) ?? '0.0'}%',
                Icons.trending_up,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Current Rank',
                '${stats['class_rank'] ?? 'N/A'}',
                Icons.emoji_events,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Second Row - Activity Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Attendance Rate',
                '${stats['attendance_rate']?.toStringAsFixed(1) ?? '0.0'}%',
                Icons.access_time,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Tasks',
                stats['active_tasks']?.toString() ?? '0',
                Icons.task,
                Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Connections',
                stats['connections_count']?.toString() ?? '0',
                Icons.people,
                Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessorStats() {
    final stats = _statsData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teaching Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Students',
                stats['total_students']?.toString() ?? '0',
                Icons.school,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Assessments',
                stats['active_assessments']?.toString() ?? '0',
                Icons.assignment,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Classes Teaching',
                stats['classes_count']?.toString() ?? '0',
                Icons.class_,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Average Performance',
                '${stats['class_average']?.toStringAsFixed(1) ?? '0.0'}%',
                Icons.analytics,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pending Reviews',
                stats['pending_reviews']?.toString() ?? '0',
                Icons.rate_review,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'This Month',
                stats['monthly_assessments']?.toString() ?? '0',
                Icons.calendar_month,
                Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlumniStats() {
    final stats = _statsData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alumni Network Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Network Connections',
                stats['connections_count']?.toString() ?? '0',
                Icons.people_outline,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Events Participated',
                stats['events_attended']?.toString() ?? '0',
                Icons.event,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Profile Views',
                stats['profile_views']?.toString() ?? '0',
                Icons.visibility,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Event Requests',
                stats['event_requests']?.toString() ?? '0',
                Icons.event_available,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Messages Sent',
                stats['messages_sent']?.toString() ?? '0',
                Icons.message,
                Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Years Since Graduation',
                stats['years_since_graduation']?.toString() ?? '0',
                Icons.school,
                Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagementStats() {
    final stats = _statsData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // First Row - User Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Students',
                stats['total_students']?.toString() ?? '0',
                Icons.school,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Professors',
                stats['total_professors']?.toString() ?? '0',
                Icons.person,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Alumni Network',
                stats['total_alumni']?.toString() ?? '0',
                Icons.people,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Second Row - Activity Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Active Assessments',
                stats['active_assessments']?.toString() ?? '0',
                Icons.assignment,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Events This Month',
                stats['monthly_events']?.toString() ?? '0',
                Icons.event,
                Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pending Approvals',
                stats['pending_approvals']?.toString() ?? '0',
                Icons.approval,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Third Row - System Health
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'System Uptime',
                '${stats['system_uptime']?.toStringAsFixed(1) ?? '99.9'}%',
                Icons.health_and_safety,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Data Usage',
                '${stats['data_usage'] ?? 'Low'}',
                Icons.data_usage,
                Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Sessions',
                stats['active_sessions']?.toString() ?? '0',
                Icons.wifi,
                Colors.cyan,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
