// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison, camel_case_types

import 'package:flutter/material.dart';
class  View_Notes extends StatefulWidget {
final note;
const View_Notes({ Key? key,this.note }) : super(key: key);

  @override
  _View_NotesState createState() => _View_NotesState();
}

class _View_NotesState extends State<View_Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note View"),
        backgroundColor: Color.fromARGB(255, 228, 135, 166),
      ),
      body: ListView(
        padding: EdgeInsets.all(25),
          children: [
            Center(child: Container(child: Image.network("${widget.note['imageURL']}",width: double.infinity,height: 300,fit: BoxFit.fill,))),
            SizedBox(height: 20,),
             Center(
               child: Text("${widget.note['title']}",style:TextStyle(  
                 color: Colors.black,
                 fontSize: 35,
            )),
             ),
             SizedBox(height: 20),
             Center(
               child: Text("${widget.note['note']}",style:TextStyle(
                 color: Colors.black,
                 fontSize: 25
            )),
             ),
          ],
        ),
      );
  }
}