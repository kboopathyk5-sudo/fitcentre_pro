import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({Key? key}) : super(key: key);

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 4.w,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
                    .withValues(alpha: _animation.value),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppTheme.dividerDark
                                : AppTheme.dividerLight)
                            .withValues(alpha: _animation.value),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight)
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 50.w,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight)
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 30.w,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight)
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
