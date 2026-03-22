import 'package:equatable/equatable.dart';

enum ProStatus { unknown, checking, active, inactive, error }

class ProState extends Equatable {
  const ProState({
    this.status = ProStatus.unknown,
    this.isPro = false,
    this.isNoAds = false,
    this.monthlyPrice = '₺99,99',
    this.yearlyPrice = '₺799,99',
    this.noAdsMonthlyPrice = '₺49,99',
    this.isPurchasing = false,
    this.error,
  });

  final ProStatus status;
  final bool isPro;
  final bool isNoAds;
  final String monthlyPrice;
  final String yearlyPrice;
  final String noAdsMonthlyPrice;
  final bool isPurchasing;
  final String? error;

  /// PRO kullanıcılar otomatik olarak reklamsız deneyimden yararlanır
  bool get shouldShowAds => !isPro && !isNoAds;

  ProState copyWith({
    ProStatus? status,
    bool? isPro,
    bool? isNoAds,
    String? monthlyPrice,
    String? yearlyPrice,
    String? noAdsMonthlyPrice,
    bool? isPurchasing,
    String? error,
  }) {
    return ProState(
      status: status ?? this.status,
      isPro: isPro ?? this.isPro,
      isNoAds: isNoAds ?? this.isNoAds,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      noAdsMonthlyPrice: noAdsMonthlyPrice ?? this.noAdsMonthlyPrice,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPro,
        isNoAds,
        monthlyPrice,
        yearlyPrice,
        noAdsMonthlyPrice,
        isPurchasing,
        error,
      ];
}
