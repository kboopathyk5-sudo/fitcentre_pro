import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/search_bar_widget.dart';

class WorkoutCategories extends StatefulWidget {
  const WorkoutCategories({Key? key}) : super(key: key);

  @override
  State<WorkoutCategories> createState() => _WorkoutCategoriesState();
}

class _WorkoutCategoriesState extends State<WorkoutCategories> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {
    'difficulty': <String>[],
    'duration': <String>[],
    'equipment': <String>[],
  };

  // Mock data for workout categories
  final List<Map<String, dynamic>> _allCategories = [
    {
      "id": 1,
      "name": "Fitness",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 45,
      "difficulty": "Beginner",
      "duration": "15-30 min",
      "equipment": "No Equipment",
      "description": "General fitness routines for overall health and wellness"
    },
    {
      "id": 2,
      "name": "Weight Gain",
      "image":
          "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 32,
      "difficulty": "Intermediate",
      "duration": "45-60 min",
      "equipment": "Dumbbells",
      "description":
          "Muscle building workouts focused on strength and mass gain"
    },
    {
      "id": 3,
      "name": "Cardio",
      "image":
          "https://images.unsplash.com/photo-1538805060514-97d9cc17730c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 28,
      "difficulty": "Beginner",
      "duration": "30-45 min",
      "equipment": "No Equipment",
      "description": "High-intensity cardiovascular exercises for heart health"
    },
    {
      "id": 4,
      "name": "Strength",
      "image":
          "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 38,
      "difficulty": "Advanced",
      "duration": "60+ min",
      "equipment": "Full Gym",
      "description": "Advanced strength training for serious athletes"
    },
    {
      "id": 5,
      "name": "Yoga",
      "image":
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 25,
      "difficulty": "Beginner",
      "duration": "30-45 min",
      "equipment": "No Equipment",
      "description": "Mindful movement and flexibility training"
    },
    {
      "id": 6,
      "name": "HIIT",
      "image":
          "https://images.unsplash.com/photo-1549476464-37392f717541?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "workoutCount": 22,
      "difficulty": "Intermediate",
      "duration": "15-30 min",
      "equipment": "Resistance Bands",
      "description": "High-Intensity Interval Training for maximum results"
    },
  ];

  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Simulate loading data from Firebase
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _filteredCategories = List.from(_allCategories);
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh from Firebase
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _filteredCategories = List.from(_allCategories);
      _isRefreshing = false;
    });
  }

  void _filterCategories() {
    List<Map<String, dynamic>> filtered = _allCategories.where((category) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final name = (category['name'] as String).toLowerCase();
        final description = (category['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!name.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Difficulty filter
      final difficultyFilters = _activeFilters['difficulty'] as List<String>;
      if (difficultyFilters.isNotEmpty) {
        if (!difficultyFilters.contains(category['difficulty'] as String)) {
          return false;
        }
      }

      // Duration filter
      final durationFilters = _activeFilters['duration'] as List<String>;
      if (durationFilters.isNotEmpty) {
        if (!durationFilters.contains(category['duration'] as String)) {
          return false;
        }
      }

      // Equipment filter
      final equipmentFilters = _activeFilters['equipment'] as List<String>;
      if (equipmentFilters.isNotEmpty) {
        if (!equipmentFilters.contains(category['equipment'] as String)) {
          return false;
        }
      }

      return true;
    }).toList();

    setState(() {
      _filteredCategories = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterCategories();
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _filterCategories();
  }

  void _removeFilter(String filterType, String value) {
    setState(() {
      (_activeFilters[filterType] as List<String>).remove(value);
    });
    _filterCategories();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters = {
        'difficulty': <String>[],
        'duration': <String>[],
        'equipment': <String>[],
      };
      _searchQuery = '';
      _searchController.clear();
    });
    _filterCategories();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    // Navigate to workout list within category
    // This would typically navigate to a workout list screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${category['name']} workouts...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCategoryLongPress(Map<String, dynamic> category) {
    _showQuickActions(category);
  }

  void _showQuickActions(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  category['name'] as String,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 24,
                ),
                title: Text('Add to Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Added ${category['name']} to favorites')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 24,
                ),
                title: Text('Share Category'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Sharing ${category['name']} category')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'list',
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 24,
                ),
                title: Text('View All Workouts'),
                onTap: () {
                  Navigator.pop(context);
                  _onCategoryTap(category);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  List<String> _getActiveFilterChips() {
    List<String> chips = [];

    final difficultyFilters = _activeFilters['difficulty'] as List<String>;
    final durationFilters = _activeFilters['duration'] as List<String>;
    final equipmentFilters = _activeFilters['equipment'] as List<String>;

    chips.addAll(difficultyFilters);
    chips.addAll(durationFilters);
    chips.addAll(equipmentFilters);

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeChips = _getActiveFilterChips();

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Workout Categories'),
        elevation: 0,
        backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        actions: [
          if (activeChips.isNotEmpty)
            TextButton(
              onPressed: _clearAllFilters,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SearchBarWidget(
                controller: _searchController,
                onFilterTap: _showFilterBottomSheet,
                onChanged: _onSearchChanged,
              ),
            ),

            // Active Filter Chips
            if (activeChips.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeChips.length,
                  itemBuilder: (context, index) {
                    final chip = activeChips[index];
                    return FilterChipWidget(
                      label: chip,
                      isSelected: true,
                      onTap: () {},
                      onRemove: () {
                        // Find which filter type this chip belongs to
                        String filterType = '';
                        if ((_activeFilters['difficulty'] as List<String>)
                            .contains(chip)) {
                          filterType = 'difficulty';
                        } else if ((_activeFilters['duration'] as List<String>)
                            .contains(chip)) {
                          filterType = 'duration';
                        } else if ((_activeFilters['equipment'] as List<String>)
                            .contains(chip)) {
                          filterType = 'equipment';
                        }
                        _removeFilter(filterType, chip);
                      },
                    );
                  },
                ),
              ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? const LoadingSkeletonWidget()
                  : _filteredCategories.isEmpty
                      ? EmptyStateWidget(
                          title:
                              _searchQuery.isNotEmpty || activeChips.isNotEmpty
                                  ? 'No Results Found'
                                  : 'No Categories Available',
                          subtitle: _searchQuery.isNotEmpty ||
                                  activeChips.isNotEmpty
                              ? 'Try adjusting your search or filters to find what you\'re looking for.'
                              : 'Check back later for new workout categories.',
                          buttonText:
                              _searchQuery.isNotEmpty || activeChips.isNotEmpty
                                  ? 'Clear Filters'
                                  : 'Explore All Categories',
                          onButtonPressed:
                              _searchQuery.isNotEmpty || activeChips.isNotEmpty
                                  ? _clearAllFilters
                                  : _refreshData,
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshData,
                          color: isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          child: GridView.builder(
                            padding: EdgeInsets.all(4.w),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.w,
                              mainAxisSpacing: 4.w,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredCategories.length,
                            itemBuilder: (context, index) {
                              final category = _filteredCategories[index];
                              return CategoryCardWidget(
                                category: category,
                                onTap: () => _onCategoryTap(category),
                                onLongPress: () =>
                                    _onCategoryLongPress(category),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
