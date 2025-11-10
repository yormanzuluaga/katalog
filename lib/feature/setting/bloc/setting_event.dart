part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class SignOutSettingEvent extends SettingEvent {
  const SignOutSettingEvent();
  @override
  List<Object> get props => [];
}
