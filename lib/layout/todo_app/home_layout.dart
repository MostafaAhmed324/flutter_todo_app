import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:mos/shared/componantes/componantes.dart';
import 'package:mos/shared/componantes/constance.dart';
import 'package:mos/layout/todo_app/cubit/cubit.dart';
import 'package:mos/layout/todo_app/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloc/bloc.dart';


class HomeLayout extends StatelessWidget {

  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var statusController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context)

  {
    return BlocProvider(
      create: (context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('${cubit.appTitle[cubit.currentIndex]}',),
            ),
            body: Conditional.single(
                context: context,
                conditionBuilder: (context) => state is! AppGetDatabaseLoadingState,
                widgetBuilder: (context) => cubit.screens[cubit.currentIndex],
                fallbackBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
            ) ,
            floatingActionButton: FloatingActionButton(
              child: Icon(
                cubit.fabIcon,
              ),
              onPressed: ()
              {
                if(cubit.isBottomCheetShown)
                {
                  cubit.insertToDatabase(titleController.text, dateController.text, timeController.text);
                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet((context)
                  {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Container(
                          color: Colors.grey[300],

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                textType: TextInputType.text,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                }
                                ,
                                label: 'title',
                                prefix: Icons.title,),
                              SizedBox(height: 5.0,),
                              defaultFormField(
                                controller: dateController,
                                textType: TextInputType.datetime,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                }
                                ,
                                label: 'Date',
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-06-18')).then((value)
                                  {
                                    dateController.text= DateFormat.yMMMd().format(value!);
                                  }
                                  );
                                },
                                prefix: Icons.calendar_today,),
                              SizedBox(height: 5.0,),
                              defaultFormField(
                                controller: timeController,
                                textType: TextInputType.datetime,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                }
                                ,
                                label: 'Time',
                                onTap: ()
                                {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value)
                                  {
                                    timeController.text=value!.format(context).toString();
                                  }
                                  );
                                },
                                prefix: Icons.watch,),
                              SizedBox(height: 5.0,),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  }
                  );
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }

              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              items:
              [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archieved',
                ),
              ],
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index)
              {
                AppCubit.get(context).changeIndex(index);
              },
            ),
          );
        },
        listener: (context, state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }

        },
      ),
    );
  }


}


