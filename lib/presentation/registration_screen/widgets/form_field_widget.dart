import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FormFieldWidget extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool enabled;

  const FormFieldWidget({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateField);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateField);
    super.dispose();
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _hasError = error != null;
        _errorMessage = error;
      });
    }
  }

  Color _getBorderColor() {
    if (_hasError) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (widget.controller.text.isNotEmpty && !_hasError) {
      return AppTheme.lightTheme.colorScheme.secondary;
    }
    return AppTheme.lightTheme.dividerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: AppTheme.lightTheme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _getBorderColor(),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _getBorderColor(),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _hasError
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (_hasError && _errorMessage != null) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ] else if (widget.controller.text.isNotEmpty && !_hasError) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle_outline',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                'Looks good!',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
