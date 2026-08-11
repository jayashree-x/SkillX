import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../application/profile_controller.dart';
import '../domain/profile.dart';

/// Edit identity: name, bio, photo (PROF-08).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Profile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final _name = TextEditingController(text: widget.profile.name);
  late final _bio = TextEditingController(text: widget.profile.bio ?? '');
  Uint8List? _photoBytes;

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (mounted) setState(() => _photoBytes = bytes);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      return;
    }
    final ok = await ref.read(profileControllerProvider.notifier).saveIdentity(
          name: _name.text.trim(),
          bio: _bio.text.trim(),
          photoBytes: _photoBytes,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                children: [
                  _photoBytes != null
                      ? CircleAvatar(
                          radius: 44, backgroundImage: MemoryImage(_photoBytes!))
                      : UserAvatar(
                          name: widget.profile.name,
                          photoUrl: widget.profile.photoUrl,
                          radius: 44,
                        ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Full name',
            controller: _name,
            textInputAction: TextInputAction.next,
          ),
          const Text(
            'Bio',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _bio,
            maxLines: 4,
            maxLength: 240,
            decoration: const InputDecoration(
              hintText: 'A short line about what you teach and learn…',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: 'Save', loading: busy, onPressed: _save),
        ],
      ),
    );
  }
}
