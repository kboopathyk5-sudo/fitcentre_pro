import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String fitnessLevel;
  final String joinDate;
  final String profileImageUrl;
  final VoidCallback onEditPressed;
  final VoidCallback onProfileImageTapped;

  const ProfileHeaderWidget({
    Key? key,
    required this.userName,
    required this.fitnessLevel,
    required this.joinDate,
    required this.profileImageUrl,
    required this.onEditPressed,
    required this.onProfileImageTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onProfileImageTapped,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: profileImageUrl,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        fitnessLevel,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Joined $joinDate',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEditPressed,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: Colors.white,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
