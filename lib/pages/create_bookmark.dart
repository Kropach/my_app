import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateBookmark extends StatefulWidget {
  final String id;
  final String author;
  final String title;
  final String text;

  const CreateBookmark({Key? key, required this.id, required this.author,
    required this.title, required this.text}) : super(key: key);

  @override
  State<CreateBookmark> createState() => _CreateBookmarkState();

}

class _CreateBookmarkState extends State<CreateBookmark> {
  String id = "";
  String author = "";
  String title = "";
  String text = "";
  String appBarText = "New Booknote";

  _CreateBookmarkState();

  @override
  void initState() {
    super.initState();
    id = widget.id;
    author = widget.author;
    title = widget.title;
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id.isNotEmpty){
      appBarText = 'Edit Booknote';
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
              child: Text("Author", style: TextStyle(color: Colors.white, fontSize: 18),),
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
              child: Text("Title", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                  // labelText: 'Title',
                ),
                onChanged: (String value) {
                  title = value;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text("Text", style: TextStyle(color: Colors.white, fontSize: 18),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: TextEditingController(
                    text: widget.text
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  // labelText: 'Text',
                ),
                onChanged: (String value) {
                  text = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  if (!widget.id.isEmpty){
                    FirebaseFirestore.instance.collection('notes')
                        .doc(widget.id).update({'author': author, 'title': title,
                      'text': text});
                  } else {
                    FirebaseFirestore.instance.collection('notes')
                        .add({'author': author, 'title': title, 'text': text});
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