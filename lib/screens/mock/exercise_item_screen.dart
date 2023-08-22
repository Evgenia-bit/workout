import 'package:flutter/material.dart';

import 'package:workout/screens/mock/model.dart';

class ExerciseItemScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseItemScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/mock_data/gif/${exercise.imageFileName}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(exercise.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Image.asset(imagePath),
            const SizedBox(height: 18.0),
            Text(exercise.description),
          ],
        ),
      ),
    );
  }
}
