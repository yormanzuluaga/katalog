part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    this.mobile,
  });

  final String firstName;
  final String lastName;
  final String? mobile;

  @override
  List<Object?> get props => [firstName, lastName, mobile];
}
