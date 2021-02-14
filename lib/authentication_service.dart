import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<int> signIn(
      {scaffold, aContext, String email, String password}) async {
    if (email.isEmpty || !EmailValidator.validate(email)) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Invalid e-mail!'),
        ),
      );
      return 0;
    }

    if (password.isEmpty || password.length < 6) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Invalid password!'),
        ),
      );
      return 0;
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacementNamed(aContext, '/begin');
      return 1;
    } on FirebaseAuthException catch (error) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text(error.message),
        ),
      );
      return 0;
    }
  }

  Future<int> signUp(
      {scaffold,
      aContext,
      String name,
      String surname,
      String email,
      String birthday,
      String password,
      String password2}) async {
    if (name.isEmpty || name.length < 3) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Name is invalid!'),
        ),
      );
      return 0;
    }

    if (surname.isEmpty || surname.length < 2) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Surname is invalid!'),
        ),
      );
      return 0;
    }

    if (email.isEmpty || !EmailValidator.validate(email)) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('E-mail is invalid!!'),
        ),
      );
      return 0;
    }

    if (birthday == null || birthday.isEmpty || birthday.length < 3) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Birthday is invalid!'),
        ),
      );
      return 0;
    }

    if ((password.isEmpty || password.length < 6) ||
        (password2.isEmpty || password2.length < 6)) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Password is invalid!'),
        ),
      );
      return 0;
    }

    if (password != password2) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text('Passwords are not the same!'),
        ),
      );
      return 0;
    }

    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        FirebaseFirestore.instance.collection('users').doc(user.user.uid).set({
          'name': name,
          'surname': surname,
          'birthday': birthday,
          'image': 'user.png',
          'token': 0,
          'admin': false,
          'task1_name': '',
          'task1_image': '',
          'task1_token': 0,
          'task1_sent': false,
          'task2_name': '',
          'task2_image': '',
          'task2_token': 0,
          'task2_sent': false,
          'task3_name': '',
          'task3_image': '',
          'task3_token': 0,
          'task3_sent': false,
          'total_tasks': 0,
        }).then((value) {
          scaffold.showSnackBar(
            new SnackBar(
              content: new Text('Successfully signed up!'),
            ),
          );
          Navigator.pushReplacementNamed(aContext, '/signIn');
        });
      });
      return 1;
    } on FirebaseAuthException catch (error) {
      scaffold.showSnackBar(
        new SnackBar(
          content: new Text(error.message),
        ),
      );
      return 0;
    }
  }

  Future<void> signOut(aContext) async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacementNamed(aContext, '/signIn');
  }
}
