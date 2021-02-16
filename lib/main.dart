import 'package:flutter/material.dart';

import 'auth_dialog.dart';
import 'authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Auth Login',
      theme: ThemeData(
        // This is the theme of your application.

        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Trip Auth Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<dynamic> getUserInfo() async {
    await getUser();
    setState(() {});

    // ignore: avoid_print
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            if (userEmail == null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AuthDialog(),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Sign in'),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl) : null,
                      child: imageUrl == null
                          ? const Icon(
                              Icons.account_circle,
                              size: 30,
                            )
                          : Container(),
                    ),
                    const SizedBox(width: 5),
                    Text(name ?? userEmail),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _isProcessing
                          ? null
                          : () async {
                              setState(() {
                                _isProcessing = true;
                              });
                              await signOut().then((result) {
                                //print(result);
                                //Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<dynamic>(
                                    fullscreenDialog: true,
                                    builder: (context) => const MyHomePage(
                                        title: 'Trip Auth Login'),
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Successfully signed out.'),
                                ));
                              }).catchError((dynamic error) {
                                // ignore: avoid_print
                                print('Sign Out Error: $error');
                              });
                              setState(() {
                                _isProcessing = false;
                              });
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                        ),
                        child: _isProcessing
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Sign out',
                              ),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
