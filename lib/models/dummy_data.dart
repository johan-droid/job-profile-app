import 'dart:math';
import 'user.dart';
import 'job.dart';
import 'application.dart';
import 'resume.dart';
import 'university_data.dart';

class DummyData {
  // Users
  static final List<User> users = [
    User(
      id: 's1',
      name: 'Alex Johnson',
      email: 'alex@student.edu',
      role: UserRole.student,
      photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    User(
      id: 's2',
      name: 'Sarah Williams',
      email: 'sarah@student.edu',
      role: UserRole.student,
      photoUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    ),
    User(
      id: 'e1',
      name: 'Michael Chen',
      email: 'michael@techcorp.com',
      role: UserRole.employer,
    ),
    User(
      id: 'e2',
      name: 'Jessica Miller',
      email: 'jessica@innovate.io',
      role: UserRole.employer,
    ),
    User(
      id: 'u1',
      name: 'Dr. Robert Johnson',
      email: 'robert@university.edu',
      role: UserRole.university,
    ),
  ];

  // Student Profiles
  static final List<StudentProfile> studentProfiles = [
    StudentProfile(
      userId: 's1',
      name: 'Alex Johnson',
      email: 'alex@student.edu',
      university: 'Tech University',
      degree: 'Bachelor of Science',
      major: 'Computer Science',
      gpa: 3.8,
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'UI/UX Design',
        'React',
        'JavaScript'
      ],
      certifications: ['Google Flutter Development', 'AWS Cloud Practitioner'],
      about:
          'Passionate app developer with experience in cross-platform solutions.',
      photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      education: [
        Education(
          institution: 'Tech University',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Computer Science',
          startDate: DateTime(2019, 9),
          endDate: DateTime(2023, 5),
          gpa: 3.8,
        ),
      ],
      experience: [
        Experience(
          company: 'Mobile Apps Inc',
          role: 'Flutter Developer Intern',
          startDate: DateTime(2022, 5),
          endDate: DateTime(2022, 8),
          description:
              'Developed and maintained mobile applications using Flutter and Firebase.',
        ),
      ],
    ),
    StudentProfile(
      userId: 's2',
      name: 'Sarah Williams',
      email: 'sarah@student.edu',
      university: 'Design Academy',
      degree: 'Bachelor of Arts',
      major: 'UI/UX Design',
      gpa: 3.9,
      skills: [
        'UI Design',
        'UX Research',
        'Figma',
        'Adobe XD',
        'Prototyping',
        'HTML/CSS'
      ],
      certifications: ['Google UX Design Professional Certificate'],
      about: 'Creative designer focusing on user-centered solutions.',
      photoUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      education: [
        Education(
          institution: 'Design Academy',
          degree: 'Bachelor of Arts',
          fieldOfStudy: 'UI/UX Design',
          startDate: DateTime(2020, 9),
          endDate: DateTime(2024, 5),
          gpa: 3.9,
        ),
      ],
      experience: [
        Experience(
          company: 'CreativeDesign Studio',
          role: 'UI Designer Intern',
          startDate: DateTime(2023, 1),
          endDate: DateTime(2023, 3),
          description:
              'Designed user interfaces for web and mobile applications.',
        ),
      ],
    ),
  ];

  // Employer Profiles
  static final List<EmployerProfile> employerProfiles = [
    EmployerProfile(
      userId: 'e1',
      name: 'Michael Chen',
      email: 'michael@techcorp.com',
      company: 'Tech Corporation',
      industry: 'Software Development',
      about:
          'Leading technology company specializing in enterprise software solutions.',
      logoUrl: 'https://via.placeholder.com/150',
      website: 'www.techcorp.com',
      location: 'Bangalore, India',
    ),
    EmployerProfile(
      userId: 'e2',
      name: 'Jessica Miller',
      email: 'jessica@innovate.io',
      company: 'Innovate Solutions',
      industry: 'Mobile Development',
      about:
          'Innovative mobile app development studio focused on cutting-edge technologies.',
      logoUrl: 'https://via.placeholder.com/150',
      website: 'www.innovate.io',
      location: 'Mumbai, India',
    ),
  ];

  // University Profiles
  static final List<UniversityProfile> universityProfiles = [
    UniversityProfile(
      userId: 'u1',
      name: 'Dr. Robert Johnson',
      email: 'robert@university.edu',
      university: 'Tech University',
      about: 'Premier institution for technology education in the region.',
      logoUrl: 'https://via.placeholder.com/150',
      website: 'www.techuniversity.edu',
      location: 'Delhi, India',
      departments: [
        'Computer Science',
        'Electrical Engineering',
        'Information Technology',
        'Mechanical Engineering'
      ],
    ),
  ];

  // Job Listings
  static final List<JobListing> jobListings = [
    JobListing(
      id: 'j1',
      employerId: 'e1',
      title: 'Flutter Developer',
      company: 'Tech Corporation',
      description:
          'We are looking for a skilled Flutter developer to join our mobile app development team. You will be responsible for building and maintaining high-quality cross-platform mobile applications.',
      skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
      requirements: [
        'Bachelor\'s degree in Computer Science or related field',
        'At least 1 year of experience with Flutter',
        'Strong understanding of mobile app architecture',
        'Experience with state management solutions in Flutter',
      ],
      location: 'Bangalore, India',
      employmentType: 'Full-time',
      salaryMin: 800000,
      salaryMax: 1200000,
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
      applicationDeadline: DateTime.now().add(const Duration(days: 25)),
    ),
    JobListing(
      id: 'j2',
      employerId: 'e2',
      title: 'UI/UX Designer',
      company: 'Innovate Solutions',
      description:
          'Seeking a creative UI/UX Designer to join our product team. You will be responsible for designing intuitive user interfaces and experiences for our mobile applications.',
      skills: ['UI Design', 'UX Research', 'Figma', 'Adobe XD', 'Prototyping'],
      requirements: [
        'Degree in Design, HCI, or related field',
        'Portfolio demonstrating UI/UX design skills',
        'Experience with design systems and component libraries',
        'Understanding of user-centered design principles',
      ],
      location: 'Mumbai, India (Remote Available)',
      employmentType: 'Full-time',
      salaryMin: 700000,
      salaryMax: 1000000,
      postedDate: DateTime.now().subtract(const Duration(days: 10)),
      applicationDeadline: DateTime.now().add(const Duration(days: 20)),
    ),
    JobListing(
      id: 'j3',
      employerId: 'e1',
      title: 'Software Engineer Intern',
      company: 'Tech Corporation',
      description:
          'We are offering an internship opportunity for students interested in software development. This is a great opportunity to gain hands-on experience and learn from experienced developers.',
      skills: ['Java', 'Python', 'Database', 'Software Development'],
      requirements: [
        'Currently pursuing a degree in Computer Science or related field',
        'Basic knowledge of programming languages',
        'Eagerness to learn and grow',
      ],
      location: 'Bangalore, India',
      employmentType: 'Internship',
      postedDate: DateTime.now().subtract(const Duration(days: 2)),
      applicationDeadline: DateTime.now().add(const Duration(days: 30)),
    ),
    JobListing(
      id: 'j4',
      employerId: 'e2',
      title: 'Mobile App Developer',
      company: 'Innovate Solutions',
      description:
          'Join our team to develop innovative mobile applications for Android and iOS platforms. We are looking for someone with strong programming skills and a passion for mobile development.',
      skills: ['Android', 'iOS', 'Swift', 'Kotlin', 'Mobile Development'],
      requirements: [
        'Bachelor\'s degree in Computer Science or related field',
        'Experience with mobile app development',
        'Knowledge of Android and iOS platforms',
        'Problem-solving skills and attention to detail',
      ],
      location: 'Mumbai, India',
      employmentType: 'Full-time',
      salaryMin: 750000,
      salaryMax: 1100000,
      postedDate: DateTime.now().subtract(const Duration(days: 7)),
      applicationDeadline: DateTime.now().add(const Duration(days: 23)),
    ),
  ];

  // Job Applications
  static final List<JobApplication> jobApplications = [
    JobApplication(
      id: 'a1',
      jobId: 'j1',
      studentId: 's1',
      applicationDate: DateTime.now().subtract(const Duration(days: 3)),
      status: ApplicationStatus.reviewed,
      resumeUrl: 'resume_alex_flutter.pdf',
      coverLetter:
          'I am very interested in this Flutter Developer position as it aligns well with my skills and career goals.',
    ),
    JobApplication(
      id: 'a2',
      jobId: 'j2',
      studentId: 's2',
      applicationDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ApplicationStatus.applied,
      resumeUrl: 'resume_sarah_uiux.pdf',
      coverLetter:
          'As a UI/UX design student, I am excited about the opportunity to work with your innovative company.',
    ),
  ];

  // Resumes
  static final List<Resume> resumes = [
    Resume(
      id: 'r1',
      studentId: 's1',
      title: 'Flutter Developer Resume',
      template: ResumeTemplate.modern,
      objective:
          'Seeking a Flutter Developer position where I can utilize my skills in mobile app development.',
      education: studentProfiles[0].education,
      experience: studentProfiles[0].experience,
      skills: studentProfiles[0].skills,
      certifications: studentProfiles[0].certifications,
      projects: [
        'Personal Finance App - A Flutter application for tracking expenses and budgeting.',
        'Weather App - Displays weather forecasts using a public API.',
      ],
      contactInfo: {
        'email': 'alex@student.edu',
        'phone': '+91 9876543210',
        'linkedIn': 'linkedin.com/in/alexjohnson',
        'github': 'github.com/alexj'
      },
    ),
    Resume(
      id: 'r2',
      studentId: 's2',
      title: 'UI/UX Designer Portfolio',
      template: ResumeTemplate.creative,
      objective:
          'Creative UI/UX designer looking to create intuitive and beautiful digital experiences.',
      education: studentProfiles[1].education,
      experience: studentProfiles[1].experience,
      skills: studentProfiles[1].skills,
      certifications: studentProfiles[1].certifications,
      projects: [
        'E-commerce App Redesign - Improved user flow and conversion rates.',
        'Healthcare Portal - Designed accessible interface for patients and doctors.',
      ],
      contactInfo: {
        'email': 'sarah@student.edu',
        'phone': '+91 9876543211',
        'linkedIn': 'linkedin.com/in/sarahwilliams',
        'portfolio': 'sarahwilliams.design'
      },
    ),
  ];

  // University Analytics Data
  static final List<PlacementData> placementData = [
    PlacementData(
      year: '2021',
      placementRate: 78.5,
      placementsByDepartment: {
        'Computer Science': 120,
        'Electrical Engineering': 85,
        'Information Technology': 95,
        'Mechanical Engineering': 70,
      },
      placementsByCompany: {
        'Tech Corporation': 35,
        'Innovate Solutions': 28,
        'Global Systems': 42,
        'Data Insights': 30,
        'Others': 235,
      },
      averageSalary: 750000,
    ),
    PlacementData(
      year: '2022',
      placementRate: 82.3,
      placementsByDepartment: {
        'Computer Science': 135,
        'Electrical Engineering': 90,
        'Information Technology': 105,
        'Mechanical Engineering': 75,
      },
      placementsByCompany: {
        'Tech Corporation': 40,
        'Innovate Solutions': 32,
        'Global Systems': 45,
        'Data Insights': 38,
        'Others': 250,
      },
      averageSalary: 800000,
    ),
    PlacementData(
      year: '2023',
      placementRate: 85.7,
      placementsByDepartment: {
        'Computer Science': 145,
        'Electrical Engineering': 95,
        'Information Technology': 120,
        'Mechanical Engineering': 80,
      },
      placementsByCompany: {
        'Tech Corporation': 45,
        'Innovate Solutions': 38,
        'Global Systems': 50,
        'Data Insights': 42,
        'Others': 265,
      },
      averageSalary: 850000,
    ),
  ];

  static final List<SkillGapData> skillGapData = [
    SkillGapData(skill: 'Machine Learning', demandCount: 85, supplyCount: 25),
    SkillGapData(skill: 'Cloud Computing', demandCount: 100, supplyCount: 40),
    SkillGapData(skill: 'Cybersecurity', demandCount: 70, supplyCount: 15),
    SkillGapData(skill: 'DevOps', demandCount: 60, supplyCount: 20),
    SkillGapData(skill: 'Mobile Development', demandCount: 90, supplyCount: 60),
    SkillGapData(skill: 'Data Science', demandCount: 80, supplyCount: 35),
    SkillGapData(skill: 'Blockchain', demandCount: 40, supplyCount: 10),
    SkillGapData(skill: 'UI/UX Design', demandCount: 65, supplyCount: 45),
  ];

  static final List<ProgramRecommendation> programRecommendations = [
    ProgramRecommendation(
      name: 'AI & Machine Learning Bootcamp',
      description:
          'Intensive 8-week program covering ML fundamentals, deep learning, and practical applications.',
      targetSkills: [
        'Machine Learning',
        'Python',
        'TensorFlow',
        'Data Analysis'
      ],
      duration: '8 weeks',
      estimatedImpact: 15.0,
    ),
    ProgramRecommendation(
      name: 'Cloud Computing Certification',
      description:
          'Prepare students for industry-recognized cloud certifications with hands-on projects.',
      targetSkills: ['Cloud Computing', 'AWS', 'Azure', 'Docker', 'Kubernetes'],
      duration: '12 weeks',
      estimatedImpact: 18.5,
    ),
    ProgramRecommendation(
      name: 'Cybersecurity Workshop Series',
      description:
          'Weekly workshops on different aspects of cybersecurity, culminating in a capture-the-flag competition.',
      targetSkills: [
        'Cybersecurity',
        'Network Security',
        'Cryptography',
        'Ethical Hacking'
      ],
      duration: '10 weeks',
      estimatedImpact: 12.0,
    ),
  ];

  // AI-matched job recommendations
  static List<JobListing> getRecommendedJobs(String studentId) {
    // Find the student profile
    final student = studentProfiles.firstWhere(
      (s) => s.userId == studentId,
      orElse: () => studentProfiles[0], // Default to first student if not found
    );

    // Calculate match scores for all jobs
    final scores = <String, double>{};
    for (var job in jobListings) {
      double matchScore = job.calculateSkillMatch(student.skills);
      scores[job.id] = matchScore;
    }

    // Sort jobs by match score
    final sortedJobs = List<JobListing>.from(jobListings);
    sortedJobs.sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));

    // Return top matches (or all if fewer than 3)
    return sortedJobs.take(min(3, sortedJobs.length)).toList();
  }

  // Get applications for an employer
  static List<Map<String, dynamic>> getEmployerApplications(String employerId) {
    List<Map<String, dynamic>> result = [];

    // Find jobs posted by this employer
    final employerJobs =
        jobListings.where((job) => job.employerId == employerId).toList();

    // Find applications for these jobs
    for (var job in employerJobs) {
      final applications =
          jobApplications.where((app) => app.jobId == job.id).toList();

      for (var application in applications) {
        // Find student profile
        final student = studentProfiles.firstWhere(
          (s) => s.userId == application.studentId,
          orElse: () =>
              studentProfiles[0], // Default to first student if not found
        );

        result.add({
          'application': application,
          'job': job,
          'student': student,
        });
      }
    }

    return result;
  }
}
