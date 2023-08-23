import 'package:flutter/material.dart';

import 'package:workout/screens/mock/model.dart';

class ExerciseItemScreen extends StatelessWidget {
  const ExerciseItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercise = ModalRoute.of(context)!.settings.arguments as Exercise;
    final imagePath = 'assets/mock_data/gif/${exercise.imageFileName}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(exercise.title),
        leading: const BackButton(color: Colors.black),
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
