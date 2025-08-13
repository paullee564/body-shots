class AppConstants{
  static const String appName = "bodyShots";

  //Database
  static const String databaseName = "bodyshots.db";
  static const int databaseVersion = 1;

  //Tables
  static const String weightTable = "weights";
  static const String photosTable = "photos";

  //Photo types
  static const List<String> photoTypes = [
    "Front",
    "Back",
    "Side"
  ];
  //Weight units
  static const List<String> weightUnits = [
    "kg",
    "lbs"
  ];
}