class PhotoEntry {
  final String id;
  final String imagePath;
  final DateTime date;
  final String type;
  final double? weight;

  PhotoEntry({
    required this.id,
    required this.imagePath,
    required this.date,
    required this.type,
    this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
      'type': type,
      'weight': weight,
    };
  }
  
  static PhotoEntry fromMap(Map<String, dynamic> map) {
    return PhotoEntry(
      id: map['id'],
      imagePath: map['imagePath'],
      date: DateTime.parse(map['date']),
      type: map['type'],
      weight: map['weight'],
    );
  }
}