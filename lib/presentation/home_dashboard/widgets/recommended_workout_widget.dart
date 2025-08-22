import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecommendedWorkoutWidget extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onTap;

  const RecommendedWorkoutWidget({
    Key? key,
    required this.workout,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Recommended Workout',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadow(isLight: true),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CustomImageWidget(
                    imageUrl: workout['image'] as String,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              workout['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                      workout['difficulty'] as String)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              workout['difficulty'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: _getDifficultyColor(
                                    workout['difficulty'] as String),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        workout['description'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                          fontSize: 12.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: 'schedule',
                            text: '${workout['duration']} min',
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                          SizedBox(width: 3.w),
                          _buildInfoChip(
                            icon: 'local_fire_department',
                            text: '${workout['calories']} kcal',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'arrow_forward',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successLight;
      case 'intermediate':
        return AppTheme.accentLight;
      case 'advanced':
        return AppTheme.lightTheme.primaryColor;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
