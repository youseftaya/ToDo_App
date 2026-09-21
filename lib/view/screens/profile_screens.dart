import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/app_dialog.dart';
import '../../core/app_routes.dart';
import '../../data/model/user_model.dart';
import '../widgets/custom_text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController fullName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5EDF7),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Color(0xFF1D5C9B),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 2,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1D5C9B),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Create Your Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add Your name and profile picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 42),
                CustomTextFormField(
                  controller: fullName,
                  label: 'Full Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your name';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 28),
                MaterialButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    log(fullName.text);

                    try {
                      showLoading(context);

                      var userBox = Hive.box<UserModel>('User');

                      await userBox.put(
                        'UserKey',
                        UserModel(
                          fullName: fullName.text.trim(),
                        ),
                      );

                      if (!mounted) return;

                      Navigator.of(context).pop();

                      Navigator.of(context).pushNamed(
                        AppRoutes.home,
                      );

                      var getFullName = userBox.get('UserKey');

                      log(getFullName?.fullName ?? 'Null');
                    } catch (error) {
                      if (!mounted) return;

                      Navigator.of(context).pop();

                      showError(
                        context,
                        error.toString(),
                      );
                    }
                  },
                  color: const Color(0xff3F51B5),
                  padding: const EdgeInsets.all(10),
                  minWidth: double.infinity,
                  height: 54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Greate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}