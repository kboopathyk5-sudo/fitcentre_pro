import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignupPromptWidget extends StatelessWidget {
  final bool isLoading;

  const SignupPromptWidget({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New to fitness? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
          GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    Navigator.pushNamed(context, '/registration-screen');
                  },
            child: Text(
              'Sign Up',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor:
                        isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
