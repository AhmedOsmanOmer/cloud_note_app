// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison, use_key_in_widget_constructors, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_course/functions/EditNotes.dart';
import 'package:flutter_course/functions/Veiw_Notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color.fromARGB(255, 228, 135, 166),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("login");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        backgroundColor: Color.fromARGB(255, 228, 135, 166),
      ),
      body: Container(
          child: FutureBuilder(
              future: noteref
                  .where("userid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (buildcontext, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          await noteref.doc(snapshot.data.docs[i].id).delete();
                          await FirebaseStorage.instance
                              .refFromURL(snapshot.data.docs[i]['imageURL'])
                              .delete();
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you wish to delete this note?"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("DELETE")),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListNotes(
                          notes: snapshot.data.docs[i],
                          docid: snapshot.data.docs[i].id,
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return View_Notes(
            note: notes,
          );
        }));
      },
      child: Card(
          child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageURL']}",
                fit: BoxFit.fill,
                height: 80,
              )),
          Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']}"),
                subtitle: Text(
                  "${notes['note']}",
                  maxLines: 1,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNotes(docid: docid, list: notes);
                    }));
                  },
                  icon: Icon(Icons.edit_note),
                ),
              )),
        ],
      )),
    );
  }
}
