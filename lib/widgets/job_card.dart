import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/job.dart';
import '../models/user.dart';

class JobCard extends StatelessWidget {
  final JobListing job;
  final StudentProfile studentProfile;
  final VoidCallback onApplyTap;

  const JobCard({
    Key? key,
    required this.job,
    required this.studentProfile,
    required this.onApplyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchPercentage = job.calculateSkillMatch(studentProfile.skills);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMatchColor(matchPercentage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${matchPercentage.toInt()}% Match',
                    style: TextStyle(
                      color: _getMatchColor(matchPercentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job.company,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  job.location,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.work, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  job.employmentType,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (job.salaryMin != null && job.salaryMax != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '₹${job.salaryMin! / 1000}k - ₹${job.salaryMax! / 1000}k per year',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'Required Skills:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.skills.map((skill) {
                final isMatch = studentProfile.skills.any(
                  (s) => s.toLowerCase() == skill.toLowerCase(),
                );

                return Chip(
                  label: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      color: isMatch ? Colors.white : Colors.black87,
                    ),
                  ),
                  backgroundColor:
                      isMatch ? AppTheme.primaryColor : AppTheme.neutralColor,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posted: ${_getTimeAgo(job.postedDate)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Deadline: ${_formatDate(job.applicationDeadline)}',
                      style: TextStyle(
                        color: _isDeadlineSoon(job.applicationDeadline)
                            ? Colors.red
                            : Colors.grey,
                        fontSize: 12,
                        fontWeight: _isDeadlineSoon(job.applicationDeadline)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onApplyTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('Apply Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(double matchPercentage) {
    if (matchPercentage >= 80) {
      return Colors.green;
    } else if (matchPercentage >= 50) {
      return AppTheme.primaryColor;
    } else {
      return Colors.orange;
    }
  }

  String _getTimeAgo(DateTime postedDate) {
    final now = DateTime.now();
    final difference = now.difference(postedDate);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isDeadlineSoon(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    return difference <= 3;
  }
}
