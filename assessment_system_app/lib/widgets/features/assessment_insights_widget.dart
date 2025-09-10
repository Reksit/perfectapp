import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../common/loading_widget.dart';
import '../common/custom_card.dart';

class AssessmentInsightsWidget extends StatefulWidget {
  const AssessmentInsightsWidget({super.key});

  @override
  State<AssessmentInsightsWidget> createState() =>
      _AssessmentInsightsWidgetState();
}

class _AssessmentInsightsWidgetState extends State<AssessmentInsightsWidget> {
  bool _loading = true;
  Map<String, dynamic>? _insightsData;
  String _selectedTimeRange = '30';
  String _selectedMetric = 'performance';

  final List<String> _timeRanges = ['7', '30', '90', '365'];
  final List<String> _metrics = ['performance', 'participation', 'difficulty'];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = context.read<AuthProvider>().user;
      Map<String, dynamic> data;

      if (user?.role == 'STUDENT') {
        data = await ApiService.instance.getStudentAssessmentInsights(
          _selectedTimeRange,
        );
      } else if (user?.role == 'PROFESSOR') {
        data = await ApiService.instance.getProfessorAssessmentInsights(
          _selectedTimeRange,
        );
      } else {
        data = await ApiService.instance.getManagementAssessmentInsights(
          _selectedTimeRange,
        );
      }

      setState(() {
        _insightsData = data;
      });
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to load assessment insights: ${e.toString()}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header and Controls
        CustomCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assessment Insights',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedTimeRange,
                    items: _timeRanges
                        .map(
                          (range) => DropdownMenuItem(
                            value: range,
                            child: Text('${range} days'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeRange = value!;
                      });
                      _loadInsights();
                    },
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedMetric,
                    items: _metrics
                        .map(
                          (metric) => DropdownMenuItem(
                            value: metric,
                            child: Text(
                              metric
                                  .split('_')
                                  .map(
                                    (word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1),
                                  )
                                  .join(' '),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMetric = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_loading) ...[
          const Center(child: LoadingWidget()),
        ] else if (_insightsData != null) ...[
          // Key Metrics Cards
          _buildMetricsRow(),
          const SizedBox(height: 16),

          // Charts Section
          Row(
            children: [
              Expanded(child: _buildPerformanceChart()),
              const SizedBox(width: 16),
              Expanded(child: _buildDistributionChart()),
            ],
          ),
          const SizedBox(height: 16),

          // Detailed Analysis
          _buildDetailedAnalysis(),
        ],
      ],
    );
  }

  Widget _buildMetricsRow() {
    final stats = _insightsData!['stats'] as Map<String, dynamic>? ?? {};

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Assessments',
            stats['total'] ?? 0,
            Icons.assignment,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Average Score',
            '${stats['average_score']?.toStringAsFixed(1) ?? '0.0'}%',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Completion Rate',
            '${stats['completion_rate']?.toStringAsFixed(1) ?? '0.0'}%',
            Icons.check_circle,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Improvement',
            '${stats['improvement']?.toStringAsFixed(1) ?? '0.0'}%',
            Icons.trending_up,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    dynamic value,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    final chartData =
        _insightsData!['performance_trend'] as List<dynamic>? ?? [];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trend',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}d',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: chartData.length.toDouble() - 1,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['score']?.toDouble() ?? 0,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    final distribution =
        _insightsData!['score_distribution'] as Map<String, dynamic>? ?? {};

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Distribution',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: distribution['excellent']?.toDouble() ?? 0,
                    color: Colors.green,
                    title: 'A (90-100%)',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: distribution['good']?.toDouble() ?? 0,
                    color: Colors.blue,
                    title: 'B (80-89%)',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: distribution['average']?.toDouble() ?? 0,
                    color: Colors.orange,
                    title: 'C (70-79%)',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: distribution['below_average']?.toDouble() ?? 0,
                    color: Colors.red,
                    title: 'D (<70%)',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
    final analysis =
        _insightsData!['detailed_analysis'] as Map<String, dynamic>? ?? {};
    final recommendations =
        _insightsData!['recommendations'] as List<dynamic>? ?? [];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Analysis',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Strengths and Weaknesses
          if (analysis['strengths'] != null ||
              analysis['weaknesses'] != null) ...[
            Row(
              children: [
                if (analysis['strengths'] != null) ...[
                  Expanded(
                    child: _buildAnalysisSection(
                      'Strengths',
                      analysis['strengths'] as List<dynamic>,
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ),
                ],
                if (analysis['strengths'] != null &&
                    analysis['weaknesses'] != null)
                  const SizedBox(width: 16),
                if (analysis['weaknesses'] != null) ...[
                  Expanded(
                    child: _buildAnalysisSection(
                      'Areas for Improvement',
                      analysis['weaknesses'] as List<dynamic>,
                      Colors.red,
                      Icons.warning,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            Text(
              'Recommendations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recommendations
                .map(
                  (rec) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec.toString())),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(
    String title,
    List<dynamic> items,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 4),
                  child: Text('• $item'),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
