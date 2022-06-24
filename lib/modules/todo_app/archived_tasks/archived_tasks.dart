import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mos/layout/todo_app/cubit/cubit.dart';
import 'package:mos/layout/todo_app/cubit/states.dart';
import 'package:mos/shared/componantes/componantes.dart';


class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(AppCubit.get(context).archivedTasks[index],context),
          separatorBuilder: (context, index) => Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 1.0,
          ),
          itemCount: AppCubit.get(context).archivedTasks.length,
        );
      },
    );
  }
}
