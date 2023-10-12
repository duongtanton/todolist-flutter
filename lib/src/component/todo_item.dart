import 'package:flutter/material.dart';
import 'package:todolist/src/model/todo_item.dart';

class TodoItem extends StatelessWidget {
  const TodoItem(
      {super.key, required this.todoItem, required this.onCheckChange});
  final TodoItemDTO todoItem;
  final Function onCheckChange;
  void _onCheckChange(checked) {
    onCheckChange(todoItem.id, checked);
  }

  @override
  Widget build(BuildContext context) {
    var decorationText = todoItem.status == Status.completed
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Color.fromARGB(100, 6, 1, 1),
            overflow: TextOverflow.ellipsis)
        : null;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
        width: 1,
      ))),
      child: Row(
        children: [
          Checkbox(
              onChanged: _onCheckChange,
              value: todoItem.status == Status.completed),
          Flexible(child: Text(todoItem.name, style: decorationText))
        ],
      ),
    );
  }
}
