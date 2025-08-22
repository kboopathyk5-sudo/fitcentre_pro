import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Function(Map<String, dynamic>) onInfoUpdated;

  const PersonalInfoSectionWidget({
    Key? key,
    required this.userInfo,
    required this.onInfoUpdated,
  }) : super(key: key);

  @override
  State<PersonalInfoSectionWidget> createState() =>
      _PersonalInfoSectionWidgetState();
}

class _PersonalInfoSectionWidgetState extends State<PersonalInfoSectionWidget> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _goalsController;

  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userInfo['name'] ?? '');
    _ageController =
        TextEditingController(text: widget.userInfo['age']?.toString() ?? '');
    _heightController = TextEditingController(
        text: widget.userInfo['height']?.toString() ?? '');
    _weightController = TextEditingController(
        text: widget.userInfo['weight']?.toString() ?? '');
    _goalsController =
        TextEditingController(text: widget.userInfo['goals'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedInfo = {
        ...widget.userInfo,
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'height': double.tryParse(_heightController.text) ?? 0.0,
        'weight': double.tryParse(_weightController.text) ?? 0.0,
        'goals': _goalsController.text,
      };

      widget.onInfoUpdated(updatedInfo);
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    }
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        _isEditing
            ? TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                decoration: InputDecoration(
                  suffixText: suffix,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                ),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                  ),
                ),
                child: Text(
                  '${controller.text} $suffix',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
        SizedBox(height: 2.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Personal Information',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    if (_isEditing) {
                      _saveChanges();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  child: Text(_isEditing ? 'Save' : 'Edit'),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildInfoField(
              label: 'Full Name',
              controller: _nameController,
              suffix: '',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: 'Age',
              controller: _ageController,
              suffix: 'years',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Age is required';
                }
                final age = int.tryParse(value!);
                if (age == null || age < 13 || age > 100) {
                  return 'Please enter a valid age (13-100)';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: 'Height',
              controller: _heightController,
              suffix: 'cm',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Height is required';
                }
                final height = double.tryParse(value!);
                if (height == null || height < 100 || height > 250) {
                  return 'Please enter a valid height (100-250 cm)';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: 'Weight',
              controller: _weightController,
              suffix: 'kg',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Weight is required';
                }
                final weight = double.tryParse(value!);
                if (weight == null || weight < 30 || weight > 300) {
                  return 'Please enter a valid weight (30-300 kg)';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: 'Fitness Goals',
              controller: _goalsController,
              suffix: '',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Fitness goals are required';
                }
                return null;
              },
            ),
            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          // Reset controllers to original values
                          _nameController.text = widget.userInfo['name'] ?? '';
                          _ageController.text =
                              widget.userInfo['age']?.toString() ?? '';
                          _heightController.text =
                              widget.userInfo['height']?.toString() ?? '';
                          _weightController.text =
                              widget.userInfo['weight']?.toString() ?? '';
                          _goalsController.text =
                              widget.userInfo['goals'] ?? '';
                        });
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
