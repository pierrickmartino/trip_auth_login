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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Trip Auth Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (userEmail == null)
                    OutlinedButton(
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
                    )
                  else
                    Row(
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
                            padding: const EdgeInsets.all(12),
                            child: _isProcessing
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Sign out',
                                  ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
