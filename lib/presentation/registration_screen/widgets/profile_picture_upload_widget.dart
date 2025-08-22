import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProfilePictureUploadWidget extends StatefulWidget {
  final Function(XFile?) onImageSelected;
  final XFile? selectedImage;

  const ProfilePictureUploadWidget({
    Key? key,
    required this.onImageSelected,
    this.selectedImage,
  }) : super(key: key);

  @override
  State<ProfilePictureUploadWidget> createState() =>
      _ProfilePictureUploadWidgetState();
}

class _ProfilePictureUploadWidgetState
    extends State<ProfilePictureUploadWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageSelected(photo);
      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(image);
      }
    } catch (e) {
      // Handle error gracefully
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Profile Picture',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    if (_isCameraInitialized) {
                      setState(() {
                        _showCamera = true;
                      });
                    }
                  },
                ),
                _buildSourceOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (_isCameraInitialized && _cameraController != null)
              CameraPreview(_cameraController!)
            else
              Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showCamera = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _capturePhoto,
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera && _isCameraInitialized) {
      return _buildCameraView();
    }

    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: widget.selectedImage != null
            ? ClipOval(
                child: kIsWeb
                    ? Image.network(
                        widget.selectedImage!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : CustomImageWidget(
                        imageUrl: widget.selectedImage!.path,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_a_photo',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Add Photo',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
