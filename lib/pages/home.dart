import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/booknote_list.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";
  String searchField = "title";
  var tapPosition;
  late Stream<QuerySnapshot<Object?>> streamQuery = FirebaseFirestore
      .instance.collection('notes').snapshots();

  @override
  void initState() {
    super.initState();

  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search by $searchField",
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      GestureDetector(
        child: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
        onTapDown: (TapDownDetails details) {
          tapPosition = details.globalPosition;
        },
        onLongPress: () async {
          var value = await showMenu(
            context: context,
            position: RelativeRect.fromRect(
                tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero & Size(40,40) // Bigger rect, the entire screen
            ),
            items: [
              const PopupMenuItem(
                child: Text("title", style: TextStyle(color: Colors.black, fontSize: 18),),
                value: 'title',
              ),
              const PopupMenuItem(
                child: Text("author", style: TextStyle(color: Colors.black, fontSize: 18),),
                value: 'author',
              ),
              const PopupMenuItem(
                child: Text("text", style: TextStyle(color: Colors.black, fontSize: 18),),
                value: 'text',
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),

          );
          setState(() {
            searchField = value!;
          });
        },
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;

    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;

      if (searchQuery.isEmpty || searchQuery == null){
        streamQuery = FirebaseFirestore.instance.collection('notes').snapshots();
      } else {
        streamQuery = FirebaseFirestore.instance.collection('notes')
            .where(searchField, isGreaterThanOrEqualTo: searchQuery)
            .where(searchField, isLessThan:  searchQuery + 'z')
            .snapshots();
      }

    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      streamQuery = FirebaseFirestore.instance.collection('notes').snapshots();
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(-2836062),
      appBar: AppBar(
        leading: const BackButton(),
        title: _isSearching ? _buildSearchField() : const Text("Bookmark"),
        actions: _buildActions(),
      ),
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
                  String text = "";
                  String author = "";
                  String title = "";
                  try {
                    text = snapshot.data?.docs[index].get('text');
                  } catch (e){
                    text = "";
                  }
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
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createBookmark');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
