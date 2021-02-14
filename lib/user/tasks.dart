import 'dart:async';
import 'dart:io';
import 'dart:math';

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
  bool task1_time_done = false;
  bool task2_time_done = false;
  bool task3_time_done = false;

  bool task1Done = false;
  bool task2Done = false;
  bool task3Done = false;

  int picNumber = 0;
  File _imageFile;

  final imagePicker = ImagePicker();
  PickedFile pickedFile;

  @override
  void initState() {
    super.initState();
    _getTasksDone();
    _getRandomTask();
  }

  Future getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print('Your Photo sent');
        uploadImageToFirebase();
        _getTasksDone();
      } else {
        print('Something went wrong.');
      }
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('tasks/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => {
          if (picNumber > 0)
            {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update({
                'task' + picNumber.toString() + '_image': 'tasks/$fileName',
              }),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            _getRandomTask();
            var document = snapshot.data;
            return ListView(children: [
              Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Daily Task',
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
                                  document['task1_name'],
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
                    onPressed: task1Done
                        ? null
                        : () {
                            setState(() {
                              picNumber = 1;
                            });
                            _getTask1();
                            getImage();
                          },
                    child: Icon(Icons.camera_alt),
                  ),
                  SizedBox(width: 0, height: 100.0),
                  Text('Weekly Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
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
                                  document['task2_name'],
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
                    onPressed: task2Done
                        ? null
                        : () {
                            setState(() {
                              picNumber = 2;
                            });
                            _getTask2();
                            getImage();
                          },
                    child: Icon(Icons.camera_alt),
                  ),
                  SizedBox(width: 0, height: 100.0),
                  Text('Monthly Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
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
                                Text(document['task3_name'],
                                    style: TextStyle(
                                      fontSize: 17,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: task3Done
                        ? null
                        : () {
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
        .collection('tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task1_name': value.data()['task1'],
        'task1_token': value.data()['task1_price'],
        'task1_sent': true
      });
    });
  }

  _getTask2() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task2_name': value.data()['task2'],
        'task2_token': value.data()['task2_price'],
        'task2_sent': true
      });
    });
  }

  _getTask3() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .doc('Q8elnpjjwODUNKwp3uu6')
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task3_name': value.data()['task3'],
        'task3_token': value.data()['task3_price'],
        'task3_sent': true
      });
    });
  }

  _getTasksDone() async {
    var recordData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    var getValue = recordData.data();
    if (getValue['task1_sent'] != null) task1Done = getValue['task1_sent'];
    if (getValue['task2_sent'] != null) task2Done = getValue['task2_sent'];
    if (getValue['task3_sent'] != null) task3Done = getValue['task3_sent'];
  }

  _getRandomTask() async {

    _timeControl();

    if (task1_time_done) {
      Random random = new Random();
      int randomNumber = random.nextInt(8) + 1;
      var recordData = await FirebaseFirestore.instance
          .collection('tasks')
          .doc('Q8elnpjjwODUNKwp3uu6')
          .get();
      var getValue = recordData.data();
      print(getValue['task' + randomNumber.toString()]);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task1_name': getValue['task' + randomNumber.toString()],
        'task1_token': getValue['task' + randomNumber.toString() + '_price'],
        'task1_image': '',
        'task1_sent': false,
        'task1_day_limit':
            getValue['task' + randomNumber.toString() + '_day_limit'],
        'task1_date': Timestamp.fromDate(DateTime.now()),
      });
      task1_time_done = false;
    }

    if (task2_time_done) {
      Random random = new Random();
      int randomNumber = random.nextInt(8) + 1;
      var recordData = await FirebaseFirestore.instance
          .collection('tasks')
          .doc('Q8elnpjjwODUNKwp3uu6')
          .get();
      var getValue = recordData.data();
      print(getValue['task' + randomNumber.toString()]);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task2_name': getValue['task' + randomNumber.toString()],
        'task2_token': getValue['task' + randomNumber.toString() + '_price'],
        'task2_image': '',
        'task2_sent': false,
        'task2_day_limit':
            getValue['task' + randomNumber.toString() + '_day_limit'],
        'task2_date': Timestamp.fromDate(DateTime.now()),
      });
      task2_time_done = false;
    }

    if (task3_time_done) {
      Random random = new Random();
      int randomNumber = random.nextInt(8) + 1;
      var recordData = await FirebaseFirestore.instance
          .collection('tasks')
          .doc('Q8elnpjjwODUNKwp3uu6')
          .get();
      var getValue = recordData.data();
      print(getValue['task' + randomNumber.toString()]);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'task3_name': getValue['task' + randomNumber.toString()],
        'task3_token': getValue['task' + randomNumber.toString() + '_price'],
        'task3_image': '',
        'task3_sent': false,
        'task3_day_limit':
            getValue['task' + randomNumber.toString() + '_day_limit'],
        'task3_date': Timestamp.fromDate(DateTime.now()),
      });
      task3_time_done = false;
    }
  }

  _timeControl() async {
    var recordData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    var getValue = recordData.data();
    DateTime givenTime1 = getValue['task1_date'].toDate();
    if (getValue['task1_day_limit'] <
        DateTime.now().difference(givenTime1).inDays) {
      task1_time_done = true;
    }

    DateTime givenTime2 = getValue['task2_date'].toDate();
    if (getValue['task2_day_limit'] <
        DateTime.now().difference(givenTime2).inDays) {
      task2_time_done = true;
    }

    DateTime givenTime3 = getValue['task3_date'].toDate();
    if (getValue['task3_day_limit'] <
        DateTime.now().difference(givenTime3).inDays) {
      task3_time_done = true;
    }
    
  }
}
