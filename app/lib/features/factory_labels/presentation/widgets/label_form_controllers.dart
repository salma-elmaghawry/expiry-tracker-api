import 'package:flutter/widgets.dart';

/// All text fields of the label form in one place, so they are created and disposed together.
class LabelFormControllers {
  final name = TextEditingController();
  final barcode = TextEditingController();
  final boxes = TextEditingController();
  final perBox = TextEditingController();
  final lot = TextEditingController();
  final cost = TextEditingController();
  final count = TextEditingController();

  List<TextEditingController> get all => [
    name,
    barcode,
    boxes,
    perBox,
    lot,
    cost,
    count,
  ];

  /// One listenable that fires when ANY field changes (like Rx's merge).
  Listenable get anyChange => Listenable.merge(all);

  void dispose() {
    for (final controller in all) {
      controller.dispose();
    }
  }
}
