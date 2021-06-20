import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screens/widgets.dart';
import 'package:to_do_app/library.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String _taskTitle = "";
  int _taskId = 0;
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      // Set visibility to true
      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF121212),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFF6F6F6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              // check if the field is not empty
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    listLength += 1;
                                    _taskTitle = value;
                                  });
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Enter task title...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color(0xAAF6F6F6),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF6F6F6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        style: TextStyle(color: Color(0xFFF6F6F6)),
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Enter description for the task...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xAAF6F6F6),
                            fontWeight: FontWeight.normal,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowGlow();
                            return;
                          },
                          child: Expanded(
                            child: ListView.builder(
                              dragStartBehavior: DragStartBehavior.down,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data[index].isDone == 0) {
                                      await _dbHelper.updateTodoIsDone(
                                          snapshot.data[index].id, 1);
                                    } else {
                                      await _dbHelper.updateTodoIsDone(
                                          snapshot.data[index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  onLongPress: () async {
                                    return showDialog(
                                        barrierColor:
                                            Colors.black.withOpacity(0.7),
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Container(
                                              height: 40.0,
                                              width: 30.0,
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await _dbHelper
                                                          .deleteToDo(snapshot
                                                              .data[index].id);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Delete This ToDo",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                        color:
                                                            Color(0xFFE03A76),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Todowidget(
                                    text: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone == 0
                                        ? false
                                        : true,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            child: Icon(
                              Icons.check_box_outline_blank_rounded,
                              color: Color(0xFFEC8374),
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: Color(0xFFF6F6F6)),
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskId != 0) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter a ToDo item...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color(0xAAF6F6F6),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 45.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        listLength -= 1;
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFC22CFC),
                            Color(0xFFE03A76),
                          ],
                          begin: Alignment(0.0, -2.8),
                          end: Alignment(0.0, 1.0),
                        ),
                        color: Color(0xFFe03a76),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(3.0, 3.0),
                              blurRadius: 5,
                              spreadRadius: 1.2),
                        ],
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
