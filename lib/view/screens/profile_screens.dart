import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_dialog.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../data/model/user_model.dart';
import '../widgets/profile_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController fullName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  bool isArabic = false;

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();

    final userBox = Hive.box<UserModel>('User');
    final user = userBox.get('user');

    if (user != null) {
      fullName.text = user.fullName;
      imageBytes = user.imageBytes;
    }

    final settingsBox = Hive.box('Settings');

    isArabic = settingsBox.get(
      'arabic',
      defaultValue: false,
    );
  }

  @override
  void dispose() {
    fullName.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    final Uint8List bytes = await pickedImage.readAsBytes();

    if (!mounted) return;

    setState(() {
      imageBytes = bytes;
    });
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userBox = Hive.box<UserModel>('User');

    final user = UserModel(
      fullName: fullName.text.trim(),
      imageBytes: imageBytes,
    );

    await userBox.put('user', user);

    if (!mounted) return;

    showLoading(context);

    await Future.delayed(
      const Duration(seconds: 0),
    );

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
    );
  }

  void _toggleTheme() async {
    final isDark =
        AppThemeController.themeMode.value == ThemeMode.dark;

    final newDarkMode = !isDark;

    AppThemeController.setDarkMode(newDarkMode);

    final settingsBox = Hive.box('Settings');

    await settingsBox.put(
      'darkMode',
      newDarkMode,
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Choose Language',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text(
                  '🇺🇸',
                  style: TextStyle(fontSize: 25),
                ),
                title: const Text('English'),
                onTap: () {
                  _changeLanguage(false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text(
                  '🇪🇬',
                  style: TextStyle(fontSize: 25),
                ),
                title: const Text('العربية'),
                onTap: () {
                  _changeLanguage(true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(bool arabic) async {
    final settingsBox = Hive.box('Settings');

    await settingsBox.put(
      'arabic',
      arabic,
    );

    if (mounted) {
      setState(() {
        isArabic = arabic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        AppThemeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),

                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 70,
                      ),
                      child: Center(
                        child: ProfileHeader(
                          imageBytes: imageBytes,
                          onPickImage: _pickImage,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      right: 35,
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _toggleTheme,
                              icon: Icon(
                                isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                size: 23,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _showLanguageDialog,
                              icon: const Icon(
                                Icons.language,
                                size: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 42),

                ProfileTextField(
                  controller: fullName,
                  label: isArabic
                      ? 'الاسم بالكامل'
                      : 'Full Name',
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return isArabic
                          ? 'من فضلك أدخل اسمك'
                          : 'Please enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                ProfileButton(
                  onPressed: _saveUser,
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}