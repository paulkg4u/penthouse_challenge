import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PenthouseChallenge());

class API{
  static Future getTodos(){
    return http.get('https://jsonplaceholder.typicode.com/todos');
   }
}

class PenthouseChallenge extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penthouse Challenge',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget{
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList>{
  var todos = new List<Todo>();

  _getTodos(){
   
    API.getTodos().then((response){
      setState((){
        Iterable list = json.decode(response.body);
        var myList = list.where((i) => i['userId'] == 1);
        todos = myList.map((model) => Todo.fromJson(model)).toList();
        // todos = list.map((model) => Todo.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context,i){
          final index = i;
          return ListTile(
            // leading: Text(todos[index].userId.toString()),
            title: Text(todos[index].title, style: TextStyle(decoration: todos[index].completed?TextDecoration.lineThrough:null),),
            trailing: Checkbox(
              value: todos[index].completed,
              activeColor: Colors.red,
              onChanged: (val){
                setState(() {
                  todos[index].completed = val;  
                });
              },
            )
          );
        },
      ),
      
    );
  }
}



class Todo {
  int userId;
  int id;
  String title;
  bool completed;

  Todo(int userId, int id, String title, bool completed){
    this.userId = userId;
    this.id = id;
    this.title = title;
    this.completed = completed;
  }

  Todo.fromJson(Map json)
    :completed = json['completed'],
      id= json['id'],
      userId = json['userId'],
      title = json['title'];
}

