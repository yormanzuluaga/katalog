part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.message,
  });

  final bool isLoading;
  final String? message;

  ProfileState copyWith({
    bool? isLoading,
    String? message,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, message];
}
