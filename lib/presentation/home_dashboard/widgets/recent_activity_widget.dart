import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        activities.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activities.length > 3 ? 3 : activities.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return _buildActivityCard(activity);
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'fitness_center',
            color: AppTheme.textSecondaryLight,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your first workout to see your activity here',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final isWorkout = activity['type'] == 'workout';
    final color = isWorkout
        ? AppTheme.lightTheme.primaryColor
        : AppTheme.lightTheme.colorScheme.secondary;
    final icon = isWorkout ? 'fitness_center' : 'restaurant';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['subtitle'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontSize: 11.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity['value'] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _formatTimestamp(activity['timestamp'] as DateTime),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
