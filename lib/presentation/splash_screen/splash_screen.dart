import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoPulseAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _loadingText = 'Initializing...';
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo scale animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _loadingAnimationController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      // Simulate initialization steps with realistic timing
      await _performInitializationSteps();

      // Navigate based on authentication status
      await _handleNavigation();
    } catch (e) {
      // Handle initialization errors gracefully
      _handleInitializationError();
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'text': 'Checking authentication...', 'duration': 800},
      {'text': 'Loading user preferences...', 'duration': 600},
      {'text': 'Fetching workout categories...', 'duration': 700},
      {'text': 'Preparing fitness data...', 'duration': 500},
      {'text': 'Ready to go!', 'duration': 400},
    ];

    for (int i = 0; i < steps.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = steps[i]['text'] as String;
          _loadingProgress = (i + 1) / steps.length;
        });
      }
      await Future.delayed(Duration(milliseconds: steps[i]['duration'] as int));
    }
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    // Simulate authentication check
    final isAuthenticated = await _checkAuthenticationStatus();
    final isFirstTime = await _checkFirstTimeUser();

    // Add small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (isAuthenticated) {
      // Navigate to home dashboard for authenticated users
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else if (isFirstTime) {
      // Navigate to registration for first-time users
      Navigator.pushReplacementNamed(context, '/registration-screen');
    } else {
      // Navigate to login for returning users
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate Firebase authentication check
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return false (not authenticated)
    return false;
  }

  Future<bool> _checkFirstTimeUser() async {
    // Simulate checking if user has opened app before
    await Future.delayed(const Duration(milliseconds: 100));
    // For demo purposes, return false (returning user)
    return false;
  }

  void _handleInitializationError() {
    if (mounted) {
      setState(() {
        _loadingText = 'Connection timeout. Tap to retry.';
        _isInitializing = false;
      });

      // Auto-retry after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && !_isInitializing) {
          _retryInitialization();
        }
      });
    }
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _loadingText = 'Retrying...';
      _loadingProgress = 0.0;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value *
                            _logoPulseAnimation.value,
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'fitness_center',
                                color: Colors.white,
                                size: 12.w,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'FitCentre',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                'PRO',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading Progress Bar
                    Container(
                      width: 60.w,
                      height: 4,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60.w * _loadingProgress,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Loading Text
                    GestureDetector(
                      onTap: _isInitializing ? null : _retryInitialization,
                      child: AnimatedBuilder(
                        animation: _loadingAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _isInitializing
                                ? (0.7 + 0.3 * _loadingAnimation.value)
                                : 1.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isInitializing) ...[
                                  SizedBox(
                                    width: 4.w,
                                    height: 4.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                ] else ...[
                                  CustomIconWidget(
                                    iconName: 'refresh',
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 3.w),
                                ],
                                Flexible(
                                  child: Text(
                                    _loadingText,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Motivational Quote
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        '"Your fitness journey starts with a single step"',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11.sp,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Version Info
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'Version 1.0.0',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
