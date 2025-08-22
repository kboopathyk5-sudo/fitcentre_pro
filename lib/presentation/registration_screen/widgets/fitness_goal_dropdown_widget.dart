import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FitnessGoalDropdownWidget extends StatefulWidget {
  final String? selectedGoal;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const FitnessGoalDropdownWidget({
    Key? key,
    required this.selectedGoal,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<FitnessGoalDropdownWidget> createState() =>
      _FitnessGoalDropdownWidgetState();
}

class _FitnessGoalDropdownWidgetState extends State<FitnessGoalDropdownWidget> {
  bool _hasError = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _fitnessGoals = [
    {
      'value': 'weight_loss',
      'label': 'Weight Loss',
      'description': 'Burn calories and lose weight',
      'icon': 'trending_down',
    },
    {
      'value': 'muscle_gain',
      'label': 'Muscle Gain',
      'description': 'Build strength and muscle mass',
      'icon': 'fitness_center',
    },
    {
      'value': 'general_fitness',
      'label': 'General Fitness',
      'description': 'Stay healthy and active',
      'icon': 'favorite',
    },
    {
      'value': 'endurance',
      'label': 'Endurance',
      'description': 'Improve stamina and cardio',
      'icon': 'directions_run',
    },
  ];

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.selectedGoal);
      setState(() {
        _hasError = error != null;
        _errorMessage = error;
      });
    }
  }

  Color _getBorderColor() {
    if (_hasError) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (widget.selectedGoal != null) {
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
          'Fitness Goal',
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
          child: DropdownButtonFormField<String>(
            value: widget.selectedGoal,
            onChanged: (value) {
              widget.onChanged(value);
              _validateField();
            },
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: 'Select your fitness goal',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
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
            dropdownColor: AppTheme.lightTheme.colorScheme.surface,
            icon: CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            items: _fitnessGoals.map((goal) {
              return DropdownMenuItem<String>(
                value: goal['value'],
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: goal['icon'],
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            goal['label'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            goal['description'],
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
        ] else if (widget.selectedGoal != null) ...[
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
                'Great choice!',
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
