import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/booknote_list.dart';


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
      // body: const Center(
      //   child: BooknoteParalax(),
      // ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('notes').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("No bookmarks"),
                    ]
                ),
              );
            }
            return Scaffold(
              backgroundColor: Color(-2836062),
              body: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String text = "";
                    String author = "";
                    String title = "";
                    try {
                      text = snapshot.data?.docs[index].get('text');
                    } catch (e){
                      text = "Text";
                    }
                    try {
                      author = snapshot.data?.docs[index].get('author');
                    } catch (e){
                      author = "Author A. A.";
                    }
                    try {
                      title = snapshot.data?.docs[index].get('title');
                    } catch (e){
                      title = "Title";
                    }
                    return Dismissible(
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("DELETE")
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      key: Key(snapshot.data?.docs[index].id as String),
                      child: Card(
                        color: Color(-4420749),

                        child: BooknoteList(
                          id: snapshot.data?.docs[index].id as String,
                          text: text,
                          author: author,
                          title: title,
                        ),
                      ),
                      onDismissed: (direction){
                        // if (direction == DismissDirection.endToStart) {
                        FirebaseFirestore.instance.collection('notes')
                            .doc(snapshot.data?.docs[index].id).delete();
                        // }
                      },
                    );
                  }
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createBookmark');
        },
        // onPressed: () {
        //   showDialog(context: context, builder: (BuildContext context){
        //     return AlertDialog(
        //       title: Text("Add bookmark"),
        //       content: TextField(
        //         onChanged: (String value) {
        //           _newBookMark = value;
        //         },
        //       ),
        //       actions: [
        //         ElevatedButton(
        //             onPressed: () {
        //               FirebaseFirestore.instance.collection('notes')
        //                   .add({'note': _newBookMark});
        //
        //               Navigator.of(context).pop();
        //             },
        //             child: Text("Add")
        //         )
        //       ],
        //     );
        //   });
        // },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
