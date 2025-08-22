import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/workout_categories/workout_categories.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String workoutCategories = '/workout-categories';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    workoutCategories: (context) => const WorkoutCategories(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    registration: (context) => const RegistrationScreen(),
    // TODO: Add your other routes here
  };
}
