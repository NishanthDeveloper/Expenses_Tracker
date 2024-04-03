import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String categoryId;
  final String name;
  final int totalExpenses;
  final String icon;
  final String color;

  const UserData({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'name': name,
        'totalExpenses': totalExpenses,
        "icon": icon,
        "color": color,
      };
}
