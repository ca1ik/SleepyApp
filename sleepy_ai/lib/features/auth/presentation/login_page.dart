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

/// Giriş ekranı — mor gradient, e-posta/şifre formu.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginWithEmailRequested(
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
            'error'.tr,
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
                  const SizedBox(height: AppSizes.xxl),
                  // Logo
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(100),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Text(
                    'welcomeBack'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'welcomeBackSub'.tr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.fontMd,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                        // Şifre
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLoginPressed(),
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
                            if (value.length < 6) {
                              return 'passwordMin6'.tr;
                            }
                            return null;
                          },
                        ),
                        // Şifremi unuttum
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Get.toNamed(AppStrings.routeForgotPassword),
                            child: Text('forgotPasswordQ'.tr),
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        // Giriş butonu
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GradientButton(
                              label: 'loginBtn'.tr,
                              onPressed: _onLoginPressed,
                              isLoading: state is AuthLoading,
                              icon: Icons.login_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: AppSizes.lg),
                        // Ayırıcı
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                              ),
                              child: Text(
                                'or'.tr,
                                style:
                                    const TextStyle(color: AppColors.textMuted),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.lg),
                        // Kayıt ol linki
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'noAccount'.tr,
                              style: const TextStyle(
                                  color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Get.toNamed(AppStrings.routeRegister),
                              child: Text(
                                'signUpBtn'.tr,
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
