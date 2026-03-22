import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';
import 'package:sleepy_ai/features/pro/data/pro_repository.dart';

class ProCubit extends Cubit<ProState> {
  ProCubit(this._repository) : super(const ProState());

  final ProRepository _repository;

  Future<void> checkProStatus() async {
    emit(state.copyWith(status: ProStatus.checking));
    try {
      final isPro = await _repository.checkProStatus();
      final isNoAds = await _repository.checkNoAdsStatus();
      emit(
        state.copyWith(
          status: isPro ? ProStatus.active : ProStatus.inactive,
          isPro: isPro,
          isNoAds: isNoAds || isPro,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProStatus.error, error: e.toString()));
    }
  }

  Future<void> purchaseMonthly() async {
    emit(state.copyWith(isPurchasing: true));
    try {
      final success = await _repository.purchaseMonthly();
      emit(
        state.copyWith(
          isPurchasing: false,
          isPro: success,
          isNoAds: success,
          status: success ? ProStatus.active : ProStatus.inactive,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isPurchasing: false,
          status: ProStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> purchaseYearly() async {
    emit(state.copyWith(isPurchasing: true));
    try {
      final success = await _repository.purchaseYearly();
      emit(
        state.copyWith(
          isPurchasing: false,
          isPro: success,
          isNoAds: success,
          status: success ? ProStatus.active : ProStatus.inactive,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isPurchasing: false,
          status: ProStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> purchaseNoAds() async {
    emit(state.copyWith(isPurchasing: true));
    try {
      final success = await _repository.purchaseNoAds();
      emit(
        state.copyWith(
          isPurchasing: false,
          isNoAds: success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isPurchasing: false,
          status: ProStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(isPurchasing: true));
    try {
      await _repository.restorePurchases();
      final isPro = await _repository.checkProStatus();
      final isNoAds = await _repository.checkNoAdsStatus();
      emit(
        state.copyWith(
          isPurchasing: false,
          isPro: isPro,
          isNoAds: isNoAds || isPro,
          status: isPro ? ProStatus.active : ProStatus.inactive,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isPurchasing: false));
    }
  }
}
