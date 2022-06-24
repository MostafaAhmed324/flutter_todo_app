

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mos/layout/todo_app/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required VoidCallback onPressed,
  required String text,
}) => Container(
  width: width,
  height: 40.0,
  child: MaterialButton(
    onPressed: onPressed,
    child: Text(
      '${text.toUpperCase()}',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: background,
  ),
);

Widget defaultFormField(
{
  required TextEditingController controller,
  required TextInputType textType,
  Function(String)? onSubmit,
  VoidCallback? onTap,
  required String? Function(String?) validator,
  required String label,
  required IconData prefix,
  IconButton? suffix,
  bool obscure=false,
  Function(String)? onChange,


}) => TextFormField(
  controller: controller,
  keyboardType: textType,
  decoration: InputDecoration(
    labelText: label,
    suffix: suffix,
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefix),
  ),
  validator: validator,
  onFieldSubmitted: onSubmit,
  obscureText: obscure,
  onTap: onTap,
  onChanged: onChange,
);

Widget buildTaskItem(Map model,context) => Dismissible(
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

            '${model['time']}',

            style: TextStyle(

              fontSize: 20.0,

            ),

          ),

        ),

        SizedBox(width: 10.0,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 20.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  fontSize: 10.0,

                  color: Colors.grey,

                ),

              ),

            ],

          ),
        ),

        SizedBox(width: 10.0,),

        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDatabase(status: 'Done Tasks', id: model['id']);
            },
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
        ),

        SizedBox(width: 10.0,),

        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateDatabase(status: 'Archived Tasks', id: model['id']);
          },
          icon: Icon(
            Icons.archive_outlined,
            color: Colors.grey,
          ),
        ),

      ],

    ),
  ),
  key: Key(model['id'].toString()),
  onDismissed: (dirction)
  {
    AppCubit.get(context).deleteDatabase(id: model['id']);
  },
);


void navigateTo(context , widget) => Navigator.push(
    context,
  MaterialPageRoute(builder: (context) => widget),
);

void navigateAndFinish(context , widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => widget),
    (route){return false;},
);

Widget defaultTextButton({required void Function()? onPressed,required String text}) => TextButton(onPressed: onPressed, child: Text('$text'),);

void showToast({
  required String msg,
  required Color? color,
}) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0
);