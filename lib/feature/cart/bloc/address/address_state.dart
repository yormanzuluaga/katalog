part of 'address_bloc.dart';

class AddressState extends Equatable {
  const AddressState({
    this.addressModel,
    this.selectedAddress,
    this.isLoading = false,
    this.errorMessage,
  });

  final AddressModel? addressModel;
  final Address? selectedAddress;
  final bool isLoading;
  final String? errorMessage;

  AddressState copyWith({
    AddressModel? addressModel,
    Address? selectedAddress,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedAddress = false,
  }) {
    return AddressState(
      addressModel: addressModel ?? this.addressModel,
      selectedAddress: clearSelectedAddress ? null : (selectedAddress ?? this.selectedAddress),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        addressModel,
        selectedAddress,
        isLoading,
        errorMessage,
      ];
}
