import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/pages/create_book_manager_mark.dart';

class BookManager extends StatefulWidget {

  const BookManager({Key? key}) : super(key: key);

  @override
  State<BookManager> createState() => _BookManagerState();
}

class _BookManagerState extends State<BookManager> {
  var searchQuery = "N";
  late Stream<QuerySnapshot<Object?>> streamQuery = FirebaseFirestore
      .instance.collection('book_manager').snapshots();

  void showToBuy() {
    setState(() {
      if (searchQuery == 'N') {
        searchQuery = 'Y';
      } else {
        searchQuery = 'N';
      }

      if (searchQuery.isEmpty || searchQuery == null || searchQuery == 'N'){
        streamQuery = FirebaseFirestore.instance.collection('book_manager').snapshots();
      } else {
        streamQuery = FirebaseFirestore.instance.collection('book_manager')
            .where('isInShoplist', isGreaterThanOrEqualTo: searchQuery)
            .where('isInShoplist', isLessThan:  searchQuery + 'z')
            .snapshots();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book manager'),
        actions: [
          IconButton(
              onPressed: () => showToBuy(),
              icon: const Icon(Icons.shopping_basket_outlined)
          ),
        ],
      ),
      backgroundColor:  Color(-2836062),
      body: StreamBuilder(
          stream: streamQuery,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("No bookmarks"),
                    ]
                ),
              );
            }
            return Scaffold(
              backgroundColor: Color(-2836062),
              body: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? id = snapshot.data?.docs[index].id;
                    String author = "";
                    String title = "";
                    String icon = "";
                    String isInShoplist = "N";
                    try {
                      author = snapshot.data?.docs[index].get('author');
                    } catch (e){
                      author = "";
                    }
                    try {
                      title = snapshot.data?.docs[index].get('title');
                    } catch (e){
                      title = "";
                    }
                    try {
                      icon = snapshot.data?.docs[index].get('icon');
                    } catch (e){
                      icon = "";
                    }
                    try {
                      isInShoplist = snapshot.data?.docs[index].get('isInShoplist');
                    } catch (e){
                      isInShoplist = "N";
                    }
                    return _MyListItem(id!, icon, title, author, isInShoplist);
                  }
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createBookManagerMark');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}


class _MyListItem extends StatefulWidget {
  final String id;
  final String icon;
  final String title;
  final String author;
  final String isInShoplist;
  const _MyListItem(this.id, this.icon,
      this.title, this.author, this.isInShoplist,  {Key? key}) : super(key: key);

  @override
  State<_MyListItem> createState() => _MyListItemState();
}

class _MyListItemState extends State<_MyListItem> {
  var tapPosition;
  String id = "";
  String icon = "";
  String title = "";
  String author = "";
  String isInShoplist = "N";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateBookManagerMark(id: widget.id, author: widget.author,
                    title: widget.title, icon: widget.icon, isInShoplist: widget.isInShoplist),
              ),
            );
          },
          child: LimitedBox(
            maxHeight: 60,
            child: Dismissible(
              key: Key(widget.id),
              onDismissed: (direction){
                FirebaseFirestore.instance.collection('book_manager')
                    .doc(widget.id).delete();
              },
              child: Container(
                decoration: BoxDecoration(

                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.black, width: 1.0),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(-2836062),
                      Color(-6523038),
                      Color(-7840182)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.asset(
                        'images/${widget.icon}.png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.author,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 24,),
                    _AddButton(id: widget.id, isInShoplist: widget.isInShoplist),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final String id;
  final String isInShoplist;

  _AddButton({required this.id, required this.isInShoplist, Key? key}) : super(key: key);

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isInShoplist == 'Y' ? () {
        FirebaseFirestore.instance.collection('book_manager')
            .doc(widget.id).update({'isInShoplist': 'N'});
      }
          :
          () {
        FirebaseFirestore.instance.collection('book_manager')
            .doc(widget.id).update({'isInShoplist': 'Y'});
      },
      icon:  widget.isInShoplist == 'Y'
          ? const Icon(Icons.shopping_basket, color: Colors.white)
          : const Icon(Icons.shopping_basket_outlined, color: Colors.white),
    );
  }
}

