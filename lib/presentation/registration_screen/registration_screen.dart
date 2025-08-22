import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/fitness_goal_dropdown_widget.dart';
import './widgets/form_field_widget.dart';
import './widgets/measurement_input_widget.dart';
import './widgets/password_strength_indicator_widget.dart';
import './widgets/profile_picture_upload_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Form state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isMetricHeight = true;
  bool _isMetricWeight = true;
  String? _selectedFitnessGoal;
  XFile? _selectedImage;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _isLoading = false;

  // Mock credentials for demonstration
  final Map<String, String> _mockCredentials = {
    'email': 'demo@fitcentre.com',
    'password': 'FitCentre123!',
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 13 || age > 100) {
      return 'Age must be between 13 and 100';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Height is required';
    }
    final height = double.tryParse(value.trim());
    if (height == null) {
      return 'Please enter a valid height';
    }
    if (_isMetricHeight) {
      if (height < 100 || height > 250) {
        return 'Height must be between 100-250 cm';
      }
    } else {
      if (height < 3 || height > 8) {
        return 'Height must be between 3-8 feet';
      }
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value.trim());
    if (weight == null) {
      return 'Please enter a valid weight';
    }
    if (_isMetricWeight) {
      if (weight < 30 || weight > 300) {
        return 'Weight must be between 30-300 kg';
      }
    } else {
      if (weight < 66 || weight > 660) {
        return 'Weight must be between 66-660 lbs';
      }
    }
    return null;
  }

  String? _validateFitnessGoal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your fitness goal';
    }
    return null;
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _acceptTerms &&
        _acceptPrivacy;
  }

  Future<void> _createAccount() async {
    if (!_isFormValid()) {
      if (!_acceptTerms || !_acceptPrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please accept the terms and privacy policy'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Firebase account creation
      await Future.delayed(Duration(seconds: 2));

      // Simulate success
      if (mounted) {
        // Trigger haptic feedback
        HapticFeedback.lightImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Welcome to FitCentre Pro!'),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );

        // Navigate to home dashboard
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      _buildHeader(),
                      SizedBox(height: 4.h),
                      _buildProfilePictureSection(),
                      SizedBox(height: 4.h),
                      _buildPersonalInfoSection(),
                      SizedBox(height: 3.h),
                      _buildAccountInfoSection(),
                      SizedBox(height: 3.h),
                      _buildPhysicalInfoSection(),
                      SizedBox(height: 3.h),
                      _buildFitnessGoalSection(),
                      SizedBox(height: 3.h),
                      _buildTermsSection(),
                      SizedBox(height: 4.h),
                      _buildCreateAccountButton(),
                      SizedBox(height: 2.h),
                      _buildLoginLink(),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join the Fitness Community',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Start your fitness journey today and achieve your goals with personalized workouts and nutrition plans.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Picture',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Center(
          child: ProfilePictureUploadWidget(
            selectedImage: _selectedImage,
            onImageSelected: (image) {
              setState(() {
                _selectedImage = image;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        FormFieldWidget(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: _fullNameController,
          validator: _validateFullName,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 2.h),
        FormFieldWidget(
          label: 'Age',
          hint: 'Enter your age',
          controller: _ageController,
          validator: _validateAge,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        FormFieldWidget(
          label: 'Email Address',
          hint: 'Enter your email address',
          controller: _emailController,
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 2.h),
        FormFieldWidget(
          label: 'Password',
          hint: 'Create a strong password',
          controller: _passwordController,
          validator: _validatePassword,
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: CustomIconWidget(
              iconName: _obscurePassword ? 'visibility' : 'visibility_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
        ),
        PasswordStrengthIndicatorWidget(password: _passwordController.text),
        SizedBox(height: 2.h),
        FormFieldWidget(
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          controller: _confirmPasswordController,
          validator: _validateConfirmPassword,
          obscureText: _obscureConfirmPassword,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: CustomIconWidget(
              iconName:
                  _obscureConfirmPassword ? 'visibility' : 'visibility_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhysicalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Physical Information',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        MeasurementInputWidget(
          label: 'Height',
          controller: _heightController,
          validator: _validateHeight,
          isMetric: _isMetricHeight,
          metricUnit: 'cm',
          imperialUnit: 'ft',
          onUnitChanged: (isMetric) {
            setState(() {
              _isMetricHeight = isMetric;
              _heightController.clear();
            });
          },
        ),
        SizedBox(height: 2.h),
        MeasurementInputWidget(
          label: 'Weight',
          controller: _weightController,
          validator: _validateWeight,
          isMetric: _isMetricWeight,
          metricUnit: 'kg',
          imperialUnit: 'lbs',
          onUnitChanged: (isMetric) {
            setState(() {
              _isMetricWeight = isMetric;
              _weightController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildFitnessGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Goals',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        FitnessGoalDropdownWidget(
          selectedGoal: _selectedFitnessGoal,
          onChanged: (value) {
            setState(() {
              _selectedFitnessGoal = value;
            });
          },
          validator: _validateFitnessGoal,
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _acceptTerms = !_acceptTerms;
                });
              },
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: _acceptTerms
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: _acceptTerms
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _acceptTerms
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 4.w,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _acceptPrivacy = !_acceptPrivacy;
                });
              },
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: _acceptPrivacy
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: _acceptPrivacy
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _acceptPrivacy
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 4.w,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return Container(
      width: double.infinity,
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Creating Account...',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'person_add',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Create Account',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/login-screen'),
        child: RichText(
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
