enum UserRole { student, employer, university }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
  });
}

class StudentProfile {
  final String userId;
  final String name;
  final String email;
  final String? university;
  final String? degree;
  final String? major;
  final double? gpa;
  final List<String> skills;
  final List<String> certifications;
  final String? about;
  final String? photoUrl;
  final List<Education> education;
  final List<Experience> experience;
  
  StudentProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.university,
    this.degree,
    this.major,
    this.gpa,
    this.skills = const [],
    this.certifications = const [],
    this.about,
    this.photoUrl,
    this.education = const [],
    this.experience = const [],
  });

  // Calculate profile completion percentage
  double get completionPercentage {
    int totalFields = 8; // Base fields excluding lists
    int completedFields = 0;
    
    if (university != null && university!.isNotEmpty) completedFields++;
    if (degree != null && degree!.isNotEmpty) completedFields++;
    if (major != null && major!.isNotEmpty) completedFields++;
    if (gpa != null) completedFields++;
    if (skills.isNotEmpty) completedFields++;
    if (certifications.isNotEmpty) completedFields++;
    if (about != null && about!.isNotEmpty) completedFields++;
    if (photoUrl != null && photoUrl!.isNotEmpty) completedFields++;
    
    return (completedFields / totalFields) * 100;
  }
}

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.gpa,
  });
}

class Experience {
  final String company;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  Experience({
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate,
    required this.description,
  });
}

class EmployerProfile {
  final String userId;
  final String name;
  final String email;
  final String company;
  final String industry;
  final String? about;
  final String? logoUrl;
  final String? website;
  final String? location;

  EmployerProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.company,
    required this.industry,
    this.about,
    this.logoUrl,
    this.website,
    this.location,
  });
}

class UniversityProfile {
  final String userId;
  final String name;
  final String email;
  final String university;
  final String? about;
  final String? logoUrl;
  final String? website;
  final String? location;
  final List<String> departments;

  UniversityProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.university,
    this.about,
    this.logoUrl,
    this.website,
    this.location,
    this.departments = const [],
  });
}
