import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../../models/user_model.dart';
import '../common/loading_widget.dart';
import '../common/custom_button.dart';
import '../common/custom_card.dart';

class AIStudentAnalysisWidget extends StatefulWidget {
  const AIStudentAnalysisWidget({super.key});

  @override
  State<AIStudentAnalysisWidget> createState() =>
      _AIStudentAnalysisWidgetState();
}

class _AIStudentAnalysisWidgetState extends State<AIStudentAnalysisWidget> {
  bool _loading = false;
  List<Map<String, dynamic>> _analysisResults = [];
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  String _selectedAnalysisType = 'skills';

  final List<String> _analysisTypes = [
    'skills',
    'performance',
    'potential',
    'recommendations',
  ];

  @override
  void dispose() {
    _queryController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _performAnalysis() async {
    if (_queryController.text.trim().isEmpty) {
      context.read<ToastProvider>().showToast(
        'Please enter analysis criteria',
        ToastType.error,
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      Map<String, dynamic> results;

      if (_selectedAnalysisType == 'skills') {
        results = await ApiService.instance.analyzeStudentsBySkills(
          _queryController.text.trim(),
        );
      } else {
        results = await ApiService.instance.searchStudentProfiles({
          'query': _queryController.text.trim(),
          'type': _selectedAnalysisType,
          'skills': _skillsController.text
              .trim()
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
        });
      }

      setState(() {
        _analysisResults = List<Map<String, dynamic>>.from(
          results['students'] ?? [],
        );
      });

      if (_analysisResults.isEmpty) {
        context.read<ToastProvider>().showToast(
          'No students found matching the criteria',
          ToastType.info,
        );
      } else {
        context.read<ToastProvider>().showToast(
          'Analysis completed successfully',
          ToastType.success,
        );
      }
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Analysis failed: ${e.toString()}',
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
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI-Powered Student Analysis',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Analysis Type Selector
              Text(
                'Analysis Type',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedAnalysisType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: _analysisTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type
                              .split('_')
                              .map(
                                (word) =>
                                    word[0].toUpperCase() + word.substring(1),
                              )
                              .join(' '),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAnalysisType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Query Input
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  labelText: 'Analysis Query',
                  hintText: 'Enter your analysis criteria or question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Skills Input (for skills analysis)
              if (_selectedAnalysisType == 'skills') ...[
                TextField(
                  controller: _skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Skills (Optional)',
                    hintText: 'Enter skills separated by commas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              CustomButton(
                onPressed: _loading ? null : _performAnalysis,
                text: _loading ? 'Analyzing...' : 'Perform Analysis',
                icon: _loading ? null : Icons.analytics,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Results Section
        if (_loading) ...[
          const Center(child: LoadingWidget()),
        ] else if (_analysisResults.isNotEmpty) ...[
          Text(
            'Analysis Results (${_analysisResults.length} students)',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _analysisResults.length,
            itemBuilder: (context, index) {
              final student = _analysisResults[index];
              return _buildStudentCard(student);
            },
          ),
        ] else if (_queryController.text.isNotEmpty) ...[
          const CustomCard(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  (student['name'] ?? 'Student')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'] ?? 'Unknown Student',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      student['email'] ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (student['match_score'] != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor(student['match_score']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${student['match_score']}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Student Details
          if (student['department'] != null) ...[
            _buildDetailRow('Department', student['department']),
          ],
          if (student['className'] != null) ...[
            _buildDetailRow('Class', student['className']),
          ],
          if (student['skills'] != null) ...[
            _buildSkillsRow(student['skills']),
          ],
          if (student['gpa'] != null) ...[
            _buildDetailRow('GPA', student['gpa'].toString()),
          ],
          if (student['analysis_notes'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Analysis',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['analysis_notes'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewStudentProfile(student),
                  icon: const Icon(Icons.person, size: 18),
                  label: const Text('View Profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactStudent(student),
                  icon: const Icon(Icons.message, size: 18),
                  label: const Text('Contact'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsRow(List<dynamic> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (skill) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    skill.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _viewStudentProfile(Map<String, dynamic> student) {
    // Navigate to student profile
    Navigator.pushNamed(
      context,
      '/student-profile',
      arguments: {'studentId': student['id']},
    );
  }

  void _contactStudent(Map<String, dynamic> student) {
    // Navigate to chat or contact
    Navigator.pushNamed(context, '/chat', arguments: {'userId': student['id']});
  }
}
