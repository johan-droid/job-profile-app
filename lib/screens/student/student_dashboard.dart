import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../models/job.dart';
import '../../models/user.dart';
import '../../responsive_layout.dart';
import 'profile_page.dart';
import 'resume_builder.dart';
import 'job_search.dart';
import '../settings/settings_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  final _studentProfile = DummyData.studentProfiles[0]; // Using dummy data
  
  final List<Widget> _screens = [
    const StudentHomePage(),
    const ProfilePage(),
    const ResumeBuilder(),
    const JobSearch(),
    const SettingsPage(),
  ];

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
        Expanded(child: _screens[_selectedIndex]),
        _buildBottomNavBar(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        _buildSideNavBar(),
        Expanded(child: _screens[_selectedIndex]),
      ],
    );
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
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Resume',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Jobs',
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
            color: AppTheme.primaryColor,
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      _studentProfile.photoUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _studentProfile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _studentProfile.university ?? '',
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
                _buildNavItem('Profile', Icons.person, 1),
                _buildNavItem('Resume', Icons.description, 2),
                _buildNavItem('Jobs', Icons.work, 3),
                _buildNavItem('Settings', Icons.settings, 4),
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
        color: isSelected ? AppTheme.primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProfile = DummyData.studentProfiles[0];
    final recommendedJobs = DummyData.getRecommendedJobs(studentProfile.userId);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(studentProfile),
            const SizedBox(height: 20),
            
            // Profile Completion
            _buildCompletionCard(studentProfile),
            const SizedBox(height: 20),
            
            // AI Job Matches
            const Text(
              'AI Job Matches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...recommendedJobs.map((job) => _buildJobCard(job, studentProfile)),
            
            const SizedBox(height: 20),
            // Upcoming Deadlines
            const Text(
              'Upcoming Deadlines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildDeadlineCard('Resume Completion', 'Complete your resume to increase job matches', DateTime.now().add(const Duration(days: 3))),
            _buildDeadlineCard('Interview Preparation', 'Tech Corporation - Flutter Developer position', DateTime.now().add(const Duration(days: 7))),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(StudentProfile profile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                profile.photoUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${profile.name.split(' ')[0]}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${DummyData.jobListings.length} new job opportunities match your profile today',
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

  Widget _buildCompletionCard(StudentProfile profile) {
    final completionPercentage = profile.completionPercentage;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Completion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${completionPercentage.toInt()}% Complete',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Complete your profile →',
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
    );
  }

  Widget _buildJobCard(JobListing job, StudentProfile profile) {
    final matchPercentage = job.calculateSkillMatch(profile.skills);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${matchPercentage.toInt()}% Match',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job.company,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              job.location,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job.skills.take(3).map((skill) => Chip(
                label: Text(skill, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppTheme.neutralColor,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted: ${_formatDate(job.postedDate)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12),
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

  Widget _buildDeadlineCard(String title, String description, DateTime deadline) {
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: daysLeft < 3 ? Colors.red.withOpacity(0.1) : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '$daysLeft',
                  style: TextStyle(
                    color: daysLeft < 3 ? Colors.red : AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${_formatDate(deadline)}',
                    style: TextStyle(
                      color: daysLeft < 3 ? Colors.red : Colors.grey,
                      fontSize: 12,
                      fontWeight: daysLeft < 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1 && difference < 7) {
      return '$difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
