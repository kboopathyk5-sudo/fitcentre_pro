import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onStartWorkout;
  final VoidCallback onLogMeal;
  final VoidCallback onViewProgress;

  const QuickActionsWidget({
    Key? key,
    required this.onStartWorkout,
    required this.onLogMeal,
    required this.onViewProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Start Workout',
                subtitle: 'Begin your session',
                icon: 'play_arrow',
                color: AppTheme.lightTheme.primaryColor,
                onTap: onStartWorkout,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionCard(
                title: 'Log Meal',
                subtitle: 'Track your nutrition',
                icon: 'restaurant',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: onLogMeal,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        _buildActionCard(
          title: 'View Progress',
          subtitle: 'Check your fitness journey',
          icon: 'trending_up',
          color: AppTheme.accentLight,
          onTap: onViewProgress,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow(isLight: true),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: isFullWidth
            ? Row(
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
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.textSecondaryLight,
                    size: 16,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      fontSize: 10.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}
