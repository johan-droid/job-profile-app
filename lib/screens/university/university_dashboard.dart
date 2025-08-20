import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../responsive_layout.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/chart_widgets.dart';
import '../settings/settings_page.dart';

class UniversityDashboard extends StatefulWidget {
  const UniversityDashboard({Key? key}) : super(key: key);

  @override
  State<UniversityDashboard> createState() => _UniversityDashboardState();
}

class _UniversityDashboardState extends State<UniversityDashboard> {
  int _selectedIndex = 0;
  final _universityProfile = DummyData.universityProfiles[0];

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
        return const PlacementAnalytics();
      case 1:
        return const SkillGapAnalysis();
      case 2:
        return const ProgramRecommendations();
      case 3:
        return const SettingsPage();
      default:
        return const PlacementAnalytics();
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
      selectedItemColor: AppTheme.neutralColor.withBlue(100),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.insights),
          label: 'Placements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Skill Gaps',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb),
          label: 'Programs',
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
            color: AppTheme.neutralColor.withBlue(100),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      _universityProfile.university[0],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor.withBlue(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _universityProfile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _universityProfile.university,
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
                _buildNavItem('Placement Analytics', Icons.insights, 0),
                _buildNavItem('Skill Gap Analysis', Icons.assessment, 1),
                _buildNavItem('Program Recommendations', Icons.lightbulb, 2),
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
    final primaryColor = AppTheme.neutralColor.withBlue(100);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? primaryColor.withOpacity(0.1) : null,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

class PlacementAnalytics extends StatelessWidget {
  const PlacementAnalytics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placementTrend = AnalyticsHelper.getPlacementTrend();
    final departmentPerformance = AnalyticsHelper.getDepartmentPerformance();
    final salaryTrend = AnalyticsHelper.getSalaryTrend();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement Analytics'),
        backgroundColor: AppTheme.neutralColor.withBlue(100),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            ResponsiveLayout(
              mobile: Column(
                children: [
                  _buildStatCard('Overall Placement Rate', '${placementTrend.last['rate']}%', Icons.group),
                  const SizedBox(height: 16),
                  _buildStatCard('Total Placements', '410', Icons.business_center),
                  const SizedBox(height: 16),
                  _buildStatCard('Average Salary', '₹${salaryTrend.last / 1000}k', Icons.payments),
                ],
              ),
              tablet: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Overall Placement Rate', '${placementTrend.last['rate']}%', Icons.group),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Total Placements', '410', Icons.business_center),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Average Salary', '₹${salaryTrend.last / 1000}k', Icons.payments),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Placement Trend Chart
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Placement Rate Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: LineChartWidget(
                        data: placementTrend.map((data) => data['rate'] as double).toList(),
                        labels: placementTrend.map((data) => data['year'] as String).toList(),
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Department Performance Chart
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Placements by Department',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: BarChartWidget(
                        data: departmentPerformance.entries.map((e) => e.value.last).toList(),
                        labels: departmentPerformance.keys.toList(),
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Company Breakdown Chart
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Recruiting Companies',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: PieChartWidget(
                        data: [45, 38, 50, 42, 235],
                        labels: ['Tech Corporation', 'Innovate Solutions', 'Global Systems', 'Data Insights', 'Others'],
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                          Colors.orange,
                          Colors.green,
                          Colors.grey,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Salary Trend Chart
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Average Salary Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: LineChartWidget(
                        data: salaryTrend.map((salary) => salary / 100000).toList(), // Convert to lakhs
                        labels: placementTrend.map((data) => data['year'] as String).toList(),
                        color: Colors.green,
                        isCurrency: true,
                      ),
                    ),
                  ],
                ),
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
                  color: AppTheme.neutralColor.withBlue(100),
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
}

class SkillGapAnalysis extends StatelessWidget {
  const SkillGapAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skillGaps = AnalyticsHelper.getTopSkillGaps();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Gap Analysis'),
        backgroundColor: AppTheme.neutralColor.withBlue(100),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Skill Gaps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Based on industry demand vs. student skills',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: BarChartWidget(
                        data: skillGaps.map((gap) => gap.gapPercentage).toList(),
                        labels: skillGaps.map((gap) => gap.skill).toList(),
                        color: AppTheme.primaryColor,
                        isPercentage: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Detailed Skill Gap Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skillGaps.length,
              itemBuilder: (context, index) {
                final gap = skillGaps[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gap.skill,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Industry Demand',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${gap.demandCount} jobs',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Student Supply',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${gap.supplyCount} students',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gap Percentage',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: gap.gapPercentage / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(_getColorForGap(gap.gapPercentage)),
                                    minHeight: 10,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${gap.gapPercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: _getColorForGap(gap.gapPercentage),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            // Open detailed view or action
                          },
                          child: const Text('View Action Plan'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForGap(double percentage) {
    if (percentage > 70) {
      return Colors.red;
    } else if (percentage > 40) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

class ProgramRecommendations extends StatelessWidget {
  const ProgramRecommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programs = DummyData.programRecommendations;
    final impactScores = AnalyticsHelper.getProgramImpactScores();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Recommendations'),
        backgroundColor: AppTheme.neutralColor.withBlue(100),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Program Impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Projected improvement in placement rates',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: BarChartWidget(
                        data: impactScores.map((program) => program['impact'] as double).toList(),
                        labels: impactScores.map((program) => program['name'] as String).toList(),
                        color: AppTheme.neutralColor.withBlue(100),
                        isPercentage: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Recommended Programs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                program.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.neutralColor.withBlue(100).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.neutralColor.withBlue(100)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${program.estimatedImpact.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          program.description,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Duration: ${program.duration}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Target Skills:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: program.targetSkills.map((skill) => Chip(
                            label: Text(
                              skill,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppTheme.neutralColor,
                          )).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                // View details
                              },
                              child: const Text('View Details'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Implement program
                                _showImplementDialog(context, program);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.neutralColor.withBlue(100),
                              ),
                              child: const Text('Implement'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add custom program
        },
        backgroundColor: AppTheme.neutralColor.withBlue(100),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showImplementDialog(BuildContext context, dynamic program) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Implement Program'),
          content: Text('Are you sure you want to implement "${program.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${program.name} has been implemented'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neutralColor.withBlue(100),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
