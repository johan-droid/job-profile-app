class JobListing {
  final String id;
  final String employerId;
  final String title;
  final String company;
  final String description;
  final List<String> skills;
  final List<String> requirements;
  final String location;
  final String employmentType; // Full-time, Part-time, Contract, etc.
  final double? salaryMin;
  final double? salaryMax;
  final DateTime postedDate;
  final DateTime applicationDeadline;

  JobListing({
    required this.id,
    required this.employerId,
    required this.title,
    required this.company,
    required this.description,
    required this.skills,
    required this.requirements,
    required this.location,
    required this.employmentType,
    this.salaryMin,
    this.salaryMax,
    required this.postedDate,
    required this.applicationDeadline,
  });

  // Calculate skill match percentage with student
  double calculateSkillMatch(List<String> studentSkills) {
    if (skills.isEmpty || studentSkills.isEmpty) return 0.0;
    
    int matchCount = 0;
    for (String skill in studentSkills) {
      if (skills.any((s) => s.toLowerCase() == skill.toLowerCase())) {
        matchCount++;
      }
    }
    
    return (matchCount / skills.length) * 100;
  }
}
