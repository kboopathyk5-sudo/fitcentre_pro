import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/account_management_section_widget.dart';
import './widgets/achievement_showcase_widget.dart';
import './widgets/app_preferences_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/profile_header_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;

  // Mock user data
  Map<String, dynamic> _userInfo = {
    'name': 'Alex Johnson',
    'age': 28,
    'height': 175.0,
    'weight': 72.5,
    'goals': 'Build muscle and improve endurance',
    'fitnessLevel': 'Intermediate',
    'joinDate': 'Jan 2024',
    'profileImage':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
  };

  Map<String, dynamic> _preferences = {
    'workoutReminders': true,
    'mealReminders': true,
    'progressUpdates': false,
    'darkMode': false,
    'unitSystem': 'Metric (kg, cm)',
    'language': 'English',
  };

  final List<Map<String, dynamic>> _achievements = [
    {
      'type': 'badge',
      'title': 'First Workout',
      'icon': 'fitness_center',
      'color': '0xFFFF6B35',
      'date': '2024-01-15',
    },
    {
      'type': 'badge',
      'title': '7 Day Streak',
      'icon': 'local_fire_department',
      'color': '0xFFE55A2B',
      'date': '2024-01-22',
    },
    {
      'type': 'badge',
      'title': 'Weight Goal',
      'icon': 'trending_up',
      'color': '0xFF4ECDC4',
      'date': '2024-02-10',
    },
    {
      'type': 'milestone',
      'title': '50 Workouts Completed',
      'description': 'Congratulations on completing 50 workout sessions!',
      'icon': 'emoji_events',
      'date': '2024-08-15',
    },
    {
      'type': 'milestone',
      'title': '10kg Weight Loss',
      'description': 'Amazing progress on your weight loss journey!',
      'icon': 'monitor_weight',
      'date': '2024-07-28',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras!.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras!.first)
            : _cameras!.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras!.first);

        _cameraController = CameraController(
            camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
        await _cameraController!.initialize();

        // Apply settings (skip unsupported on web)
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
        } catch (e) {}

        if (!kIsWeb) {
          try {
            await _cameraController!.setFlashMode(FlashMode.auto);
          } catch (e) {}
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _userInfo['profileImage'] = photo.path;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: AppTheme.lightTheme.primaryColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture photo'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Update Profile Picture',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () => _showCameraPreview(),
                ),
                _buildImageOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () => _pickImageFromGallery(),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCameraPreview() {
    Navigator.pop(context);
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera not available'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 70.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Take Photo',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.textTheme.bodyLarge?.color ??
                            Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CameraPreview(_cameraController!),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: _capturePhoto,
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context);
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _userInfo['profileImage'] = image.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: AppTheme.lightTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _exportUserData() async {
    try {
      final userData = {
        'userInfo': _userInfo,
        'preferences': _preferences,
        'achievements': _achievements,
        'exportDate': DateTime.now().toIso8601String(),
      };

      final jsonString = JsonEncoder.withIndent('  ').convert(userData);
      final filename =
          'fitcentre_pro_data_${DateTime.now().millisecondsSinceEpoch}.json';

      if (kIsWeb) {
        final bytes = utf8.encode(jsonString);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(jsonString);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported successfully'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export data'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _shareAchievements() {
    final achievementCount = _achievements.length;
    final badgeCount =
        (_achievements as List).where((item) => item['type'] == 'badge').length;
    final milestoneCount = (_achievements as List)
        .where((item) => item['type'] == 'milestone')
        .length;

    final shareText = '''
🏆 My FitCentre Pro Achievements 🏆

Total Achievements: $achievementCount
🏅 Badges Earned: $badgeCount
🎯 Milestones Reached: $milestoneCount

Join me on my fitness journey with FitCentre Pro!
#FitnessMotivation #FitCentrePro #HealthyLifestyle
    ''';

    // For web, copy to clipboard
    if (kIsWeb) {
      html.window.navigator.clipboard?.writeText(shareText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Achievement summary copied to clipboard'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    } else {
      // For mobile, show share dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share functionality would open system share sheet'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeaderWidget(
                userName: _userInfo['name'] ?? 'User',
                fitnessLevel: _userInfo['fitnessLevel'] ?? 'Beginner',
                joinDate: _userInfo['joinDate'] ?? 'Recently',
                profileImageUrl: _userInfo['profileImage'] ?? '',
                onEditPressed: () {
                  // Navigate to edit profile or show edit dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Edit profile functionality'),
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                    ),
                  );
                },
                onProfileImageTapped: _showImagePickerOptions,
              ),
              SizedBox(height: 2.h),
              PersonalInfoSectionWidget(
                userInfo: _userInfo,
                onInfoUpdated: (updatedInfo) {
                  setState(() {
                    _userInfo = updatedInfo;
                  });
                },
              ),
              AppPreferencesSectionWidget(
                preferences: _preferences,
                onPreferencesUpdated: (updatedPreferences) {
                  setState(() {
                    _preferences = updatedPreferences;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Preferences updated'),
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                    ),
                  );
                },
              ),
              AccountManagementSectionWidget(
                onChangePassword: () {
                  // Handled within the widget
                },
                onUpdateEmail: () {
                  // Handled within the widget
                },
                onExportData: _exportUserData,
                onDeleteAccount: () {
                  // Handled within the widget
                },
              ),
              AchievementShowcaseWidget(
                achievements: _achievements,
                onSharePressed: _shareAchievements,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: CustomIconWidget(
                    iconName: 'logout',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
