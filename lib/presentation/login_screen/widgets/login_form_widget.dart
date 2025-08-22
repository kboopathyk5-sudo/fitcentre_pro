import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isValidEmail(_emailController.text);

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required to start your fitness journey';
    }
    if (!_isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required to access your account';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validateEmail,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
              ),
            ),
            validator: _validatePassword,
            style: Theme.of(context).textTheme.bodyLarge,
            onFieldSubmitted: (_) => _handleLogin(),
          ),

          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      // Navigate to forgot password screen
                      Navigator.pushNamed(context, '/forgot-password');
                    },
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  (_isFormValid && !widget.isLoading) ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                    : (isDark
                        ? AppTheme.textDisabledDark
                        : AppTheme.textDisabledLight),
                foregroundColor: _isFormValid
                    ? (isDark
                        ? AppTheme.onPrimaryDark
                        : AppTheme.onPrimaryLight)
                    : (isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight),
                elevation: _isFormValid ? 2.0 : 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? AppTheme.onPrimaryDark
                              : AppTheme.onPrimaryLight,
                        ),
                      ),
                    )
                  : Text(
                      'Start Your Journey',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: _isFormValid
                                ? (isDark
                                    ? AppTheme.onPrimaryDark
                                    : AppTheme.onPrimaryLight)
                                : (isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
