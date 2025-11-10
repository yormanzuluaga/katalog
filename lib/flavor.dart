import 'package:phone_form_field/phone_form_field.dart';

enum FlavorType {
  dev,
  stg,
  prd,
}

class Flavor {
  Flavor._internal();
  static final Flavor _instance = Flavor._internal();
  static Flavor get instance => _instance;

  FlavorType _flavor = FlavorType.dev;
  set setFlavor(FlavorType flavor) => _flavor = flavor;
  FlavorType get value => _flavor;
  bool _isPhysicalDevice = true;
  set setPhysicalDevice(bool value) => _isPhysicalDevice = value;

  bool get isPhysicalDevice {
    switch (value) {
      case FlavorType.dev:
        return _isPhysicalDevice;
      case FlavorType.stg:
        return true;
      case FlavorType.prd:
        return true;
    }
  }

  String get api {
    switch (_flavor) {
      case FlavorType.dev:
        return '';
      case FlavorType.prd:
        return '';
      case FlavorType.stg:
        return '';
    }
  }

  String get dynamicLink {
    switch (_flavor) {
      case FlavorType.dev:
        return '';
      case FlavorType.prd:
        return '';
      case FlavorType.stg:
        return '';
    }
  }

  String get baseUrl {
    return '';
  }

  bool get showChuck {
    switch (_flavor) {
      case FlavorType.dev:
        return true;
      case FlavorType.prd:
        return false;
      case FlavorType.stg:
        return true;
    }
  }

  List<IsoCode> get countries {
    switch (_flavor) {
      case FlavorType.dev:
        return [
          IsoCode.CO,
          IsoCode.MX,
          IsoCode.EC,
          IsoCode.PE,
          IsoCode.AR,
          IsoCode.CR,
        ];
      case FlavorType.stg:
        return [
          IsoCode.CO,
          IsoCode.MX,
          IsoCode.EC,
          IsoCode.PE,
          IsoCode.AR,
          IsoCode.CR,
        ];
      case FlavorType.prd:
        return [
          IsoCode.CO,
        ];
    }
  }
}
