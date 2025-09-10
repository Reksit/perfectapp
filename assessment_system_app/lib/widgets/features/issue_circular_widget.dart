import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';
import '../common/custom_button.dart';
import '../common/custom_text_field.dart';

class IssueCircularWidget extends StatefulWidget {
  const IssueCircularWidget({super.key});

  @override
  State<IssueCircularWidget> createState() => _IssueCircularWidgetState();
}

class _IssueCircularWidgetState extends State<IssueCircularWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  List<String> _selectedRecipients = [];
  bool _loading = false;

  final List<String> _recipientTypes = [
    'ALL_STUDENTS',
    'ALL_PROFESSORS',
    'ALL_ALUMNI',
    'FINAL_YEAR_STUDENTS',
    'FIRST_YEAR_STUDENTS',
    'DEPARTMENT_SPECIFIC',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _issueCircular() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRecipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one recipient type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final circularData = {
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'recipientTypes': _selectedRecipients,
      };

      await ApiService.instance.createCircular(circularData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Circular issued successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form
      _titleController.clear();
      _bodyController.clear();
      setState(() => _selectedRecipients = []);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to issue circular: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.campaign, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Issue Circular',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Send important announcements to students and faculty',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Circular Form
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomTextField(
                    controller: _titleController,
                    label: 'Circular Title',
                    hintText: 'Enter a clear and descriptive title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Body
                  CustomTextField(
                    controller: _bodyController,
                    label: 'Circular Content',
                    hintText: 'Enter the detailed content of your circular...',
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Content is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Recipients
                  const Text(
                    'Select Recipients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recipientTypes.map((type) {
                      final isSelected = _selectedRecipients.contains(type);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedRecipients.remove(type);
                            } else {
                              _selectedRecipients.add(type);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryPurple
                                : AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryPurple
                                  : AppTheme.borderLight,
                            ),
                          ),
                          child: Text(
                            _formatRecipientType(type),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _loading ? 'Issuing Circular...' : 'Issue Circular',
                      onPressed: _loading ? null : _issueCircular,
                      variant: ButtonVariant.primary,
                      isLoading: _loading,
                      icon: Icons.send,
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

  String _formatRecipientType(String type) {
    return type.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}