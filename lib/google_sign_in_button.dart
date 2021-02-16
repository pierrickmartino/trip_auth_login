import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'authentication.dart';
import 'main.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({Key key}) : super(key: key);

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  // ignore: unused_field
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return SignInButton(Buttons.GoogleDark, onPressed: () async {
      setState(() {
        _isProcessing = true;
      });
      await signInWithGoogle().then((result) {
        //print(result);
        if (result != null) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute<dynamic>(
            fullscreenDialog: true,
            builder: (context) => const MyHomePage(title: 'Trip Auth Login'),
          ));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully logged in with Google.'),
          ));
        }
      }).catchError((dynamic error) {
        // ignore: avoid_print
        print('Registration Error: $error');
      });
      setState(() {
        _isProcessing = false;
      });
    });
  }
}
