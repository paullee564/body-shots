import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/weight_entry.dart';
import '../models/photo_entry.dart';
import '../utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Create weights table
    await db.execute('''
      CREATE TABLE ${AppConstants.weightTable} (
        id TEXT PRIMARY KEY,
        weight REAL NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');
    
    // Create photos table
    await db.execute('''
      CREATE TABLE ${AppConstants.photosTable} (
        id TEXT PRIMARY KEY,
        imagePath TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        weight REAL
      )
    ''');
  }
  
  // Weight operations
  Future<void> insertWeight(WeightEntry entry) async {
    final db = await database;
    await db.insert(AppConstants.weightTable, entry.toMap());
  }
  
  Future<List<WeightEntry>> getAllWeights() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.weightTable,
      orderBy: 'date DESC',
    );
    return maps.map((map) => WeightEntry.fromMap(map)).toList();
  }
  
  Future<void> deleteWeight(String id) async {
    final db = await database;
    await db.delete(
      AppConstants.weightTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Photo operations
  Future<void> insertPhoto(PhotoEntry entry) async {
    final db = await database;
    await db.insert(AppConstants.photosTable, entry.toMap());
  }
  
  Future<List<PhotoEntry>> getAllPhotos() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.photosTable,
      orderBy: 'date DESC',
    );
    return maps.map((map) => PhotoEntry.fromMap(map)).toList();
  }
  
  Future<List<PhotoEntry>> getPhotosByType(String type) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.photosTable,
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    return maps.map((map) => PhotoEntry.fromMap(map)).toList();
  }
}