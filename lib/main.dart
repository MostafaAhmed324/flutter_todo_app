import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mos/shared/bloc_observer.dart';

import 'layout/todo_app/home_layout.dart';

void main() async {
  BlocOverrides.runZoned(
        () async{
          runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

