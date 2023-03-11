import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    initFirebase();
    return Scaffold(
      backgroundColor: Color(-2836062),
      appBar: AppBar(
        title: Text("Booknote", style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/bookMarks');
              }, child: Text('bookmarks')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/bookMarks');
              }, child: Text('bookmarks')),
            )
          ],
        ),
      ),
    );
  }
}
