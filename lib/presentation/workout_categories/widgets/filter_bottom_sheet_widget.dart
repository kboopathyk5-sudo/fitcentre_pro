import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> _durations = [
    '15-30 min',
    '30-45 min',
    '45-60 min',
    '60+ min'
  ];
  final List<String> _equipment = [
    'No Equipment',
    'Dumbbells',
    'Resistance Bands',
    'Full Gym'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Workouts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Difficulty Level',
                    _difficultyLevels,
                    'difficulty',
                    isDark,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Duration',
                    _durations,
                    'duration',
                    isDark,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Equipment Needed',
                    _equipment,
                    'equipment',
                    isDark,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, String filterKey, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected =
                (_filters[filterKey] as List<String>? ?? []).contains(option);
            return GestureDetector(
              onTap: () => _toggleFilter(filterKey, option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight)
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? (isDark
                                ? AppTheme.onPrimaryDark
                                : AppTheme.onPrimaryLight)
                            : (isDark
                                ? AppTheme.textPrimaryDark
                                : AppTheme.textPrimaryLight),
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleFilter(String filterKey, String value) {
    setState(() {
      final currentList = (_filters[filterKey] as List<String>? ?? []);
      if (currentList.contains(value)) {
        currentList.remove(value);
      } else {
        currentList.add(value);
      }
      _filters[filterKey] = currentList;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'difficulty': <String>[],
        'duration': <String>[],
        'equipment': <String>[],
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }
}
