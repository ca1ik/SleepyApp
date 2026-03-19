import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_bloc.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_event.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_state.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterWithEmailRequested(
              displayName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Get.offAllNamed(AppStrings.routeDashboard);
        } else if (state is AuthError) {
          Get.snackbar(
            'registerError'.tr,
            state.message,
            backgroundColor: AppColors.error.withAlpha(220),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(AppSizes.md),
            borderRadius: AppSizes.radiusMd,
          );
        }
      },
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePaddingH,
                vertical: AppSizes.pagePaddingV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Geri butonu
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'createAccount'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'startJourney'.tr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.fontMd,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Ad soyad
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'fullNameLabel'.tr,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'fullNameRequired'.tr;
                            }
                            if (value.trim().length < 2) {
                              return 'fullNameMin'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.md),
                        // E-posta
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'emailLabel'.tr,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'emailRequired'.tr;
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return 'emailInvalid'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.md),
                        // Sifre
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'passwordLabel'.tr,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'passwordRequired'.tr;
                            }
                            if (value.length < 8) {
                              return 'passwordMin8'.tr;
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'passwordUppercase'.tr;
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'passwordDigit'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.md),
                        // Sifre tekrar
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onRegisterPressed(),
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'confirmPasswordLabel'.tr,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'passwordsMismatch'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.xl),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GradientButton(
                              label: 'registerBtn'.tr,
                              onPressed: _onRegisterPressed,
                              isLoading: state is AuthLoading,
                              icon: Icons.person_add_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: AppSizes.lg),
                        // Giris yap linki
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'haveAccount'.tr,
                              style: const TextStyle(
                                  color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                'signInBtn'.tr,
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
