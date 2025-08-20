class PlacementData {
  final String year;
  final double placementRate;
  final Map<String, int> placementsByDepartment;
  final Map<String, int> placementsByCompany;
  final double averageSalary;

  PlacementData({
    required this.year,
    required this.placementRate,
    required this.placementsByDepartment,
    required this.placementsByCompany,
    required this.averageSalary,
  });
}

class SkillGapData {
  final String skill;
  final int demandCount; // Number of jobs requiring this skill
  final int supplyCount; // Number of students with this skill

  SkillGapData({
    required this.skill,
    required this.demandCount,
    required this.supplyCount,
  });

  double get gapPercentage =>
      supplyCount > 0 ? ((demandCount - supplyCount) / demandCount) * 100 : 100;
}

class ProgramRecommendation {
  final String name;
  final String description;
  final List<String> targetSkills;
  final String duration;
  final double estimatedImpact; // Percentage improvement in placements

  ProgramRecommendation({
    required this.name,
    required this.description,
    required this.targetSkills,
    required this.duration,
    required this.estimatedImpact,
  });
}
