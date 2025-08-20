enum ApplicationStatus {
  applied,
  reviewed,
  shortlisted,
  interviewed,
  accepted,
  rejected
}

class JobApplication {
  final String id;
  final String jobId;
  final String studentId;
  final DateTime applicationDate;
  final ApplicationStatus status;
  final String? resumeUrl;
  final String? coverLetter;
  final List<String>? answers; // Answers to any application questions

  JobApplication({
    required this.id,
    required this.jobId,
    required this.studentId,
    required this.applicationDate,
    required this.status,
    this.resumeUrl,
    this.coverLetter,
    this.answers,
  });
}
