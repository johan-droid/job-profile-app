import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../responsive_layout.dart';
import '../../utils/user_type.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // App settings
  bool _darkMode = false;
  bool _notifications = true;
  bool _emailNotifications = true;
  bool _showSkillSuggestions = true;
  String _language = 'English';
  final UserType _currentUserType = UserType.student; // This would normally be determined by the logged-in user

  // Available options
  final List<String> _languages = ['English', 'Hindi', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: _getThemeColor(),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppearanceSection(),
          const SizedBox(height: 20),
          _buildNotificationSection(),
          const SizedBox(height: 20),
          _buildPrivacySection(),
          const SizedBox(height: 20),
          _buildAccountSection(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildAppearanceSection(),
                const SizedBox(height: 20),
                _buildNotificationSection(),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _buildPrivacySection(),
                const SizedBox(height: 20),
                _buildAccountSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme throughout the app'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // In a real app, this would trigger a theme change
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            const Divider(),
            ListTile(
              title: const Text('Language'),
              subtitle: Text(_language),
              leading: const Icon(Icons.language),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguageSelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              secondary: const Icon(Icons.notifications),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive email updates'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
              secondary: const Icon(Icons.email),
            ),
            if (_currentUserType == UserType.student) ...[
              const Divider(),
              SwitchListTile(
                title: const Text('Skill Suggestions'),
                subtitle: const Text('Receive AI-based skill improvement suggestions'),
                value: _showSkillSuggestions,
                onChanged: (value) {
                  setState(() {
                    _showSkillSuggestions = value;
                  });
                },
                secondary: const Icon(Icons.lightbulb),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Privacy Policy'),
              leading: const Icon(Icons.privacy_tip),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to privacy policy
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Terms of Service'),
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to terms of service
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Data Management'),
              subtitle: const Text('Control how your data is used'),
              leading: const Icon(Icons.storage),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to data management
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to change password
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Update Profile'),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to profile update
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Delete Account'),
              textColor: Colors.red,
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(_languages[index]),
                  value: _languages[index],
                  groupValue: _language,
                  onChanged: (value) {
                    setState(() {
                      _language = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          ),
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
                // In a real app, delete account logic would go here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(context).pushReplacementNamed('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Color _getThemeColor() {
    switch (_currentUserType) {
      case UserType.student:
        return AppTheme.primaryColor;
      case UserType.employer:
        return AppTheme.secondaryColor;
      case UserType.university:
        return AppTheme.neutralColor.withBlue(100);
    }
  }
}
