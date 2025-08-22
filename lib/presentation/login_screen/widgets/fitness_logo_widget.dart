import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FitnessLogoWidget extends StatelessWidget {
  const FitnessLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Logo Container with gradient background
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                    .withValues(alpha: 0.3),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'fitness_center',
              color: isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // App Name
        Text(
          'FitCentre Pro',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                letterSpacing: -0.5,
              ),
        ),

        SizedBox(height: 0.5.h),

        // Tagline
        Text(
          'Your Fitness Journey Starts Here',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
