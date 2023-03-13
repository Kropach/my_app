import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateBookManagerMark extends StatefulWidget {
  final String id;
  final String author;
  final String title;
  final String icon;
  final String isInShoplist;

  const CreateBookManagerMark({Key? key, required this.id, required this.author,
    required this.title, required this.icon, required this.isInShoplist}) : super(key: key);

  @override
  State<CreateBookManagerMark> createState() => _CreateBookManagerMarkState();

}

class _CreateBookManagerMarkState extends State<CreateBookManagerMark> {
  String id = "";
  String author = "";
  String title = "";
  String icon = "waiting";
  String isInShoplist = "N";
  String appBarText = "Manage book";

  _CreateBookManagerMarkState();

  @override
  void initState() {
    super.initState();
    id = widget.id;
    author = widget.author;
    title = widget.title;
    icon = widget.icon;
    isInShoplist = widget.isInShoplist;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id.isNotEmpty){
      appBarText = 'Manage book';
    }
    return Scaffold(
      backgroundColor: Color(-2836062),
      appBar: AppBar(
        title: Text(appBarText, style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "Author",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: TextEditingController(
                    text: widget.author
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  // labelText: 'Author',

                ),
                onChanged: (String value) {
                  author = value;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "Title",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: TextEditingController(
                    text: widget.title
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  title = value;
                },
              ),
            ),
            Center(
              child: Container(
                color: Color(-2836062),
                height: 100.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                icon = 'waiting';
                              });
                            },
                            iconSize: 50,
                            icon: Icon(Icons.access_time_filled),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                icon = 'read';
                              });
                            },
                            iconSize: 50,
                            icon: Icon(Icons.book),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                icon = 'reading';
                              });
                            },
                            iconSize: 50,
                            icon: Icon(Icons.menu_book),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                icon = 'favorite';
                              });
                            },
                            iconSize: 50,
                            icon: Icon(Icons.bookmark_add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.id.isNotEmpty){
                    FirebaseFirestore.instance.collection('book_manager')
                        .doc(widget.id).update({'author': author, 'title': title,
                      'isInShoplist': isInShoplist, 'icon' : icon});
                  } else {
                    FirebaseFirestore.instance.collection('book_manager')
                        .add({'author': author, 'title': title,
                      'isInShoplist': isInShoplist, 'icon' : icon});
                  }


                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}