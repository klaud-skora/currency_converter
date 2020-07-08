import '../models/currency.dart';

extension StatusExtension on Status {
  static final texts = {
    Status.defaultStatus: '',
    Status.noData: 'No Internet! Data is not available to get.',
    Status.oldData: 'No Internet! Data may not be valid.',
    Status.newData: 'You successfully fetched data.',
  };

  String get text => texts[this];
}