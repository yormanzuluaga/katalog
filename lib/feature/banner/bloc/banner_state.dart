part of 'banner_bloc.dart';

class BannerState extends Equatable {
  const BannerState({
    this.banners,
    this.isLoading = false,
    this.message,
  });

  final List<BannerModel>? banners;
  final bool isLoading;
  final String? message;

  BannerState copyWith({
    List<BannerModel>? banners,
    bool? isLoading,
    String? message,
  }) {
    return BannerState(
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }

  @override
  List<Object?> get props => [banners, isLoading, message];
}
