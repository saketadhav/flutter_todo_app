import 'package:flutter/material.dart';
import 'package:todo_app_saket/model/todo.dart';
import 'package:todo_app_saket/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();

final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back To List'
];

const menuSave = 'Save Todo & Back';
const menuDelete = 'Delete Todo';
const menuBack = 'Back To List';

class TodoDetail extends StatefulWidget{

  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
  
}
  
class TodoDetailState extends State{

  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: selectMenuItem,
            itemBuilder: (BuildContext context){
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[ 
          Column(
          children: <Widget>[
          TextField(
            controller: titleController,
            style: textStyle,
            onChanged: (value) => this.updateTitle(),
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child:TextField(
            controller: descriptionController,
            style: textStyle,
            onChanged: (value) => this.updateDescription(),
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
              )
            ),
          )
          ),
          ListTile(
            title: DropdownButton<String>(
            items: _priorities.map((String itemvalue){
              return DropdownMenuItem<String>(
                value: itemvalue,
                child: Text(itemvalue)
              );
            }).toList(),
            style: textStyle,
            value: retrievePriority(todo.priority),
            onChanged: (value) => updatePriority(value),
          ),
          )
        ],
      )
      ],
      ),
      )
    );

  }

  void selectMenuItem(String value) async{
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        Navigator.pop(context, true);
        if(todo.id == null){
          return;
        }
        result = await helper.deleteTodo(todo.id);
        if(result != 0){
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted."),
          );
          showDialog(
            context: context,
            builder: (_) => alertDialog
          );
        }
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save(){
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id != null){
      helper.updateTodo(todo);
    }
    else{
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value){
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      default:
      todo.priority = 3;
    }
    setState(() {
     _priority = value; 
    });
  }

  String retrievePriority(int value){
    return _priorities[value - 1];
  }

  updateTitle(){
    todo.title = titleController.text;
  }

  updateDescription(){
    todo.description = descriptionController.text;
  }

}