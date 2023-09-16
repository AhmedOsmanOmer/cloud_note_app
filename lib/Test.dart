// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
class Test extends StatefulWidget {
  const Test({ Key? key }) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
   File? file;
  ImagePicker imagepicker=ImagePicker();
  upload_img() async{
    var uploaded_img=await imagepicker.pickImage(source:ImageSource.gallery);

    if(uploaded_img==null){
      print("please upload image");
    }
    else{
      file=File(uploaded_img.path);
      var name=basename(uploaded_img.path);
      Reference refimage=  FirebaseStorage.instance.ref("images/$name");
      await refimage.putFile(file!);
       var url=await refimage.getDownloadURL();
       print("Url =======$url");
    }
    
  } 
   

getImagesName() async{
  var ref=await FirebaseStorage.instance.ref().list(ListOptions(maxResults: 1));
  ref.items.forEach((element) {
    print(element.name);
  });
}
@override
  void initState() async{
   await getImagesName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                child: Text("uploadfile"),
                onPressed: () async{
                await upload_img();
                },
              ),
            )
          ],
        ),
      ));
  }
}