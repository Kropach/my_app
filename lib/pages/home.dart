import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/booknote_paralax.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _newBookMark = "";
  List bookNoteList = [];

  @override
  void initState() {
    super.initState();

  }

  void _openMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Menu'),),
          body: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false
                    );
                  },
                  child: Text('Home')
              )
            ],
          )
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(-2836062),
      appBar: AppBar(
        title: Text("Booknote", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _openMenu,
              icon: Icon(Icons.menu_outlined)
          )
        ],
      ),
      body: const Center(
        child: BooknoteParalax(),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('notes').snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Scaffold(
      //         body: Text('No notes', style: TextStyle())
      //       );
      //     }
      //     return ListView.builder(
      //       itemCount: snapshot.data?.docs.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         return Dismissible(
      //             key: Key(snapshot.data?.docs[index].id as String),
      //             child: Card(
      //               color: Color(-4420749),
      //               child: ListTile(
      //                 title: Text(snapshot.data?.docs[index].get('note') as String,
      //                   style: TextStyle(color: Colors.white),),
      //               ),
      //             ),
      //             onDismissed: (direction){
      //               // if (direction == DismissDirection.endToStart) {
      //                 FirebaseFirestore.instance.collection('notes')
      //                     .doc(snapshot.data?.docs[index].id).delete();
      //               // }
      //             },
      //         );
      //       }
      //     );
      //   }
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Add bookmark"),
              content: TextField(
                onChanged: (String value) {
                  _newBookMark = value;
                },
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('notes')
                          .add({'note': _newBookMark});

                      Navigator.of(context).pop();
                    },
                    child: Text("Add")
                )
              ],
            );
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
