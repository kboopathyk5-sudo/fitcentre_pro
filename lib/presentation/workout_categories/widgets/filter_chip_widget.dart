import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
              : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDark
                            ? AppTheme.onPrimaryDark
                            : AppTheme.onPrimaryLight)
                        : (isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
            if (isSelected && onRemove != null) ...[
              SizedBox(width: 1.w),
              GestureDetector(
                onTap: onRemove,
                child: CustomIconWidget(
                  iconName: 'close',
                  color:
                      isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
