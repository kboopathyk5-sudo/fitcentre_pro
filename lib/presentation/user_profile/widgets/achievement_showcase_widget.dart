import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementShowcaseWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final VoidCallback onSharePressed;

  const AchievementShowcaseWidget({
    Key? key,
    required this.achievements,
    required this.onSharePressed,
  }) : super(key: key);

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    return Container(
      width: 25.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(int.parse(achievement['color'])),
                  Color(int.parse(achievement['color'])).withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(int.parse(achievement['color']))
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: achievement['icon'],
                color: Colors.white,
                size: 8.w.clamp(24.0, 32.0),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            achievement['title'],
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            achievement['date'],
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: milestone['icon'],
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  milestone['description'],
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  milestone['date'],
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badges = (achievements as List)
        .where((item) => item['type'] == 'badge')
        .toList();
    final milestones = (achievements as List)
        .where((item) => item['type'] == 'milestone')
        .toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Achievements',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onSharePressed,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 16,
                  ),
                  label: Text('Share'),
                ),
              ],
            ),
          ),
          if (badges.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Earned Badges',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: badges.length,
                itemBuilder: (context, index) =>
                    _buildAchievementBadge(badges[index]),
              ),
            ),
            SizedBox(height: 3.h),
          ],
          if (milestones.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Recent Milestones',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: milestones
                    .take(3)
                    .map((milestone) => _buildMilestoneCard(milestone))
                    .toList(),
              ),
            ),
          ],
          if (achievements.isEmpty)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.lightTheme.dividerColor,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No achievements yet',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Complete workouts and reach your goals to earn badges!',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
