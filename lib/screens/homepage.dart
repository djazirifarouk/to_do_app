import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/library.dart';
import 'package:to_do_app/screens/taskpage.dart';
import 'package:to_do_app/screens/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF121212),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/Logo.png',
                          ),
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "Easy Tasks need Easy Way",
                          style: TextStyle(
                            color: Color(0xFFF6F6F6),
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                    child: Material(
                      elevation: 10.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF6F6F6),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {}
                        return NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowGlow();
                            return;
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: 24,
                              bottom: 120,
                            ),
                            dragStartBehavior: DragStartBehavior.start,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(_createRouteTaskPage(
                                          snapshot.data[index]))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 45.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRouteTaskPage(null))
                        .then((value) {
                      setState(() {});
                    });
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
                      Icons.add,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: listLength == 0,
                child: Positioned(
                  bottom: 300.0,
                  right: 100,
                  child: Text(
                    "Add more Tasks...",
                    style: TextStyle(
                      color: Color(0xFFF6F6F6).withOpacity(0.5),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRouteTaskPage(value) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Taskpage(
      task: value,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
