import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressSummaryWidget extends StatelessWidget {
  final int caloriesBurned;
  final int caloriesGoal;
  final bool workoutCompleted;
  final double dailyGoalProgress;

  const ProgressSummaryWidget({
    Key? key,
    required this.caloriesBurned,
    required this.caloriesGoal,
    required this.workoutCompleted,
    required this.dailyGoalProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: _buildProgressCard(
              title: 'Calories',
              value: '$caloriesBurned',
              subtitle: 'of $caloriesGoal kcal',
              progress: caloriesBurned / caloriesGoal,
              color: AppTheme.lightTheme.primaryColor,
              icon: 'local_fire_department',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildProgressCard(
              title: 'Workout',
              value: workoutCompleted ? 'Done' : 'Pending',
              subtitle: 'Today\'s session',
              progress: workoutCompleted ? 1.0 : 0.0,
              color: AppTheme.lightTheme.colorScheme.secondary,
              icon: 'fitness_center',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildProgressCard(
              title: 'Daily Goal',
              value: '${(dailyGoalProgress * 100).toInt()}%',
              subtitle: 'Completed',
              progress: dailyGoalProgress,
              color: AppTheme.accentLight,
              icon: 'emoji_events',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required String subtitle,
    required double progress,
    required Color color,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
              Container(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontSize: 9.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
