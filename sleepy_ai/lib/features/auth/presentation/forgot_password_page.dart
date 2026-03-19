import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_bloc.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_event.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_state.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            ForgotPasswordRequested(email: _emailController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          Get.snackbar(
            'emailSent'.tr,
            'resetEmailSent'.tr,
            backgroundColor: AppColors.success.withAlpha(220),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(AppSizes.md),
            borderRadius: AppSizes.radiusMd,
            duration: const Duration(seconds: 4),
          );
          Get.back();
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
            child: Padding(
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
                  const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primaryLight,
                    size: 52,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'resetPassword'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'resetPasswordSub'.tr,
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
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onSendPressed(),
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
                        const SizedBox(height: AppSizes.xl),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GradientButton(
                              label: 'send'.tr,
                              onPressed: _onSendPressed,
                              isLoading: state is AuthLoading,
                              icon: Icons.send_rounded,
                            );
                          },
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
