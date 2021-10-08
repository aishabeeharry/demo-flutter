class Expense {
  final int id;
  final String? merchantName;
  final String? merchantAddress;
  final String country;
  final String date;
  final double tax;

  Expense({
    required this.id,
    this.merchantName,
    this.merchantAddress,
    required this.country,
    required this.date,
    required this.tax,
  });

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        merchantName = json['merchantName'] ?? null,
        merchantAddress = json['merchantAddress'],
        country = json['country'],
        date = json['date'],
        tax = double.parse(json['tax']);
}
