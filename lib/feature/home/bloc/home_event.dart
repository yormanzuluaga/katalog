part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class Paginator extends HomeEvent {
  const Paginator({
    required this.index,
  });
  final int index;
}
