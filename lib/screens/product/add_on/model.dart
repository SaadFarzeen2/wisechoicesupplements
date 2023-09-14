enum AddOnDataType { string, option, listOption }

class AddOnData {
  AddOnDataType type;
  AddOnString? string;
  AddOnOption? option;
  List<AddOnOption>? listOption;

  AddOnData({
    required this.type,
    this.string,
    this.option,
    this.listOption,
  });
}

class AddOnString {
  final String value;
  final int qty;
  final double price;
  final String priceType;
  final double duration;
  final String durationType;

  AddOnString({
    required this.value,
    this.qty = 1,
    required this.price,
    required this.priceType,
    required this.duration,
    required this.durationType,
  });
}

class AddOnOption {
  final int visit;
  final String value;
  final int qty;
  final String? label;
  final double price;
  final String priceType;
  final double duration;
  final String durationType;

  AddOnOption({
    required this.visit,
    required this.value,
    this.qty = 1,
    this.label,
    required this.price,
    required this.priceType,
    required this.duration,
    required this.durationType,
  });
}
