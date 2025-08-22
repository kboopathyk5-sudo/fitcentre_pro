import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final String motivationalQuote;

  const GreetingHeaderWidget({
    Key? key,
    required this.userName,
    required this.motivationalQuote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    String greeting = 'Good Morning';

    if (currentHour >= 12 && currentHour < 17) {
      greeting = 'Good Afternoon';
    } else if (currentHour >= 17) {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onPrimaryLight,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userName,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.onPrimaryLight,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.onPrimaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'fitness_center',
                  color: AppTheme.onPrimaryLight,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'format_quote',
                  color: AppTheme.onPrimaryLight,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    motivationalQuote,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onPrimaryLight,
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
