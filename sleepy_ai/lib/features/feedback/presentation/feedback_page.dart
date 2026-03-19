import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/feedback/cubit/feedback_cubit.dart';
import 'package:sleepy_ai/features/feedback/cubit/feedback_state.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackCubit(),
      child: const _FeedbackView(),
    );
  }
}

class _FeedbackView extends StatefulWidget {
  const _FeedbackView();

  @override
  State<_FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<_FeedbackView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.submitted) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              backgroundColor: AppColors.backgroundCard,
              title: Text(
                'thankYou'.tr,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              content: Text(
                'feedbackSent'.tr,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // back to dashboard
                  },
                  child: Text(
                    'ok'.tr,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == FeedbackStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'anErrorOccurred'.tr),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: Text(
            'feedback'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: BlocBuilder<FeedbackCubit, FeedbackState>(
            builder: (context, state) {
              final cubit = context.read<FeedbackCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: AppSizes.lg),
                        const Text('💬', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          'howWasApp'.tr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'feedbackHelper'.tr,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSizes.xl),
                      ],
                    ),
                  ),

                  // Star rating
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'yourRating'.tr,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.fontLg,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final starIndex = i + 1;
                            return GestureDetector(
                              onTap: () => cubit.setRating(starIndex),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Icon(
                                  starIndex <= state.rating
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: AppColors.accentGold,
                                  size: 42,
                                ),
                              ),
                            );
                          }),
                        ),
                        if (state.rating > 0) ...[
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            _ratingLabel(state.rating),
                            style: const TextStyle(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  // Message
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _controller,
                      onChanged: cubit.setMessage,
                      maxLines: 5,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'feedbackPlaceholder'.tr,
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.all(AppSizes.md),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Submit
                  GradientButton(
                    label: state.status == FeedbackStatus.loading
                        ? 'submitting'.tr
                        : 'submit'.tr,
                    onPressed: state.canSubmit &&
                            state.status != FeedbackStatus.loading
                        ? cubit.submit
                        : null,
                    isLoading: state.status == FeedbackStatus.loading,
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'ratingVeryBad'.tr;
      case 2:
        return 'ratingBad'.tr;
      case 3:
        return 'ratingAverage'.tr;
      case 4:
        return 'ratingGood'.tr;
      case 5:
        return 'ratingExcellent'.tr;
      default:
        return '';
    }
  }
}
