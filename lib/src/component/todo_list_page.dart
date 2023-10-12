import 'package:flutter/material.dart';
import 'package:todolist/src/component/todo_item.dart';
import 'package:todolist/src/model/todo_item.dart';
import 'package:todolist/src/component/todo_list.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _TodoListPage();
}

class _TodoListPage extends State<TodoListPage> {
  late List<TodoItemDTO> _todoItems;
  late FocusNode _focusInput;
  late Filter _filter;
  late Status status;
  @override
  void initState() {
    super.initState();
    _todoItems = [];
    _focusInput = FocusNode();
    _filter = Filter.all;
    status = Status.active;
  }

  final TextEditingController _controller = TextEditingController();
  void _onPressAll() {
    setState(() {
      _filter = Filter.all;
      _todoItems = TodoItemDTO.store;
    });
  }

  void _onPressActive() {
    setState(() {
      _todoItems = TodoItemDTO.store
          .where((todoItem) => todoItem.status == Status.active)
          .toList();
      _filter = Filter.active;
    });
  }

  void _onSubmit(value) {
    if (value == "") {
      setState(() {
        _focusInput.nextFocus();
      });
      return;
    }
    setState(() {
      TodoItemDTO.store.insert(
          0,
          TodoItemDTO(
              DateTime.now().toString(), value, status, DateTime.now()));
      _controller.value = const TextEditingValue(text: "");
      _focusInput.nextFocus();
      _todoItems = TodoItemDTO.store;
    });
  }

  void _onPressCompleted() {
    setState(() {
      _todoItems = TodoItemDTO.store
          .where((todoItem) => todoItem.status == Status.completed)
          .toList();
      _filter = Filter.completed;
    });
  }

  void _onPressClearCompleted() {
    setState(() {
      TodoItemDTO.store = TodoItemDTO.store
          .where((todoItem) => todoItem.status != Status.completed)
          .toList();
      _todoItems = TodoItemDTO.store.where((todoItem) {
        if (_filter == Filter.completed) {
          return todoItem.status == Status.completed;
        } else {
          return todoItem.status == Status.active;
        }
      }).toList();
    });
  }

  void _onChangeCheck(String id, bool checked) {
    setState(() {
      int todoItemIndex =
          _todoItems.indexWhere((todoItem) => todoItem.id == id);
      TodoItemDTO.store[todoItemIndex].status =
          checked ? Status.completed : Status.active;
      _todoItems = TodoItemDTO.store;
    });
  }

  void _onChangeStatus(checked) {
    setState(() {
      status = checked ? Status.completed : Status.active;
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemLeftCount = _todoItems.fold(0, (value, element) {
      if (element.status == Status.active) {
        value++;
      }
      return value;
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              children: <Widget>[
                Text(
                  'todos',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextField(
                  onSubmitted: _onSubmit,
                  controller: _controller,
                  decoration: InputDecoration(
                      suffixIcon: Checkbox(
                          value: status == Status.completed,
                          onChanged: _onChangeStatus),
                      hintText: status == Status.active
                          ? 'What need to be done?'
                          : "What was to be done?",
                      border: const OutlineInputBorder()),
                  focusNode: _focusInput,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 2, right: 2),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: _filter == Filter.all
                                  ? Border.all(
                                      color: const Color.fromARGB(150, 0, 0, 0))
                                  : null),
                          child: GestureDetector(
                            onTap: _onPressAll,
                            child: const Text(
                              "All",
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2, right: 2),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: _filter == Filter.active
                                  ? Border.all(
                                      color: const Color.fromARGB(150, 0, 0, 0))
                                  : null),
                          child: GestureDetector(
                            onTap: _onPressActive,
                            child: const Text(
                              "Active",
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2, right: 2),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: _filter == Filter.completed
                                  ? Border.all(
                                      color: const Color.fromARGB(150, 0, 0, 0))
                                  : null),
                          child: GestureDetector(
                            onTap: _onPressCompleted,
                            child: const Text(
                              "Completed",
                            ),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: TodoList(
                      todoItems: _todoItems, onChangeCheck: _onChangeCheck),
                ),
                GestureDetector(
                  onTap: _onPressClearCompleted,
                  child: const Text("Clear completed"),
                ),
                Text('$itemLeftCount item left')
              ],
            ),
          ))
        ]));
  }
}
