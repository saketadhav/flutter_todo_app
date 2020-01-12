import 'package:flutter/material.dart';
import 'package:todo_app_saket/model/todo.dart';
import 'package:todo_app_saket/util/dbhelper.dart';
import 'package:todo_app_saket/screens/tododetail.dart';

class TodoList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TodoListState();
  
}
  
class TodoListState extends State{

  DbHelper helper = DbHelper();
  List<Todo> todos = List<Todo>();
  int count = 0;


  @override
  Widget build(BuildContext context) {

    if(todos == null || todos.length == 0){
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToDetail(Todo('', 3, ''));
        },
        tooltip: "Add new todo",
        child: Icon(Icons.add),
      ),
    );

  }

  ListView todoListItems(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColorFroPriority(this.todos[position].priority),
              child: Text(this.todos[position].priority.toString())
            ),
            title: Text(this.todos[position].title.toString()),
            subtitle: Text(this.todos[position].date.toString()),
            onTap: (){
              debugPrint("Tapped on " + this.todos[position].id.toString());
              navigateToDetail(this.todos[position]);
            },
          ),
        );
      },
    );
  }

  void getData(){
    final dbFuture = helper.initializeDb();
    dbFuture.then((result){
      final todosFuture = helper.getTodos();
      todosFuture.then((result){
        List<Todo> todosList = List<Todo>();
        count = result.length;
        for(int i=0; i<count; i++){
          todosList.add(Todo.fromObject(result[i]));
          debugPrint(todosList[i].title);
        }
        setState(() {
          todos = todosList;
          count = count;
        });
        debugPrint("Items : " + count.toString());
      });
    });
  }

  Color getColorFroPriority(int priority){
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    if(result == true){
      getData();
    }
  }

}