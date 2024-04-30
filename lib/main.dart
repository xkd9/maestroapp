import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maestroapp/dbcontroller.dart';
import 'package:maestroapp/login.dart';
import 'package:maestroapp/urlThumbnail.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: TextTheme (
          labelLarge: TextStyle(color: Colors.black)
        )
      ),
      home: const MyHomePage(title: 'Maestro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Widget> tiles = [];
  late User? _currentUser;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _checkCurrentUser());
  }

  Future<void> _checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
    
    if (_currentUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

  }

  void _showCreate() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.grey,
      context: context, 
      builder: (BuildContext context) {
        return Container(
          height:200,
          padding: EdgeInsetsDirectional.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Expanded (
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                      leading: GestureDetector(
                        onTap: () => print('icon tapped'),
                        child: Icon(Icons.close)
                      ),
                      //title: Text('TEST'),
                      trailing: ElevatedButton.icon(
                        icon:Icon(Icons.save),
                        onPressed: () {
                          save(_textFieldController.text);
                          print("saved");
                        },
                        label:Text("Save"),
                  )),
                  TextField(
                keyboardType: TextInputType.url,
                maxLines: 1,
                controller: _textFieldController,
                decoration: InputDecoration(
                            prefixIcon: Icon(Icons.terminal, color: Colors.black,),
                            border: OutlineInputBorder(),
                            labelText: "What do you want to save?",
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                
              ),
              SizedBox(height: 10),
                ],
              )
            )
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: GridView.builder(
      itemCount: tiles.length, // Number of grid items
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns in the grid
        mainAxisSpacing: 16.0, // Spacing between rows
        crossAxisSpacing: 16.0, // Spacing between columns
        childAspectRatio: 1.0, // Aspect ratio (square boxes)
      ),
      itemBuilder: (context, index) {
        return _buildSquareBox();
      },
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: _showCreate,
        tooltip: 'Add',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ), 
    );
  }
  Widget _buildSquareBox() {
    String url = _textFieldController.text;
    return Container(
      color: Colors.blue,
      width: 200.0,
      height: 200.0,
      // Add margin around the container
      margin: EdgeInsets.all(8.0),
      child: URLThumbnail(url),
    );
  }
  void save(String url) async {
    await DB.Save(url, "tech");
    setState(() {
      tiles.add(
        Container(
          padding: const EdgeInsets.all(8),
            child: URLThumbnail(url),
        ));
    });
  }
}