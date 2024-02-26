// ignore_for_file: avoid_print, use_key_in_widget_constructors, file_names, todo, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import './widgets/mysnackbar.dart';
import './themes/theme.dart';

// Do not change the structure of this files code.
// Just add code at the TODO's.

final formKey = GlobalKey<FormState>();

// We must make the variable firstName nullable.
String? firstName;
final TextEditingController textEditingController = TextEditingController();

class MyFirstPage extends StatefulWidget {
  @override
  MyFirstPageState createState() => MyFirstPageState();
}

class MyFirstPageState extends State<MyFirstPage> {
  bool enabled = false;
  int timesClicked = 0;
  String msg1 = '';
  String msg2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A2 - User Input'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Enable Button'),
              Switch(
                  value: enabled,
                  onChanged: (bool onChangedValue) {
                    setState(() {
                      enabled = onChangedValue;
                      if (enabled) {
                        msg1 = 'Click Me';
                        msg2 = 'Reset';
                        print('Enabled is True');
                      } else {
                        print('Enabled is False');
                      }
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: enabled,
                child: ElevatedButton(
                  onPressed: enabled
                      ? () {
                          setState(() {
                            timesClicked++;
                          });
                        }
                      : null,
                  child: timesClicked == 0
                      ? Text('Click Me')
                      : Text('Clicked $timesClicked'),
                ),
              ),
              const SizedBox(width: 20),
              Visibility(
                visible: enabled,
                child: ElevatedButton(
                  onPressed: enabled
                      ? () {
                          setState(() {
                            timesClicked = 0;
                          });
                        }
                      : null,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textEditingController,
                    onChanged: (value) {
                      print(value);
                    },
                    onFieldSubmitted: (text) {
                      print('Submitted First Name = $text');
                      if (formKey.currentState!.validate()) {
                        print('First Name is valid now');
                      }
                    },
                    validator: (input) {
                      return input!.length < 1 ? 'Minimum 1 character please' : null;
                    },
                    obscureText: true,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.hourglass_bottom),
                      labelText: 'First Name',
                      helperText: 'min 1, max 20',
                      suffixIcon: Icon(
                        Icons.check_circle,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SnackbarButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SnackbarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          final name = textEditingController.text;

          final snackBar = SnackBar(
            content: Text('Hey ${name}'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Click Me',
              onPressed: () {
                print("SnackBar button is clicked!");
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: const Text('Submit'),
    );
  }
}