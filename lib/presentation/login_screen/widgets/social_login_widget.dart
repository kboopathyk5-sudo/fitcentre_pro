import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function() onGoogleLogin;
  final Function() onAppleLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Google Login Button
        SizedBox(
          height: 6.h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onGoogleLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                width: 1.5,
              ),
              backgroundColor:
                  isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              foregroundColor:
                  isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageWidget(
                  imageUrl:
                      'https://developers.google.com/identity/images/g-logo.png',
                  width: 5.w,
                  height: 5.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Continue with Google',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Apple Login Button (iOS style)
        SizedBox(
          height: 6.h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onAppleLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                width: 1.5,
              ),
              backgroundColor:
                  isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              foregroundColor:
                  isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'apple',
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Continue with Apple',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
