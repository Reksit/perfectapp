import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../common/loading_widget.dart';

class StudentHeatmapWidget extends StatefulWidget {
  const StudentHeatmapWidget({super.key});

  @override
  State<StudentHeatmapWidget> createState() => _StudentHeatmapWidgetState();
}

class _StudentHeatmapWidgetState extends State<StudentHeatmapWidget> {
  Map<String, dynamic>? _heatmapData;
  bool _loading = true;
  String _selectedTimeRange = '30';

  @override
  void initState() {
    super.initState();
    _loadHeatmapData();
  }

  Future<void> _loadHeatmapData() async {
    try {
      // Mock data for demonstration
      setState(() {
        _heatmapData = {
          'dailyTotals': {
            '2024-01-01': 5,
            '2024-01-02': 3,
            '2024-01-03': 8,
            '2024-01-04': 2,
            '2024-01-05': 6,
          },
          'totalActivities': 24,
          'activeDays': 5,
          'maxDaily': 8,
          'avgDaily': 4.8,
        };
        _loading = false;
      });
    } catch (error) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load student activity data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingWidget(message: 'Loading student activity data...');
    }

    if (_heatmapData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 64, color: AppTheme.textMuted),
            SizedBox(height: 16),
            Text(
              'No Student Activity Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Student activity data will appear here',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final dailyTotals = _heatmapData!['dailyTotals'] as Map<String, dynamic>? ?? {};
    final totalActivities = _heatmapData!['totalActivities'] ?? 0;
    final activeDays = _heatmapData!['activeDays'] ?? 0;
    final maxDaily = _heatmapData!['maxDaily'] ?? 0;
    final avgDaily = _heatmapData!['avgDaily'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Activity Heatmap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Student engagement and activity patterns',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard('Total Activities', totalActivities.toString(), AppTheme.primaryBlue),
              _buildStatCard('Active Days', activeDays.toString(), Colors.green),
              _buildStatCard('Max Daily', maxDaily.toString(), AppTheme.primaryPurple),
              _buildStatCard('Daily Average', avgDaily.toStringAsFixed(1), AppTheme.primaryOrange),
            ],
          ),

          const SizedBox(height: 20),

          // Activity Overview
          const Text(
            'Activity Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Weekly Activity Pattern',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActivityBar('Mon', 5),
                      _buildActivityBar('Tue', 3),
                      _buildActivityBar('Wed', 8),
                      _buildActivityBar('Thu', 2),
                      _buildActivityBar('Fri', 6),
                      _buildActivityBar('Sat', 1),
                      _buildActivityBar('Sun', 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBar(String day, int activity) {
    final maxActivity = 10;
    final height = (activity / maxActivity * 100).clamp(10.0, 100.0);

    return Column(
      children: [
        Expanded(
          child: Container(
            width: 20,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 16,
              height: height,
              decoration: BoxDecoration(
                color: _getActivityColor(activity),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getActivityColor(int count) {
    if (count == 0) return AppTheme.backgroundLight;
    if (count <= 2) return Colors.green.shade100;
    if (count <= 4) return Colors.green.shade300;
    if (count <= 6) return Colors.green.shade500;
    return Colors.green.shade700;
  }
}