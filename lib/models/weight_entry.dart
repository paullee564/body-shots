class WeightEntry {
  final String id;
  final double weight;
  final DateTime date;
  final String? notes;

  WeightEntry({
    required this.id,
    required this.weight,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

   static WeightEntry fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      weight: map['weight'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}