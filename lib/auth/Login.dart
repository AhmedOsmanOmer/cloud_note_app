// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/functions/alert.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myemail, mypassword;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signIn() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myemail, password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
              AwesomeDialog(
              context: context,
              title: "error",
              body: Text("'No user found for that email"))
            ..show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("Wrong password provided for that user"))
            ..show();
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      print("not vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: 100),
        Center(child: Image.asset("images/logo2.png")),
        Container(
          padding: EdgeInsets.all(20),
          child: Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myemail = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        return "Email con not be more than 100 letters";
                      }
                      if (val.length < 2) {
                        return "Email can not be less than 2 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onSaved: (val) {
                      mypassword = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        return "password can not be more than 100 letters";
                      }
                      if (val.length < 4) {
                        return "password can not be less than 4 letters";
                      }
                      return null;
                    },
                    obscureText: true,
                
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: "Password",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text("if you dont have account "),
                        InkWell(
                          child: Text(
                            "click here",
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed("signup");
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () async {
                        UserCredential user = await signIn();
                        if (user != null) {
                         Navigator.of(context).pushReplacementNamed("home");
                        } else {
                          print("failed");
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                    ),
                  )
                ],
              )),
        )
      ]),
    );
  }
}
