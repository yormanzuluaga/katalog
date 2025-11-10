part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final AddressUserModel address;

  const AddAddress({
    required this.address,
  });

  @override
  List<Object> get props => [address];
}

class CreateAddress extends AddressEvent {
  final AddressUserModel address;

  const CreateAddress({
    required this.address,
  });

  @override
  List<Object> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final String id;
  final AddressUserModel address;

  const UpdateAddress({
    required this.id,
    required this.address,
  });

  @override
  List<Object> get props => [id, address];
}

class DeleteAddress extends AddressEvent {
  final String id;

  const DeleteAddress({required this.id});

  @override
  List<Object> get props => [id];
}

class SelectAddress extends AddressEvent {
  final Address address;

  const SelectAddress({required this.address});

  @override
  List<Object> get props => [address];
}
