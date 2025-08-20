import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../responsive_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final studentProfile = DummyData.studentProfiles[0];
  
  // Form controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _universityController;
  late final TextEditingController _degreeController;
  late final TextEditingController _majorController;
  late final TextEditingController _gpaController;
  late final TextEditingController _aboutController;
  
  List<String> _skills = [];
  List<String> _certifications = [];
  final TextEditingController _newSkillController = TextEditingController();
  final TextEditingController _newCertController = TextEditingController();
  
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with dummy data
    _nameController = TextEditingController(text: studentProfile.name);
    _emailController = TextEditingController(text: studentProfile.email);
    _universityController = TextEditingController(text: studentProfile.university);
    _degreeController = TextEditingController(text: studentProfile.degree);
    _majorController = TextEditingController(text: studentProfile.major);
    _gpaController = TextEditingController(text: studentProfile.gpa?.toString());
    _aboutController = TextEditingController(text: studentProfile.about);
    
    _skills = List.from(studentProfile.skills);
    _certifications = List.from(studentProfile.certifications);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    _degreeController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    _aboutController.dispose();
    _newSkillController.dispose();
    _newCertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                // Save profile logic would go here
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                }
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileProfile(),
        tablet: _buildTabletProfile(),
      ),
    );
  }

  Widget _buildMobileProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildPersonalInfoSection(),
            const SizedBox(height: 20),
            _buildEducationSection(),
            const SizedBox(height: 20),
            _buildSkillsSection(),
            const SizedBox(height: 20),
            _buildCertificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildPersonalInfoSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildEducationSection(),
                  const SizedBox(height: 20),
                  _buildSkillsSection(),
                  const SizedBox(height: 20),
                  _buildCertificationsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    studentProfile.photoUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                ),
                if (_isEditing)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              studentProfile.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${studentProfile.degree} Student',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: studentProfile.completionPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Profile Completion: ${studentProfile.completionPercentage.toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              label: 'Full Name',
              controller: _nameController,
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              label: 'About Me',
              controller: _aboutController,
              enabled: _isEditing,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Education',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              label: 'University',
              controller: _universityController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              label: 'Degree',
              controller: _degreeController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              label: 'Major',
              controller: _majorController,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            
            _buildTextField(
              label: 'GPA',
              controller: _gpaController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final gpa = double.tryParse(value);
                  if (gpa == null || gpa < 0 || gpa > 4.0) {
                    return 'Please enter a valid GPA between 0 and 4.0';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) => Chip(
                label: Text(skill),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                deleteIconColor: _isEditing ? Colors.red : Colors.transparent,
                onDeleted: _isEditing ? () {
                  setState(() {
                    _skills.remove(skill);
                  });
                } : null,
              )).toList(),
            ),
            
            if (_isEditing) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newSkillController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new skill',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_newSkillController.text.isNotEmpty) {
                        setState(() {
                          _skills.add(_newSkillController.text);
                          _newSkillController.clear();
                        });
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Certifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _certifications.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_certifications[index]),
                    trailing: _isEditing ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _certifications.removeAt(index);
                        });
                      },
                    ) : null,
                  ),
                );
              },
            ),
            
            if (_isEditing) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newCertController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new certification',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_newCertController.text.isNotEmpty) {
                        setState(() {
                          _certifications.add(_newCertController.text);
                          _newCertController.clear();
                        });
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[200],
      ),
    );
  }
}
