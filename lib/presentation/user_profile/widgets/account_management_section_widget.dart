import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountManagementSectionWidget extends StatelessWidget {
  final VoidCallback onChangePassword;
  final VoidCallback onUpdateEmail;
  final VoidCallback onExportData;
  final VoidCallback onDeleteAccount;

  const AccountManagementSectionWidget({
    Key? key,
    required this.onChangePassword,
    required this.onUpdateEmail,
    required this.onExportData,
    required this.onDeleteAccount,
  }) : super(key: key);

  Widget _buildAccountTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.lightTheme.primaryColor)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: iconColor ?? AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.primaryColor,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Current password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'New password is required';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password changed successfully'),
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                  ),
                );
              }
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showUpdateEmailDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Email'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'New Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Password is required for verification';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email updated successfully'),
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                  ),
                );
              }
            },
            child: Text('Update Email'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter your password to confirm',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account deletion initiated'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Account Management',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          _buildAccountTile(
            title: 'Change Password',
            subtitle: 'Update your account password',
            icon: Icons.lock_outline,
            onTap: () => _showChangePasswordDialog(context),
          ),
          _buildAccountTile(
            title: 'Update Email',
            subtitle: 'Change your email address',
            icon: Icons.email_outlined,
            onTap: () => _showUpdateEmailDialog(context),
          ),
          _buildAccountTile(
            title: 'Export Data',
            subtitle: 'Download your fitness data',
            icon: Icons.download,
            onTap: onExportData,
          ),
          _buildAccountTile(
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            icon: Icons.delete_forever,
            onTap: () => _showDeleteAccountDialog(context),
            iconColor: AppTheme.lightTheme.colorScheme.error,
            textColor: AppTheme.lightTheme.colorScheme.error,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
