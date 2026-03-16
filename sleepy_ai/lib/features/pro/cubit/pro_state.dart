import 'package:equatable/equatable.dart';

enum ProStatus { unknown, checking, active, inactive, error }

class ProState extends Equatable {
  const ProState({
    this.status = ProStatus.unknown,
    this.isPro = false,
    this.monthlyPrice = '₺99,99',
    this.yearlyPrice = '₺799,99',
    this.isPurchasing = false,
    this.error,
  });

  final ProStatus status;
  final bool isPro;
  final String monthlyPrice;
  final String yearlyPrice;
  final bool isPurchasing;
  final String? error;

  ProState copyWith({
    ProStatus? status,
    bool? isPro,
    String? monthlyPrice,
    String? yearlyPrice,
    bool? isPurchasing,
    String? error,
  }) {
    return ProState(
      status: status ?? this.status,
      isPro: isPro ?? this.isPro,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isPro,
    monthlyPrice,
    yearlyPrice,
    isPurchasing,
    error,
  ];
}
