import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/resume.dart';
import '../models/user.dart';

class ResumeTemplatePreview extends StatelessWidget {
  final Resume resume;
  final StudentProfile profile;
  final ResumeTemplate template;

  const ResumeTemplatePreview({
    Key? key,
    required this.resume,
    required this.profile,
    required this.template,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (template) {
      case ResumeTemplate.modern:
        return ModernResumeTemplate(resume: resume, profile: profile);
      case ResumeTemplate.classic:
        return ClassicResumeTemplate(resume: resume, profile: profile);
      case ResumeTemplate.creative:
        return CreativeResumeTemplate(resume: resume, profile: profile);
      case ResumeTemplate.minimalist:
        return MinimalistResumeTemplate(resume: resume, profile: profile);
    }
  }
}

class ModernResumeTemplate extends StatelessWidget {
  final Resume resume;
  final StudentProfile profile;

  const ModernResumeTemplate({
    Key? key,
    required this.resume,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    if (profile.photoUrl != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profile.photoUrl!),
                      ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${profile.degree} in ${profile.major}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  resume.objective,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      resume.contactInfo['email'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      resume.contactInfo['phone'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Education'),
                  const SizedBox(height: 10),
                  ...resume.education.map((edu) => _buildEducationItem(edu)),
                  
                  const SizedBox(height: 20),
                  _buildSectionTitle('Experience'),
                  const SizedBox(height: 10),
                  ...resume.experience.map((exp) => _buildExperienceItem(exp)),
                  
                  const SizedBox(height: 20),
                  _buildSectionTitle('Skills'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: resume.skills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                  
                  if (resume.projects.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle('Projects'),
                    const SizedBox(height: 10),
                    ...resume.projects.map((project) => _buildProjectItem(project)),
                  ],
                  
                  if (resume.certifications.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle('Certifications'),
                    const SizedBox(height: 10),
                    ...resume.certifications.map((cert) => _buildCertificationItem(cert)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const Divider(color: AppTheme.primaryColor),
      ],
    );
  }
  
  Widget _buildEducationItem(Education education) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.institution,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${education.degree} in ${education.fieldOfStudy}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '${education.startDate.year} - ${education.endDate?.year ?? 'Present'}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          if (education.gpa != null)
            Text(
              'GPA: ${education.gpa}',
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
  
  Widget _buildExperienceItem(Experience experience) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.company,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            experience.role,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            experience.description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProjectItem(String project) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(project, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCertificationItem(String certification) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(certification, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class ClassicResumeTemplate extends StatelessWidget {
  final Resume resume;
  final StudentProfile profile;

  const ClassicResumeTemplate({
    Key? key,
    required this.resume,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(resume.contactInfo['email'] ?? ''),
              const SizedBox(width: 10),
              const Text('|'),
              const SizedBox(width: 10),
              Text(resume.contactInfo['phone'] ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 10),
          
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'OBJECTIVE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            resume.objective,
            style: const TextStyle(fontSize: 14),
          ),
          
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'EDUCATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...resume.education.map((edu) => _buildClassicEducationItem(edu)),
                  
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'EXPERIENCE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const Divider(),
                  ...resume.experience.map((exp) => _buildClassicExperienceItem(exp)),
                  
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SKILLS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      resume.skills.join(', '),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  
                  if (resume.certifications.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CERTIFICATIONS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const Divider(),
                    ...resume.certifications.map(
                      (cert) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '• $cert',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                  
                  if (resume.projects.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PROJECTS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const Divider(),
                    ...resume.projects.map(
                      (project) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '• $project',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildClassicEducationItem(Education education) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education.institution,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${education.degree} in ${education.fieldOfStudy}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${education.startDate.year} - ${education.endDate?.year ?? 'Present'}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                if (education.gpa != null)
                  Text(
                    'GPA: ${education.gpa}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildClassicExperienceItem(Experience experience) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.company,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  experience.role,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  experience.description,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class CreativeResumeTemplate extends StatelessWidget {
  final Resume resume;
  final StudentProfile profile;

  const CreativeResumeTemplate({
    Key? key,
    required this.resume,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 150,
            color: AppTheme.secondaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (profile.photoUrl != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.photoUrl!),
                  ),
                const SizedBox(height: 20),
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Divider(color: Colors.white),
                const SizedBox(height: 20),
                
                const Text(
                  'CONTACT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  resume.contactInfo['email'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  resume.contactInfo['phone'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text(
                  'SKILLS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...resume.skills.map((skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OBJECTIVE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          resume.objective,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const Text(
                    'EDUCATION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...resume.education.map((edu) => _buildCreativeEducationItem(edu)),
                  
                  const SizedBox(height: 20),
                  const Text(
                    'EXPERIENCE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...resume.experience.map((exp) => _buildCreativeExperienceItem(exp)),
                  
                  if (resume.projects.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'PROJECTS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...resume.projects.map((project) => _buildCreativeProjectItem(project)),
                  ],
                  
                  if (resume.certifications.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'CERTIFICATIONS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...resume.certifications.map((cert) => _buildCreativeCertificationItem(cert)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreativeEducationItem(Education education) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                education.institution,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${education.startDate.year} - ${education.endDate?.year ?? 'Present'}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            '${education.degree} in ${education.fieldOfStudy}',
            style: const TextStyle(fontSize: 14),
          ),
          if (education.gpa != null)
            Text(
              'GPA: ${education.gpa}',
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
  
  Widget _buildCreativeExperienceItem(Experience experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                experience.company,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            experience.role,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            experience.description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreativeProjectItem(String project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        project,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
  
  Widget _buildCreativeCertificationItem(String certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        certification,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class MinimalistResumeTemplate extends StatelessWidget {
  final Resume resume;
  final StudentProfile profile;

  const MinimalistResumeTemplate({
    Key? key,
    required this.resume,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(resume.contactInfo['email'] ?? ''),
              const SizedBox(width: 15),
              Text(resume.contactInfo['phone'] ?? ''),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 20),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.objective,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  _buildMinimalistSectionTitle('Education'),
                  ...resume.education.map((edu) => _buildMinimalistEducationItem(edu)),
                  
                  const SizedBox(height: 30),
                  _buildMinimalistSectionTitle('Experience'),
                  ...resume.experience.map((exp) => _buildMinimalistExperienceItem(exp)),
                  
                  const SizedBox(height: 30),
                  _buildMinimalistSectionTitle('Skills'),
                  Text(
                    resume.skills.join(' • '),
                    style: const TextStyle(fontSize: 14),
                  ),
                  
                  if (resume.projects.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    _buildMinimalistSectionTitle('Projects'),
                    ...resume.projects.map((project) => _buildMinimalistItem(project)),
                  ],
                  
                  if (resume.certifications.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    _buildMinimalistSectionTitle('Certifications'),
                    ...resume.certifications.map((cert) => _buildMinimalistItem(cert)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMinimalistSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const Divider(thickness: 1),
        const SizedBox(height: 10),
      ],
    );
  }
  
  Widget _buildMinimalistEducationItem(Education education) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                education.institution,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${education.startDate.year} - ${education.endDate?.year ?? 'Present'}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            '${education.degree} in ${education.fieldOfStudy}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMinimalistExperienceItem(Experience experience) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                experience.company,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            experience.role,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            experience.description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMinimalistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '• $text',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
