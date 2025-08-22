import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final Function(String) onChanged;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onFilterTap,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search workout categories...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppTheme.textDisabledDark
                          : AppTheme.textDisabledLight,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.primaryDark.withValues(alpha: 0.1)
                    : AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'tune',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
