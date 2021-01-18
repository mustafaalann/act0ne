import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  int picNumber = 0;
  File _imageFile;

  final imagePicker = ImagePicker();
  PickedFile pickedFile;

  Future getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print("Your Photo sent");
        uploadImageToFirebase();
      } else {
        print("Something went wrong.");
      }
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('TaskPhotos/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => {
          if (picNumber == 1)
            {
              FirebaseFirestore.instance
                  .collection("Tasks")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update({
                "task1_image": "TaskPhotos/$fileName",
              }),
            }
          else if (picNumber == 2)
            {
              FirebaseFirestore.instance
                  .collection("Tasks")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update({
                "task2_image": "TaskPhotos/$fileName",
              })
            }
          else if (picNumber == 3)
            {
              FirebaseFirestore.instance
                  .collection("Tasks")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update({
                "task3_image": "TaskPhotos/$fileName",
              })
            }
        });
  }

/*
  Random random = Random();

  List<Task> dailyTasksList = [
    Task.withdailyTasks("Give cup of food"),
    Task.withdailyTasks("Give some love"),
    Task.withdailyTasks("Play with animals"),
  ];

  List<Task> weeklyTasksList = [
    Task.withweeklyTasks("Visit animal shelter"),
    Task.withweeklyTasks("Make goods for animals"),
    Task.withweeklyTasks("Visit animal shelter"),
    Task.withweeklyTasks("Watch film about animals"),
  ];

  List<Task> monthlyTasksList = [
    Task.withmonthlyTasks("Donate the animal foundation "),
    Task.withmonthlyTasks("Construct a animal shelter"),
    Task.withmonthlyTasks("Adopt a animal"),
  ];
*/

/*
  int _counter = 10;
  Timer _timer;

  void _startTimer() {
    _counter =  TimeOfDay.hoursPerDay;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Tasks')
              .doc('Q8elnpjjwODUNKwp3uu6')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            var taskData = snapshot.data;

            return ListView(children: [
              Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Daily Task",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadiusDirectional.circular(6.0),
                          shape: BoxShape.rectangle),
                      height: 50,
                      width: 275,
                      padding: EdgeInsets.all(5.00),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(6.0),
                            shape: BoxShape.rectangle),
                        height: 50,
                        width: 275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                  taskData["task1"],
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        picNumber = 1;
                      });
                      _getTask1();
                      getImage();
                    },
                    child: Icon(Icons.camera_alt),
                  ),

                  //(_counter > 0)
                  //  ? Text('')
                  /* Text(
                'Lets try to new task',
                style: TextStyle(color: Colors.amber),

              ),
              */
                  /* RaisedButton(
                onPressed: () => _startTimer(),
                child: Text("You have 24 hours to complete this task"),
              ),*/
                  /*Text(
                '$_counter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),*/

                  SizedBox(width: 0, height: 100.0),
                  Text(
                    "Weekly Task",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadiusDirectional.circular(6.0),
                          shape: BoxShape.rectangle),
                      height: 50,
                      width: 275,
                      padding: EdgeInsets.all(5.00),
                      child: Container(
                        height: 50,
                        width: 275,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(6.0),
                            shape: BoxShape.rectangle),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  taskData["task2"],
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        picNumber = 2;
                      });
                      _getTask2();
                      getImage();
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                  SizedBox(width: 0, height: 100.0),
                  Text(
                    "Monthly Tasks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadiusDirectional.circular(6.0),
                          shape: BoxShape.rectangle),
                      height: 50,
                      width: 275,
                      padding: EdgeInsets.all(5.00),
                      child: Container(
                        height: 50,
                        width: 275,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(6.0),
                            shape: BoxShape.rectangle),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  taskData["task3"],
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        picNumber = 3;
                      });
                      _getTask3();
                      getImage();
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ]);
          }),
    );
  }

  _getTask1() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("Tasks")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        "task1_name": value.data()["task1"],
        "task1_approve": "0",
        "deneme1_token": value.data()["task1_price"]
      });
    });
  }

  _getTask2() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("Tasks")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        "task2_name": value.data()["task2"],
        "task2_approve": "0",
        "deneme2_token": value.data()["task2_price"]
      });
    });
  }

  _getTask3() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("Tasks")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        "task3_name": value.data()["task3"],
        "task3_approve": "0",
        "deneme3_token": value.data()["task3_price"]
      });
    });
  }
}