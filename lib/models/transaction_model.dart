class TransactionModel {
  String? id;
  String? description;
  double? amount;
  DateTime? date;
  String? currencyType;
  String? type;
  String? category; 

  TransactionModel({
    this.id,
    this.description,
    required this.amount,
    required this.date,
    required this.currencyType,
    required this.type,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date?.toIso8601String(),
      'currencyType': currencyType,
      'type': type,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      currencyType: map['currencyType'],
      type: map['type'],
      category: map['category'],
    );
  }
}
