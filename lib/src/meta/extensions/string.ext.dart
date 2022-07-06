import 'package:at_utils/at_utils.dart';

extension ClearingString on String {
  /// clear method will empty the string
  String clear() {
    return '';
  }

  /// Formats the atSign to valid format
  String? formatAtSign() {
    return AtUtils.formatAtSign(this);
  }
}
