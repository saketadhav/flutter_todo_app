import 'package:flutter/material.dart';
import 'package:todo_app_saket/util/dbhelper.dart';
import 'package:todo_app_saket/model/todo.dart';
import 'package:todo_app_saket/screens/todolist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  }

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoList()
    );
  }
}


// Code to insert dummy records:

// List<Todo> todos = List<Todo>();
// DbHelper helper = DbHelper();
// helper.initializeDb().then(
//   (result) => helper.getTodos().then((result) => todos = result));
// DateTime today = DateTime.now();
// Todo newTodo = Todo("Buy water melons", 3, today.toString(), "Perfect round melons.");
// helper.insertTodo(newTodo);