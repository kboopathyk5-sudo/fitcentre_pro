import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MeasurementInputWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isMetric;
  final String metricUnit;
  final String imperialUnit;
  final Function(bool) onUnitChanged;

  const MeasurementInputWidget({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    required this.isMetric,
    required this.metricUnit,
    required this.imperialUnit,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  State<MeasurementInputWidget> createState() => _MeasurementInputWidgetState();
}

class _MeasurementInputWidgetState extends State<MeasurementInputWidget> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitToggle('Metric', widget.isMetric),
                  _buildUnitToggle('Imperial', !widget.isMetric),
                ],
              ),
            ),
          ],
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter ${widget.label.toLowerCase()}',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              suffixText:
                  widget.isMetric ? widget.metricUnit : widget.imperialUnit,
              suffixStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
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
                'Perfect!',
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

  Widget _buildUnitToggle(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'Metric' && !widget.isMetric) {
          widget.onUnitChanged(true);
        } else if (label == 'Imperial' && widget.isMetric) {
          widget.onUnitChanged(false);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
