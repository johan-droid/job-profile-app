import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../responsive_layout.dart';
import 'job_creation.dart';
import 'applications_review.dart';
import '../settings/settings_page.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({Key? key}) : super(key: key);

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  int _selectedIndex = 0;
  final _employerProfile = DummyData.employerProfiles[0]; // Using dummy data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(child: _getSelectedScreen()),
        _buildBottomNavBar(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        _buildSideNavBar(),
        Expanded(child: _getSelectedScreen()),
      ],
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const EmployerHomePage();
      case 1:
        return const JobCreation();
      case 2:
        return const ApplicationsReview();
      case 3:
        return const SettingsPage();
      default:
        return const EmployerHomePage();
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.secondaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Create Job',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Applications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildSideNavBar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: AppTheme.secondaryColor,
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      _employerProfile.name[0],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _employerProfile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _employerProfile.company,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem('Dashboard', Icons.dashboard, 0),
                _buildNavItem('Create Job', Icons.work, 1),
                _buildNavItem('Applications', Icons.people, 2),
                _buildNavItem('Settings', Icons.settings, 3),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.secondaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.secondaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? AppTheme.secondaryColor.withOpacity(0.1) : null,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

class EmployerHomePage extends StatelessWidget {
  const EmployerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employerProfile = DummyData.employerProfiles[0];
    final employerJobs = DummyData.jobListings
        .where((job) => job.employerId == employerProfile.userId)
        .toList();
    final applications =
        DummyData.getEmployerApplications(employerProfile.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Dashboard'),
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(employerProfile),
            const SizedBox(height: 20),

            // Statistics cards
            ResponsiveLayout(
              mobile: Column(
                children: [
                  _buildStatCard('Active Jobs', employerJobs.length.toString(),
                      Icons.work),
                  const SizedBox(height: 16),
                  _buildStatCard('Total Applications',
                      applications.length.toString(), Icons.people),
                  const SizedBox(height: 16),
                  _buildStatCard(
                      'Interviews Scheduled', '3', Icons.calendar_today),
                ],
              ),
              tablet: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Active Jobs',
                        employerJobs.length.toString(), Icons.work),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Total Applications',
                        applications.length.toString(), Icons.people),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                        'Interviews Scheduled', '3', Icons.calendar_today),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Recent Applications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Recent applications list
            applications.isEmpty
                ? _buildEmptyState('No applications yet', Icons.people)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        applications.length > 3 ? 3 : applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index];
                      return _buildApplicationCard(application);
                    },
                  ),

            const SizedBox(height: 20),
            const Text(
              'Your Job Listings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Job listings
            employerJobs.isEmpty
                ? _buildEmptyState('No jobs posted yet', Icons.work_off)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: employerJobs.length,
                    itemBuilder: (context, index) {
                      final job = employerJobs[index];
                      final applicationCount = applications
                          .where((app) => app['job'].id == job.id)
                          .length;
                      return _buildJobListingCard(job, applicationCount);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JobCreation()),
          );
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWelcomeCard(EmployerProfile profile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.secondaryColor,
              child: Text(
                profile.name[0],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${profile.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.company,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> application) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
          child: Text(
            application['student'].name[0],
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(application['student'].name),
        subtitle: Text(
          'Applied for ${application['job'].title} on ${_formatDate(application['application'].applicationDate)}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to application details
        },
      ),
    );
  }

  Widget _buildJobListingCard(JobListing job, int applicationCount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.location,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted: ${_formatDate(job.postedDate)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  'Applications: $applicationCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deadline: ${_formatDate(job.applicationDeadline)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Edit job
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondaryColor,
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
