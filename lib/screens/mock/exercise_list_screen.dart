import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/mock/exercise_item_screen.dart';
import 'package:workout/screens/mock/model.dart';
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExercisesModel(),
      child: Builder(
        builder: (context) {
          final exercises = context.watch<ExercisesModel>().exercises;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Exercises"),
              centerTitle: true,
            ),
            body: ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return _ExercisesListItem(exercise: exercises[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExercisesListItem extends StatelessWidget {
  final Exercise exercise;

  const _ExercisesListItem({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/mock_data/gif/${exercise.imageFileName}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(exercise.title),
        leading: Image.asset(imagePath, width: 100),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return ExerciseItemScreen(
                  exercise: exercise,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
