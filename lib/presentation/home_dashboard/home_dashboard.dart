import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/progress_summary_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/recommended_workout_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock user data
  final String userName = "Alex Johnson";
  final List<String> motivationalQuotes = [
    "Your body can do it. It's your mind you have to convince.",
    "The only bad workout is the one that didn't happen.",
    "Strength doesn't come from what you can do. It comes from overcoming the things you once thought you couldn't.",
    "Push yourself because no one else is going to do it for you.",
    "Great things never come from comfort zones.",
  ];

  // Mock progress data
  final int caloriesBurned = 420;
  final int caloriesGoal = 600;
  final bool workoutCompleted = false;
  final double dailyGoalProgress = 0.7;

  // Mock recommended workout
  final Map<String, dynamic> recommendedWorkout = {
    "id": 1,
    "name": "Full Body HIIT",
    "description":
        "High-intensity interval training targeting all major muscle groups for maximum calorie burn and strength building.",
    "duration": 30,
    "calories": 350,
    "difficulty": "Intermediate",
    "image":
        "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  };

  // Mock recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "workout",
      "title": "Morning Cardio",
      "subtitle": "Running & Cycling",
      "value": "280 kcal",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "meal",
      "title": "Healthy Breakfast",
      "subtitle": "Oatmeal with berries",
      "value": "320 kcal",
      "timestamp": DateTime.now().subtract(Duration(hours: 4)),
    },
    {
      "id": 3,
      "type": "workout",
      "title": "Strength Training",
      "subtitle": "Upper body focus",
      "value": "45 min",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                GreetingHeaderWidget(
                  userName: userName,
                  motivationalQuote: _getRandomQuote(),
                ),
                SizedBox(height: 3.h),
                ProgressSummaryWidget(
                  caloriesBurned: caloriesBurned,
                  caloriesGoal: caloriesGoal,
                  workoutCompleted: workoutCompleted,
                  dailyGoalProgress: dailyGoalProgress,
                ),
                SizedBox(height: 3.h),
                QuickActionsWidget(
                  onStartWorkout: _onStartWorkout,
                  onLogMeal: _onLogMeal,
                  onViewProgress: _onViewProgress,
                ),
                SizedBox(height: 3.h),
                RecommendedWorkoutWidget(
                  workout: recommendedWorkout,
                  onTap: _onRecommendedWorkoutTap,
                ),
                SizedBox(height: 3.h),
                RecentActivityWidget(
                  activities: recentActivities,
                ),
                SizedBox(height: 10.h), // Extra space for bottom navigation
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryLight,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fitness_center',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'restaurant',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onQuickWorkoutStart,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'play_arrow',
          color: AppTheme.onPrimaryLight,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getRandomQuote() {
    final now = DateTime.now();
    final index = now.day % motivationalQuotes.length;
    return motivationalQuotes[index];
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully!'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/workout-categories');
        break;
      case 2:
        // Navigate to diet screen (not implemented)
        _showFeatureComingSoon('Diet Planning');
        break;
      case 3:
        // Navigate to progress screen (not implemented)
        _showFeatureComingSoon('Progress Tracking');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _onStartWorkout() {
    Navigator.pushNamed(context, '/workout-categories');
  }

  void _onLogMeal() {
    _showFeatureComingSoon('Meal Logging');
  }

  void _onViewProgress() {
    _showFeatureComingSoon('Progress Analytics');
  }

  void _onRecommendedWorkoutTap() {
    Navigator.pushNamed(context, '/workout-categories');
  }

  void _onQuickWorkoutStart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondaryLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Start Workout',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose your workout type to get started immediately',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/workout-categories');
                    },
                    icon: CustomIconWidget(
                      iconName: 'fitness_center',
                      color: AppTheme.onPrimaryLight,
                      size: 20,
                    ),
                    label: Text('Strength'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/workout-categories');
                    },
                    icon: CustomIconWidget(
                      iconName: 'directions_run',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: Text('Cardio'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showFeatureComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName feature coming soon!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
