import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../models/application.dart';
import '../../responsive_layout.dart';

class ApplicationsReview extends StatefulWidget {
  const ApplicationsReview({Key? key}) : super(key: key);

  @override
  State<ApplicationsReview> createState() => _ApplicationsReviewState();
}

class _ApplicationsReviewState extends State<ApplicationsReview> {
  final _employerProfile = DummyData.employerProfiles[0];
  ApplicationStatus? _selectedStatus;
  String? _selectedJobId;

  List<Map<String, dynamic>> _applications = [];
  List<Map<String, dynamic>> _filteredApplications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    _applications = DummyData.getEmployerApplications(_employerProfile.userId);
    _filteredApplications = List.from(_applications);
  }

  void _applyFilters() {
    setState(() {
      _filteredApplications = _applications.where((app) {
        final statusMatch = _selectedStatus == null ||
            app['application'].status == _selectedStatus;
        final jobMatch =
            _selectedJobId == null || app['job'].id == _selectedJobId;
        return statusMatch && jobMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications Review'),
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(child: _buildApplicationsList()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _buildFilters(),
        ),
        Expanded(child: _buildApplicationsList()),
      ],
    );
  }

  Widget _buildFilters() {
    final employerJobs = DummyData.jobListings
        .where((job) => job.employerId == _employerProfile.userId)
        .toList();

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Applications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Job filter
            DropdownButtonFormField<String?>(
              decoration: const InputDecoration(
                labelText: 'Job Position',
                border: OutlineInputBorder(),
              ),
              value: _selectedJobId,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Jobs'),
                ),
                ...employerJobs.map((job) {
                  return DropdownMenuItem<String?>(
                    value: job.id,
                    child: Text(job.title),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedJobId = value;
                  _applyFilters();
                });
              },
            ),
            const SizedBox(height: 16),

            // Status filter
            DropdownButtonFormField<ApplicationStatus?>(
              decoration: const InputDecoration(
                labelText: 'Application Status',
                border: OutlineInputBorder(),
              ),
              value: _selectedStatus,
              items: [
                const DropdownMenuItem<ApplicationStatus?>(
                  value: null,
                  child: Text('All Statuses'),
                ),
                ...ApplicationStatus.values.map((status) {
                  return DropdownMenuItem<ApplicationStatus?>(
                    value: status,
                    child: Text(status.name.capitalize()),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                  _applyFilters();
                });
              },
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedJobId = null;
                      _selectedStatus = null;
                      _filteredApplications = List.from(_applications);
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList() {
    if (_filteredApplications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredApplications.length,
      itemBuilder: (context, index) {
        final applicationData = _filteredApplications[index];
        final application = applicationData['application'];
        final job = applicationData['job'];
        final student = applicationData['student'];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: () => _showApplicationDetails(applicationData),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          student.photoUrl ??
                              'https://randomuser.me/api/portraits/men/1.jpg',
                        ),
                        radius: 25,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              job.title,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(application.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Applied: ${_formatDate(application.applicationDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        'View Details',
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    Color badgeColor;
    switch (status) {
      case ApplicationStatus.applied:
        badgeColor = Colors.blue;
        break;
      case ApplicationStatus.reviewed:
        badgeColor = Colors.purple;
        break;
      case ApplicationStatus.shortlisted:
        badgeColor = Colors.orange;
        break;
      case ApplicationStatus.interviewed:
        badgeColor = Colors.teal;
        break;
      case ApplicationStatus.accepted:
        badgeColor = Colors.green;
        break;
      case ApplicationStatus.rejected:
        badgeColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        status.name.capitalize(),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showApplicationDetails(Map<String, dynamic> applicationData) {
    final application = applicationData['application'];
    final job = applicationData['job'];
    final student = applicationData['student'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        student.photoUrl ??
                            'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            student.email,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Application Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('Job Position', job.title),
                        _buildInfoRow('Application Date',
                            _formatDate(application.applicationDate)),
                        _buildInfoRow(
                            'Status', application.status.name.capitalize()),
                        const SizedBox(height: 10),
                        const Text(
                          'Cover Letter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(application.coverLetter ??
                            'No cover letter provided'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Candidate Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            'University', student.university ?? 'Not provided'),
                        _buildInfoRow(
                            'Degree', student.degree ?? 'Not provided'),
                        _buildInfoRow('Major', student.major ?? 'Not provided'),
                        if (student.gpa != null)
                          _buildInfoRow('GPA', student.gpa.toString()),
                        const SizedBox(height: 10),
                        const Text(
                          'Skills',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: student.skills.map((skill) {
                            final isRequired = job.skills.any(
                              (s) => s.toLowerCase() == skill.toLowerCase(),
                            );

                            return Chip(
                              label: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isRequired
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              backgroundColor: isRequired
                                  ? AppTheme.secondaryColor
                                  : AppTheme.neutralColor,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Application Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<ApplicationStatus>(
                          decoration: const InputDecoration(
                            labelText: 'Update Status',
                            border: OutlineInputBorder(),
                          ),
                          value: application.status,
                          items: ApplicationStatus.values.map((status) {
                            return DropdownMenuItem<ApplicationStatus>(
                              value: status,
                              child: Text(status.name.capitalize()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            // Update application status
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Application status updated to ${value!.name}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.email),
                        label: const Text('Contact'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.secondaryColor,
                          side:
                              const BorderSide(color: AppTheme.secondaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Schedule'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
