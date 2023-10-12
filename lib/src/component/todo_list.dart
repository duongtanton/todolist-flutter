import 'package:flutter/material.dart';
import 'package:todolist/src/component/todo_item.dart';
import 'package:todolist/src/model/todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todoItems,
    required this.onChangeCheck,
  });
  final List<TodoItemDTO> todoItems;
  final Function onChangeCheck;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: todoItems
              .map((todoItem) => TodoItem(
                    todoItem: todoItem,
                    onCheckChange: onChangeCheck,
                  ))
              .toList()),
    );
  }
}
