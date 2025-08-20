
import 'user.dart';

enum ResumeTemplate { modern, classic, minimalist, creative }

class Resume {
  final String id;
  final String studentId;
  final String title;
  final ResumeTemplate template;
  final String objective;
  final List<Education> education;
  final List<Experience> experience;
  final List<String> skills;
  final List<String> certifications;
  final List<String> projects;
  final Map<String, String> contactInfo;

  Resume({
    required this.id,
    required this.studentId,
    required this.title,
    required this.template,
    required this.objective,
    required this.education,
    required this.experience,
    required this.skills,
    required this.certifications,
    required this.projects,
    required this.contactInfo,
  });

  // Get AI suggestions for improvement
  List<String> getAISuggestions() {
    List<String> suggestions = [];

    // Hardcoded AI suggestions
    if (objective.split(' ').length < 15) {
      suggestions.add(
          "Consider expanding your career objective to be more specific about your goals and skills.");
    }

    if (skills.length < 5) {
      suggestions.add(
          "Add more relevant skills to improve matching with job requirements.");
    }

    if (experience.length < 2) {
      suggestions.add(
          "Include more work experiences, even if they're internships or volunteer positions.");
    }

    if (certifications.isEmpty) {
      suggestions.add(
          "Adding relevant certifications can make your resume stand out to employers.");
    }

    if (projects.isEmpty) {
      suggestions.add(
          "Consider adding projects that demonstrate your skills and problem-solving abilities.");
    }

    return suggestions;
  }
}
