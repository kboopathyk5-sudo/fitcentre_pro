import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/fitness_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/signup_prompt_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@fitcentre.com': 'admin123',
    'user@fitcentre.com': 'user123',
    'trainer@fitcentre.com': 'trainer123',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Firebase authentication delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase()) &&
          _mockCredentials[email.toLowerCase()] == password) {
        // Success haptic feedback
        HapticFeedback.lightImpact();

        // Show success toast
        Fluttertoast.showToast(
          msg: "Welcome back! Let's crush your fitness goals!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.successLight,
          textColor: Colors.white,
          fontSize: 14.sp,
        );

        // Navigate to home dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-dashboard');
        }
      } else {
        // Error haptic feedback
        HapticFeedback.mediumImpact();

        // Show error message with encouraging tone
        _showErrorMessage("Oops! Those credentials don't match our records. "
            "Double-check your email and password, or try signing up if you're new!");
      }
    } catch (e) {
      // Handle any unexpected errors
      HapticFeedback.heavyImpact();
      _showErrorMessage(
          "Something went wrong on our end. Please try again in a moment!");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Google authentication
      await Future.delayed(const Duration(seconds: 1));

      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Google login successful! Welcome to FitCentre Pro!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successLight,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      HapticFeedback.mediumImpact();
      _showErrorMessage("Google login failed. Please try again!");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Apple authentication
      await Future.delayed(const Duration(seconds: 1));

      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Apple login successful! Ready to start your fitness journey!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successLight,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      HapticFeedback.mediumImpact();
      _showErrorMessage("Apple login failed. Please try again!");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.errorLight,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),

                    // Fitness Logo
                    const FitnessLogoWidget(),

                    SizedBox(height: 6.h),

                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to continue your fitness journey',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Social Login Options
                    SocialLoginWidget(
                      onGoogleLogin: _handleGoogleLogin,
                      onAppleLogin: _handleAppleLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Sign Up Prompt
                    SignupPromptWidget(
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
