import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Math Game'),
        ),
        body: UserForm(),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  int labelId = 0;
  String username = '';
  String gender = '';
  List<Map<String, String>> users = [
    {'id': '1', 'name': 'John Doe', 'gender': 'Male'},
    {'id': '2', 'name': 'Jane Smith', 'gender': 'Female'},
    {'id': '3', 'name': 'Bob Johnson', 'gender': 'Male'},
    {'id': '4', 'name': 'Bob', 'gender': 'Male'},
  ];

  bool isButtonEnabled() {
    return labelId != 0 && username.isNotEmpty && gender.isNotEmpty;
  }

  bool isAddButtonEnabled = false;
  bool isBackgroundVisible = true; // Variable to track background visibility

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/math.jpg'), // Adjust the path accordingly
          fit: BoxFit.cover,
          colorFilter: isBackgroundVisible
              ? null
              : ColorFilter.mode(
            Colors.white.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make the scaffold background transparent
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Make the app bar background transparent
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('mode:'),
                  Checkbox(
                    value: isBackgroundVisible,
                    onChanged: (value) {
                      setState(() {
                        isBackgroundVisible = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              Text('ID:'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    labelId = int.tryParse(value) ?? 0;
                    isAddButtonEnabled = false;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Username:'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                    isAddButtonEnabled = false;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Gender:'),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                        isAddButtonEnabled = false;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                        isAddButtonEnabled = false;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isButtonEnabled()
                    ? () {
                  if (isIdInHistory(labelId)) {
                    // Check if ID is in history
                    showMessage('Try another ID');
                  } else {
                    Map<String, String> newUser = {
                      'id': labelId.toString(),
                      'name': username,
                      'gender': gender,
                    };
                    setState(() {
                      users.add(newUser);
                      isAddButtonEnabled = true;
                    });

                    setState(() {
                      labelId = 0;
                      username = '';
                      gender = '';
                    });
                  }
                }
                    : null,
                child: Text('Add'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isAddButtonEnabled
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage()),
                  );
                }
                    : null,
                child: Text("Let's Go"),
              ),
              SizedBox(height: 20.0),
              Text(
                'User List:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 4.0,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'ID: ${users[index]['id']}, Name: ${users[index]['name']}, Gender: ${users[index]['gender']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        // Add a button to remove the user
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isIdInHistory(int id) {
    return users.any((user) => user['id'] == id.toString());
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('notice'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
