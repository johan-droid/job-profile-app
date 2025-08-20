import '../models/university_data.dart';
import '../models/dummy_data.dart';

class AnalyticsHelper {
  // Get placement trend data for charts
  static List<Map<String, dynamic>> getPlacementTrend() {
    return DummyData.placementData.map((data) {
      return {
        'year': data.year,
        'rate': data.placementRate,
      };
    }).toList();
  }
  
  // Get top skill gaps
  static List<SkillGapData> getTopSkillGaps() {
    final gaps = List<SkillGapData>.from(DummyData.skillGapData);
    gaps.sort((a, b) => b.gapPercentage.compareTo(a.gapPercentage));
    return gaps.take(5).toList();
  }
  
  // Get department performance data
  static Map<String, List<int>> getDepartmentPerformance() {
    Map<String, List<int>> result = {};
    
    // Initialize with empty lists
    for (var dept in DummyData.universityProfiles[0].departments) {
      result[dept] = [];
    }
    
    // Populate with placement counts by year
    for (var data in DummyData.placementData) {
      data.placementsByDepartment.forEach((dept, count) {
        if (result.containsKey(dept)) {
          result[dept]!.add(count);
        }
      });
    }
    
    return result;
  }
  
  // Get salary trend data
  static List<double> getSalaryTrend() {
    return DummyData.placementData.map((data) => data.averageSalary).toList();
  }
  
  // Get program impact scores
  static List<Map<String, dynamic>> getProgramImpactScores() {
    return DummyData.programRecommendations.map((program) {
      return {
        'name': program.name,
        'impact': program.estimatedImpact,
      };
    }).toList();
  }
}
