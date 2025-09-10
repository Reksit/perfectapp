import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toast_provider.dart';
import '../../services/api_service.dart';
import '../common/loading_widget.dart';
import '../common/custom_card.dart';
import '../common/custom_button.dart';

class AlumniVerificationWidget extends StatefulWidget {
  const AlumniVerificationWidget({super.key});

  @override
  State<AlumniVerificationWidget> createState() =>
      _AlumniVerificationWidgetState();
}

class _AlumniVerificationWidgetState extends State<AlumniVerificationWidget> {
  bool _loading = true;
  bool _submittingVerification = false;
  List<Map<String, dynamic>> _pendingVerifications = [];
  Map<String, dynamic>? _userVerificationStatus;

  @override
  void initState() {
    super.initState();
    _loadVerificationData();
  }

  Future<void> _loadVerificationData() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = context.read<AuthProvider>().user;

      if (user?.role == 'MANAGEMENT') {
        // Load all pending verifications for management
        final response = await ApiService.instance
            .getPendingAlumniVerifications();
        setState(() {
          _pendingVerifications = response;
        });
      } else if (user?.role == 'ALUMNI') {
        // Load verification status for alumni user
        final status = await ApiService.instance.getMyVerificationStatus();
        setState(() {
          _userVerificationStatus = status;
        });
      }
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to load verification data: ${e.toString()}',
        ToastType.error,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _submitVerificationRequest(
    Map<String, dynamic> verificationData,
  ) async {
    setState(() {
      _submittingVerification = true;
    });

    try {
      await ApiService.instance.submitAlumniVerification(verificationData);
      context.read<ToastProvider>().showToast(
        'Verification request submitted successfully',
        ToastType.success,
      );
      _loadVerificationData();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to submit verification: ${e.toString()}',
        ToastType.error,
      );
    } finally {
      setState(() {
        _submittingVerification = false;
      });
    }
  }

  Future<void> _approveVerification(
    String verificationId,
    bool approved,
  ) async {
    try {
      await ApiService.instance.processAlumniVerification(
        verificationId,
        approved,
      );
      context.read<ToastProvider>().showToast(
        approved
            ? 'Alumni verification approved'
            : 'Alumni verification rejected',
        ToastType.success,
      );
      _loadVerificationData();
    } catch (e) {
      context.read<ToastProvider>().showToast(
        'Failed to process verification: ${e.toString()}',
        ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    if (_loading) {
      return const Center(child: LoadingWidget());
    }

    if (user?.role == 'MANAGEMENT') {
      return _buildManagementView();
    } else if (user?.role == 'ALUMNI') {
      return _buildAlumniView();
    }

    return const CustomCard(
      child: Center(
        child: Text('Alumni verification not available for this role'),
      ),
    );
  }

  Widget _buildManagementView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alumni Verification Requests',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        if (_pendingVerifications.isEmpty) ...[
          const CustomCard(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.verified_user, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No pending verification requests',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pendingVerifications.length,
            itemBuilder: (context, index) {
              final verification = _pendingVerifications[index];
              return _buildVerificationRequestCard(verification);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAlumniView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alumni Verification',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        if (_userVerificationStatus == null ||
            _userVerificationStatus!['status'] == 'NOT_SUBMITTED') ...[
          _buildVerificationForm(),
        ] else ...[
          _buildVerificationStatus(),
        ],
      ],
    );
  }

  Widget _buildVerificationRequestCard(Map<String, dynamic> verification) {
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
                  (verification['name'] ?? 'Alumni')[0].toUpperCase(),
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
                      verification['name'] ?? 'Unknown Alumni',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      verification['email'] ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  verification['status'] ?? 'Pending',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alumni Details
          if (verification['graduation_year'] != null) ...[
            _buildDetailRow(
              'Graduation Year',
              verification['graduation_year'].toString(),
            ),
          ],
          if (verification['department'] != null) ...[
            _buildDetailRow('Department', verification['department']),
          ],
          if (verification['student_id'] != null) ...[
            _buildDetailRow('Student ID', verification['student_id']),
          ],
          if (verification['current_position'] != null) ...[
            _buildDetailRow(
              'Current Position',
              verification['current_position'],
            ),
          ],
          if (verification['company'] != null) ...[
            _buildDetailRow('Company', verification['company']),
          ],

          // Documents
          if (verification['documents'] != null &&
              verification['documents'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Submitted Documents:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (verification['documents'] as List)
                  .map(
                    (doc) => Chip(
                      label: Text(doc['name'] ?? 'Document'),
                      avatar: const Icon(Icons.description, size: 18),
                      onDeleted: () => _viewDocument(doc),
                      deleteIcon: const Icon(Icons.visibility, size: 18),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _approveVerification(verification['id'], false),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _approveVerification(verification['id'], true),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationForm() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit Verification Request',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Text(
            'To verify your alumni status, please provide the required information and documents. This helps us maintain the integrity of our alumni network.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          CustomButton(
            onPressed: _submittingVerification
                ? null
                : () => _showVerificationDialog(),
            text: _submittingVerification
                ? 'Submitting...'
                : 'Start Verification Process',
            icon: _submittingVerification ? null : Icons.verified_user,
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus() {
    final status = _userVerificationStatus!;
    Color statusColor;
    IconData statusIcon;

    switch (status['status']) {
      case 'PENDING':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'APPROVED':
        statusColor = Colors.green;
        statusIcon = Icons.verified;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        status['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (status['submitted_at'] != null) ...[
            _buildDetailRow('Submitted', _formatDate(status['submitted_at'])),
          ],
          if (status['processed_at'] != null) ...[
            _buildDetailRow('Processed', _formatDate(status['processed_at'])),
          ],
          if (status['notes'] != null) ...[
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
                    'Admin Notes',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(status['notes']),
                ],
              ),
            ),
          ],

          if (status['status'] == 'REJECTED') ...[
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () => _showVerificationDialog(),
              text: 'Resubmit Verification',
              icon: Icons.refresh,
            ),
          ],
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
            width: 120,
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  void _viewDocument(Map<String, dynamic> document) {
    // Implement document viewing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document['name'] ?? 'Document'),
        content: const Text(
          'Document viewing functionality would be implemented here',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog() {
    // Show verification form dialog
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Verification Form'),
        content: Text(
          'Detailed verification form would be implemented here with fields for graduation year, student ID, documents upload, etc.',
        ),
      ),
    );
  }
}
