import 'package:state_management/models/expense.dart';

class Trip {
  final int id;
  final String name;
  final String date;
  final List<Expense>? expenses;

  Trip({
    required this.id,
    required this.name,
    required this.date,
    this.expenses,
  });

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['tripId'],
        name = json['tripName'],
        date = json['date'],
        expenses = (json['expenses'] as List)
            .map((item) => Expense.fromJson(item))
            .toList();
}
