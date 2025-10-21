import 'package:flutter/material.dart';
import '../../models/dummy_data.dart';
import '../../models/job.dart';
import '../../responsive_layout.dart';
import '../../widgets/job_card.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({Key? key}) : super(key: key);

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  final _searchController = TextEditingController();
  final _studentProfile = DummyData.studentProfiles[0];

  // Filters
  String? _selectedLocation;
  String? _selectedEmploymentType;
  RangeValues _salaryRange = const RangeValues(0, 2000000);

  List<JobListing> _filteredJobs = [];
  List<JobListing> _allJobs = [];
  bool _isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    _allJobs = DummyData.jobListings;
    _filteredJobs = _allJobs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Search'),
        actions: [
          IconButton(
            icon: Icon(
                _isFilterVisible ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildSearchBar(),
        ),
        if (_isFilterVisible) _buildFilterSection(),
        Expanded(
          child: _buildJobsList(),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterSection(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildJobsList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search jobs...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            _applyFilters();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        _applyFilters();
      },
    );
  }

  Widget _buildFilterSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Location filter
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedLocation,
              items: _getUniqueLocations().map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                  _applyFilters();
                });
              },
            ),
            const SizedBox(height: 16),

            // Employment type filter
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Employment Type',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedEmploymentType,
              items: _getUniqueEmploymentTypes().map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEmploymentType = value;
                  _applyFilters();
                });
              },
            ),
            const SizedBox(height: 16),

            // Salary range filter
            const Text('Salary Range (₹)'),
            RangeSlider(
              values: _salaryRange,
              min: 0,
              max: 2000000,
              divisions: 20,
              labels: RangeLabels(
                '₹${_salaryRange.start.round()}',
                '₹${_salaryRange.end.round()}',
              ),
              onChanged: (values) {
                setState(() {
                  _salaryRange = values;
                });
              },
              onChangeEnd: (values) {
                _applyFilters();
              },
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsList() {
    if (_filteredJobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No jobs found matching your criteria',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredJobs.length,
      itemBuilder: (context, index) {
        final job = _filteredJobs[index];
        return JobCard(
          job: job,
          studentProfile: _studentProfile,
          onApplyTap: () => _showApplyConfirmation(job),
        );
      },
    );
  }

  void _applyFilters() {
    String searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredJobs = _allJobs.where((job) {
        // Search query filter
        bool matchesSearch = searchQuery.isEmpty ||
            job.title.toLowerCase().contains(searchQuery) ||
            job.company.toLowerCase().contains(searchQuery) ||
            job.description.toLowerCase().contains(searchQuery) ||
            job.skills
                .any((skill) => skill.toLowerCase().contains(searchQuery));

        // Location filter
        bool matchesLocation =
            _selectedLocation == null || job.location == _selectedLocation;

        // Employment type filter
        bool matchesEmploymentType = _selectedEmploymentType == null ||
            job.employmentType == _selectedEmploymentType;

        // Salary filter
        bool matchesSalary = job.salaryMin == null ||
            job.salaryMax == null ||
            (job.salaryMin! <= _salaryRange.end &&
                job.salaryMax! >= _salaryRange.start);

        return matchesSearch &&
            matchesLocation &&
            matchesEmploymentType &&
            matchesSalary;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedLocation = null;
      _selectedEmploymentType = null;
      _salaryRange = const RangeValues(0, 2000000);
      _filteredJobs = _allJobs;
    });
  }

  List<String> _getUniqueLocations() {
    Set<String> locations = {};
    for (var job in _allJobs) {
      locations.add(job.location);
    }
    return locations.toList()..sort();
  }

  List<String> _getUniqueEmploymentTypes() {
    Set<String> types = {};
    for (var job in _allJobs) {
      types.add(job.employmentType);
    }
    return types.toList()..sort();
  }

  void _showApplyConfirmation(JobListing job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Apply for Job'),
          content: Text(
              'Are you sure you want to apply for ${job.title} at ${job.company}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _applyForJob(job);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyForJob(JobListing job) {
    // In a real app, this would send an application to a backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted for ${job.title}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
