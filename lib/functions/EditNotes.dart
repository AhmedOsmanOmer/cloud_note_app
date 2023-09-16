// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, unnecessary_string_interpolations, await_only_futures, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_course/functions/alert.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;
  const EditNotes({Key? key, this.docid,this.list}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  var noteref = FirebaseFirestore.instance.collection("notes");
  var ref;
  File? file;
  var title, note, imageurl;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  Add_Notes(context) async {
    var formdata = formstate.currentState;

    if (file == null) {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await noteref.doc(widget.docid).update({
          "title": title,
          "note": note,
          }).then((value){
            Navigator.of(context).pop();

        Navigator.of(context).pushNamed("home");
          }).catchError((e){
            print("$e");
          });
      
      }
    } else {
      var formdata = formstate.currentState;
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await ref.putFile(file);
        imageurl = await ref.getDownloadURL();
        await noteref.doc(widget.docid).update({
            "title": title,
            "note": note,
            "imageURL": imageurl,
          }).then((value){
            Navigator.of(context).pop();

        Navigator.of(context).pushNamed("home");
          }).catchError((e){
            print("$e");
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notes"),
        backgroundColor: Color.fromARGB(255, 228, 135, 166),
      ),
      body: ListView(
        children: [
          Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.list['title'],
                    validator: (val) {
                      if (val!.length > 30) {
                        return "title can not be more than 30 letters";
                      }
                      if (val.length < 2) {
                        return "title can not be less than 2 letters";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      title = val;
                    },
                    maxLength: 30,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: "Note Title",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  TextFormField(
                    initialValue: widget.list['note'],
                    validator: (val) {
                      if (val!.length > 300) {
                        return "note can not be more than 400 letters";
                      }
                      if (val.length < 2) {
                        return "note can not be less than 2 letters";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      note = val;
                    },
                    minLines: 1,
                    maxLines: 10,
                    maxLength: 400,
                    decoration:InputDecoration(
                        prefixIcon: Icon(Icons.note),
                        labelText: "Note",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  RaisedButton(
                    onPressed: () {
                      showButtomSheet(context);
                    },
                    child: Text("Edit Image to the note"),
                  ),
                  SizedBox(height: 150),
                  RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    onPressed: () async {
                      await Add_Notes(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  showButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose image",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    var picked_image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked_image != null) {
                      file = File(picked_image.path);
                      var rand = Random().nextInt(1000);
                      var image_name = "$rand" + basename(picked_image.path);
                      ref = await FirebaseStorage.instance
                          .ref("images")
                          .child("$image_name");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.photo),
                          SizedBox(width: 10),
                          Text(
                            "Gallery",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 23),
                InkWell(
                    onTap: () async {
                      var picked_image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (picked_image != null) {
                        file = File(picked_image.path);
                        var rand = Random().nextInt(100000000);
                        var image_name = "$rand" + basename(picked_image.path);
                        ref = FirebaseStorage.instance
                            .ref("/images")
                            .child("$image_name");
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        SizedBox(width: 10),
                        Text(
                          "Camera",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
  }
}
