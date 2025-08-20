import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../responsive_layout.dart';

class JobCreation extends StatefulWidget {
  const JobCreation({Key? key}) : super(key: key);

  @override
  State<JobCreation> createState() => _JobCreationState();
}

class _JobCreationState extends State<JobCreation> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  DateTime _applicationDeadline = DateTime.now().add(const Duration(days: 30));
  String _employmentType = 'Full-time';

  final List<String> _employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
  ];

  List<String> _skills = [];
  List<String> _requirements = [];
  final TextEditingController _newSkillController = TextEditingController();
  final TextEditingController _newRequirementController =
      TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _newSkillController.dispose();
    _newRequirementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job Listing'),
        backgroundColor: AppTheme.secondaryColor,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobDetailsSection(),
            const SizedBox(height: 20),
            _buildJobDescriptionSection(),
            const SizedBox(height: 20),
            _buildSkillsSection(),
            const SizedBox(height: 20),
            _buildRequirementsSection(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildJobDetailsSection(),
                  const SizedBox(height: 20),
                  _buildJobDescriptionSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildSkillsSection(),
                  const SizedBox(height: 20),
                  _buildRequirementsSection(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetailsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Employment Type',
                border: OutlineInputBorder(),
              ),
              value: _employmentType,
              items: _employmentTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _employmentType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _salaryMinController,
                    decoration: const InputDecoration(
                      labelText: 'Min Salary (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _salaryMaxController,
                    decoration: const InputDecoration(
                      labelText: 'Max Salary (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Application Deadline',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_applicationDeadline.day}/${_applicationDeadline.month}/${_applicationDeadline.year}',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDescriptionSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText:
                    'Describe the job role, responsibilities, and expectations...',
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job description';
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
              'Required Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .map((skill) => Chip(
                        label: Text(skill),
                        backgroundColor:
                            AppTheme.secondaryColor.withOpacity(0.1),
                        deleteIconColor: Colors.red,
                        onDeleted: () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSkillController,
                    decoration: const InputDecoration(
                      hintText: 'Add a required skill',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _requirements.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_requirements[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _requirements.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newRequirementController,
                    decoration: const InputDecoration(
                      hintText: 'Add a requirement',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_newRequirementController.text.isNotEmpty) {
                      setState(() {
                        _requirements.add(_newRequirementController.text);
                        _newRequirementController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Post Job',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _applicationDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _applicationDeadline) {
      setState(() {
        _applicationDeadline = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_skills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one required skill'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // In a real app, this would save the job to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job posted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _salaryMinController.clear();
      _salaryMaxController.clear();
      setState(() {
        _skills = [];
        _requirements = [];
      });
    }
  }
}
