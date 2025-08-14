import 'package:flutter/foundation.dart';
import '../models/weight_entry.dart';
import '../services/database_service.dart';

class WeightProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<WeightEntry> _weights = [];
  bool _isLoading = false;
  
  List<WeightEntry> get weights => _weights;
  bool get isLoading => _isLoading;
  
  double? get currentWeight {
    if (_weights.isEmpty) return null;
    return _weights.first.weight;
  }
  
  double? get weightChange {
    if (_weights.length < 2) return null;
    return _weights.first.weight - _weights.last.weight;
  }
  
  Future<void> loadWeights() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _weights = await _db.getAllWeights();
    } catch (e) {
      debugPrint('Error loading weights: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> addWeight(double weight, DateTime date, String? notes) async {
    final entry = WeightEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      weight: weight,
      date: date,
      notes: notes,
    );
    
    try {
      await _db.insertWeight(entry);
      await loadWeights(); // Reload to get updated list
    } catch (e) {
      debugPrint('Error adding weight: $e');
    }
  }
  
  Future<void> deleteWeight(String id) async {
    try {
      await _db.deleteWeight(id);
      await loadWeights();
    } catch (e) {
      debugPrint('Error deleting weight: $e');
    }
  }
}