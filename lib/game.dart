import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String selectedOperation = 'Addition'; // Default selected operation
  String equationText = '';
  int correctAnswer = 0;
  TextEditingController answerController = TextEditingController();
  String message = '';
  int equationCount = 0;
  bool answerChecked = false; // Added variable to track whether the answer is checked

  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    generateEquation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Page'),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Welcome to the Game!',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Select an Operation:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOperation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOperation = newValue!;
                        generateEquation();
                      });
                    },
                    items: <String>['Addition', 'Multiplication', 'Division']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  equationText,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: answerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your Answer',
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      checkAnswer();
                      answerChecked = true; // Set answerChecked to true after checking the answer
                    });
                  },
                  child: Text('Check Answer'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    if (answerChecked) {
                      setState(() {
                        nextEquation();
                        answerChecked = false; // Reset answerChecked for the next equation
                      });
                    }
                  },
                  child: Text('Next'),
                ),
                SizedBox(height: 10.0),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: message.contains('Correct') ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ElevatedButton(
                onPressed: viewScore,
                child: Text('View Score'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAnswer() {
    String userAnswerText = answerController.text.trim();
    if (userAnswerText.isEmpty) {
      setState(() {
        message = 'Please enter the answer.';
      });
      return;
    }

    int userAnswer = int.tryParse(userAnswerText) ?? 0;
    if (userAnswer == correctAnswer) {
      setState(() {
        message = 'Correct!';
        users.add({'equation': equationText, 'userAnswer': userAnswer.toString(), 'correct': true});
      });
    } else {
      setState(() {
        message = 'Incorrect. Try again!';
        users.add({'equation': equationText, 'userAnswer': userAnswer.toString(), 'correct': false});
      });
    }
  }


  void generateEquation() {
    Random random = Random();
    int operand1 = random.nextInt(10);
    int operand2 = random.nextInt(10);

    switch (selectedOperation) {
      case 'Addition':
        correctAnswer = operand1 + operand2;
        equationText = '$operand1 + $operand2 = ?';
        break;
      case 'Multiplication':
        correctAnswer = operand1 * operand2;
        equationText = '$operand1 x $operand2 = ?';
        break;
      case 'Division':
      // Ensure non-zero divisor for division
        operand2 = operand2 == 0 ? 1 : operand2;
        correctAnswer = operand1 ~/ operand2; // Use integer division for simplicity
        equationText = '$operand1 ÷ $operand2 = ?';
        break;
    }
  }

  void nextEquation() {
    if (equationCount < 15) {
      equationCount++;
      generateEquation();
      answerController.clear();
      message = '';
    } else {
      message = 'You have reached the maximum number of equations.';
    }
  }

  void viewScore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewScorePage(users: users, correctAnswers: equationCount),
      ),
    );
  }
}

class ViewScorePage extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final int correctAnswers;

  ViewScorePage({required this.users, required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    int correctCount = users.where((user) => user['correct'] == true).length;
    double percentage = (correctCount / 15) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('View Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score Summary',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Correct Answers: $correctCount / 15',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            // Display user data
            ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['equation']),
                  subtitle: Text(
                    'Your Answer: ${users[index]['userAnswer']} | Correct: ${users[index]['correct']}',
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}