// ignore_for_file: public_member_api_docs

enum TimeOptions {
  ///
  doceHoras(title: '12 horas', value: '12'),

  ///
  dosDias(title: '2 días', value: '48'),

  ///
  unaSemana(title: '1 semana', value: '168'),

  ///
  unMes(title: '1 mes', value: '720'),

  ///
  tresMeses(title: '3 meses', value: '2160');

  const TimeOptions({
    required this.value,
    required this.title,
  });

  ///
  final String value;

  ///
  final String title;
}

///
enum DocumentTypes {
  ///
  dni(title: 'DNI', value: 'DU'),

  ///
  pasaporte(title: 'Pasaporte', value: 'PA'),

  ///
  lc(title: 'LC', value: 'LC'),

  ///
  le(title: 'LE', value: 'LE');

  const DocumentTypes({
    required this.value,
    required this.title,
  });

  ///
  final String value;

  ///
  final String title;

  @override
  String toString() {
    return title;
  }
}

/// Enum for reufnd request
enum DocumentTypesRefund {
  ///
  dni(title: 'DNI', value: 'DNI'),

  ///
  pasaporte(title: 'Pasaporte', value: 'PasP'),

  ///
  lc(title: 'LC', value: 'LC'),

  ///
  le(title: 'LE', value: 'LE'),

  ///
  cuit(title: 'CUIT', value: 'CUIT'),

  ///
  cuil(title: 'CUIL', value: 'CUIL');

  const DocumentTypesRefund({
    required this.value,
    required this.title,
  });

  ///
  final String value;

  ///
  final String title;

  @override
  String toString() {
    return title;
  }
}

///
enum FilterType {
  ///
  shift,

  ///
  booklet
}

enum QualtricsDocument {
  dni,
  contra,
  inte,
  plan,
  dispo,
}
