import 'package:flutter/material.dart';
import 'package:workout/utils/json_manager.dart';

class ExercisesModel extends ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  ExercisesModel() {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    const pathToJson = 'assets/mock_data/data.json';
    final json = await JsonManager.readJson(pathToJson) as List;
    _exercises = json.map((e) => Exercise.fromJson(e)).toList();
    notifyListeners();
  }
}

class Exercise {
  final String title;
  final String description;
  final String imageFileName;

  Exercise.fromJson(Map<String, dynamic> json)
      : title = json["title"] ?? "",
        description = json["description"] ?? "",
        imageFileName = json["gif"] ?? "";
}
