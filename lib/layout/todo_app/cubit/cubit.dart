import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mos/layout/todo_app/cubit/states.dart';
import 'package:mos/modules/todo_app/archived_tasks/archived_tasks.dart';
import 'package:mos/modules/todo_app/done_tasks/done_tasks.dart';
import 'package:mos/modules/todo_app/new_tasks/new_tasks.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex=0;
  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  bool isBottomCheetShown=false;
  IconData fabIcon=Icons.edit;

  List<Widget> screens=[
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> appTitle=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('create database');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){print('database created');}).catchError((e){print(e.toString());});
      },
      onOpen: (database)
      {
        print('Database Opened');
        getDataFromDatabase(database);
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });

  }

  Future insertToDatabase(@required String title,@required String date,@required String time) async
  {
    return await database.transaction((txn)
    async {
      txn.rawInsert
        ('INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","done")')
          .then((value)
        {
        print('$value Successfully inserted');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

        }
        ).catchError((e){print('Error while Inserting${e.toString()}');});
    }
    );

  }

  void getDataFromDatabase(database)
  {
    newTasks =[];
    archivedTasks =[];
    doneTasks =[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks')..then((value)
    {

      value.forEach((element) {
        if(element['status']== 'done')
          newTasks.add(element);
        else if(element['status']== 'Done Tasks')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({required String status,required int id})async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({required int id})async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomCheetShown = isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }


}