import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesSectionWidget extends StatefulWidget {
  final Map<String, dynamic> preferences;
  final Function(Map<String, dynamic>) onPreferencesUpdated;

  const AppPreferencesSectionWidget({
    Key? key,
    required this.preferences,
    required this.onPreferencesUpdated,
  }) : super(key: key);

  @override
  State<AppPreferencesSectionWidget> createState() =>
      _AppPreferencesSectionWidgetState();
}

class _AppPreferencesSectionWidgetState
    extends State<AppPreferencesSectionWidget> {
  late Map<String, dynamic> _currentPreferences;

  @override
  void initState() {
    super.initState();
    _currentPreferences = Map.from(widget.preferences);
  }

  void _updatePreference(String key, dynamic value) {
    setState(() {
      _currentPreferences[key] = value;
    });
    widget.onPreferencesUpdated(_currentPreferences);
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required String preferenceKey,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: Switch(
        value: _currentPreferences[preferenceKey] ?? false,
        onChanged: (value) => _updatePreference(preferenceKey, value),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required String preferenceKey,
    required List<String> options,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentPreferences[preferenceKey] ?? options.first,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
        ],
      ),
      onTap: () => _showSelectionDialog(title, preferenceKey, options),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  void _showSelectionDialog(
      String title, String preferenceKey, List<String> options) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _currentPreferences[preferenceKey],
                    onChanged: (value) {
                      if (value != null) {
                        _updatePreference(preferenceKey, value);
                        Navigator.pop(context);
                      }
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
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
                  iconName: 'settings',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'App Preferences',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          _buildSwitchTile(
            title: 'Workout Reminders',
            subtitle: 'Get notified about your scheduled workouts',
            preferenceKey: 'workoutReminders',
            icon: Icons.fitness_center,
          ),
          _buildSwitchTile(
            title: 'Meal Reminders',
            subtitle: 'Receive notifications for meal times',
            preferenceKey: 'mealReminders',
            icon: Icons.restaurant,
          ),
          _buildSwitchTile(
            title: 'Progress Updates',
            subtitle: 'Weekly progress and achievement notifications',
            preferenceKey: 'progressUpdates',
            icon: Icons.trending_up,
          ),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            preferenceKey: 'darkMode',
            icon: Icons.dark_mode,
          ),
          _buildSelectionTile(
            title: 'Unit System',
            subtitle: 'Choose your preferred measurement units',
            preferenceKey: 'unitSystem',
            options: ['Metric (kg, cm)', 'Imperial (lbs, ft)'],
            icon: Icons.straighten,
          ),
          _buildSelectionTile(
            title: 'Language',
            subtitle: 'Select your preferred language',
            preferenceKey: 'language',
            options: ['English', 'Spanish', 'French', 'German'],
            icon: Icons.language,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
