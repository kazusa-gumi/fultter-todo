import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  final String originalTodo;

  EditPage({required this.originalTodo});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.originalTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (text) {
            // No need to call setState here as Flutter
            // automatically updates the TextField
          },
          controller: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(
              "EditPage FloatingActionButton pressed: newTodo = ${_controller.text}");
          Navigator.of(context).pop(_controller.text);
        },
        child: Icon(Icons.done),
      ),
    );
  }
}

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_todoItems[index]),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _navigateToEditPage(context, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add a new task'),
        ),
        body: TextField(
          autofocus: true,
          onSubmitted: (val) {
            _addTodoItem(val);
            // 元のページに戻る機能
            Navigator.pop(context);
          },
          decoration: InputDecoration(
            hintText: 'Enter something to do...',
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      );
    }));
  }

  void _navigateToEditPage(BuildContext context, int index) async {
    String? editedTodo =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditPage(originalTodo: _todoItems[index]);
    }));
    print("_navigateToEditPage: editedTodo = $editedTodo");
    if (editedTodo != null) {
      setState(() => _todoItems[index] = editedTodo);
    }
  }
}
