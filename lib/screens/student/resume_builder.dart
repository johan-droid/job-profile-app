import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import '../../app_theme.dart';
import '../../models/dummy_data.dart';
import '../../models/resume.dart';
import '../../models/user.dart';
import '../../responsive_layout.dart';
import '../../utils/pdf_export.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({Key? key}) : super(key: key);

  @override
  State<ResumeBuilder> createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  final _formKey = GlobalKey<FormState>();
  late Resume _resume;
  late StudentProfile _studentProfile;
  ResumeTemplate _selectedTemplate = ResumeTemplate.modern;
  bool _isGeneratingPdf = false;
  Uint8List? _pdfPreview;
  
  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _objectiveController;
  final TextEditingController _newProjectController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Load dummy data
    _studentProfile = DummyData.studentProfiles[0];
    _resume = DummyData.resumes.firstWhere(
      (r) => r.studentId == _studentProfile.userId,
      orElse: () => DummyData.resumes[0],
    );
    
    _titleController = TextEditingController(text: _resume.title);
    _objectiveController = TextEditingController(text: _resume.objective);
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _objectiveController.dispose();
    _newProjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Resume Builder'),
        actions: [
          TextButton.icon(
            onPressed: _isGeneratingPdf ? null : _generatePdfPreview,
            icon: Icon(
              Icons.picture_as_pdf,
              color: _isGeneratingPdf ? Colors.grey : Colors.white,
            ),
            label: Text(
              'Export PDF',
              style: TextStyle(
                color: _isGeneratingPdf ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ],
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
          _buildTemplateSelector(),
          const SizedBox(height: 20),
          _buildResumeForm(),
          const SizedBox(height: 20),
          _buildAiSuggestions(),
          if (_pdfPreview != null) ...[
            const SizedBox(height: 20),
            _buildPdfPreview(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTemplateSelector(),
                const SizedBox(height: 20),
                _buildResumeForm(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAiSuggestions(),
                if (_pdfPreview != null) ...[
                  const SizedBox(height: 20),
                  _buildPdfPreview(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTemplateSelector() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Resume Template',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ResumeTemplate.values.map((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTemplate = template;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 160,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedTemplate == template
                                    ? AppTheme.primaryColor
                                    : Colors.grey[300]!,
                                width: _selectedTemplate == template ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/${template.name}_template.png',
                                width: 100,
                                height: 140,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Text(
                                        template.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            template.name.capitalize(),
                            style: TextStyle(
                              fontWeight: _selectedTemplate == template
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedTemplate == template
                                  ? AppTheme.primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResumeForm() {
    return Form(
      key: _formKey,
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
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Resume Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title for your resume';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _objectiveController,
                    decoration: const InputDecoration(
                      labelText: 'Career Objective',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your career objective';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Education Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Education',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Show dialog to add education
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _studentProfile.education.length,
                    itemBuilder: (context, index) {
                      final education = _studentProfile.education[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(education.institution),
                          subtitle: Text(
                            '${education.degree} in ${education.fieldOfStudy}, ${education.startDate.year} - ${education.endDate?.year ?? 'Present'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: AppTheme.secondaryColor),
                            onPressed: () {
                              // Show dialog to edit education
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Experience Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Experience',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Show dialog to add experience
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _studentProfile.experience.length,
                    itemBuilder: (context, index) {
                      final experience = _studentProfile.experience[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(experience.company),
                          subtitle: Text(
                            '${experience.role}, ${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: AppTheme.secondaryColor),
                            onPressed: () {
                              // Show dialog to edit experience
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Skills Section
          Card(
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
                    children: _studentProfile.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        deleteIconColor: Colors.red,
                        onDeleted: () {
                          // Remove skill logic
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Projects Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                        onPressed: () {
                          _showAddProjectDialog();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _resume.projects.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(_resume.projects[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _resume.projects.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAiSuggestions() {
    final suggestions = _resume.getAISuggestions();
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppTheme.primaryColor.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'AI Suggestions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (suggestions.isEmpty)
              const Text(
                'Great job! Your resume looks perfect.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.tips_and_updates,
                        color: AppTheme.secondaryColor,
                      ),
                      title: Text(suggestions[index]),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPdfPreview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PDF Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.memory(_pdfPreview!),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _downloadPdf,
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Project'),
          content: TextField(
            controller: _newProjectController,
            decoration: const InputDecoration(
              labelText: 'Project Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
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
                if (_newProjectController.text.isNotEmpty) {
                  setState(() {
                    _resume.projects.add(_newProjectController.text);
                    _newProjectController.clear();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _generatePdfPreview() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isGeneratingPdf = true;
      });
      
      try {
        final pdfService = PdfExportService();
        // Update resume with form data
        final updatedResume = Resume(
          id: _resume.id,
          studentId: _resume.studentId,
          title: _titleController.text,
          template: _selectedTemplate,
          objective: _objectiveController.text,
          education: _studentProfile.education,
          experience: _studentProfile.experience,
          skills: _studentProfile.skills,
          certifications: _studentProfile.certifications,
          projects: _resume.projects,
          contactInfo: _resume.contactInfo,
        );
        
        final pdfBytes = await pdfService.generateResumePdf(updatedResume, _studentProfile);
        
        setState(() {
          _pdfPreview = pdfBytes;
          _isGeneratingPdf = false;
        });
      } catch (e) {
        setState(() {
          _isGeneratingPdf = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }
  
  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF downloaded successfully')),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
