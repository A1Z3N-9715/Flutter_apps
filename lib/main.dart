import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = '0';
  double num1 = 0;
  double num2 = 0;
  String operator = '';
  String history = ''; // This will store the question (expression)

  // Handle button press logic
  void validateHistory() {
    // Validate the history length
    if (history.length > 25) {
      history = 'Too long'; // Indicate history overflow
    }
    if (history == 'Too long') {
      output = 'Try smaller numbers';
    }
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        output = '0';
        num1 = 0;
        num2 = 0;
        operator = '';
        history = '';
      } else if (buttonText == 'C') {
        output =
            output.length > 1 ? output.substring(0, output.length - 1) : '0';
      } else if (buttonText == '+/-') {
        if (output == '0') {
          output = '-';
        } else if (output == '-') {
          output = '0';
        } else {
          output = (double.parse(output) * -1).toString();
          if (output.endsWith('.0')) {
            output = output.substring(0, output.length - 2);
          }
        }
      } else if (buttonText == '=') {
        if (operator.isEmpty) return;

        num2 = double.parse(output);
        double result;
        switch (operator) {
          case '+':
            result = num1 + num2;
            break;
          case '-':
            result = num1 - num2;
            break;
          case '*':
            result = num1 * num2;
            break;
          case '/':
            result = num2 != 0 ? num1 / num2 : double.nan;
            break;
          default:
            result = 0;
            break;
        }
        output =
            result % 1 == 0 ? result.toInt().toString() : result.toString();

        String formattedNum1 =
            num1 % 1 == 0 ? num1.toInt().toString() : num1.toString();
        String formattedNum2 =
            num2 % 1 == 0 ? num2.toInt().toString() : num2.toString();
        history = '$formattedNum1 $operator $formattedNum2';

        operator = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '/' ||
          buttonText == '%') {
        if (buttonText == '%') {
          num1 = double.parse(output) / 100;
          output = num1 % 1 == 0 ? num1.toInt().toString() : num1.toString();
          history = output;
        } else {
          num1 = double.parse(output);
          operator = buttonText;
          output = '0';
          String formattedNum1 =
              num1 % 1 == 0 ? num1.toInt().toString() : num1.toString();
          history = '$formattedNum1 $operator';
        }
      } else {
        if (output.length < 10) {
          if (output == '0') {
            output = buttonText;
          } else {
            output += buttonText;
          }
        }
      }

      // Call validateHistory to ensure limits
      validateHistory();
    });
  }

  // Set the text size based on the length of the output, num1, num2, and result
  double getTextSize() {
    if (output.length > 12) {
      return 30.0; // smaller text size for results with more than 12 characters
    } else if (output.length > 5) {
      return 50.0; // smaller text size for numbers longer than 5 digits
    } else {
      return 100.0; // default text size
    }
  }

  double getHistoryTextSize() {
    if (history.length > 12) {
      return 25.0;
    } else {
      return 30.0;
    }
  }

  Widget Calculatorbtn(
      String btntxt, Color btncolor, Color txtcolor, double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () => buttonPressed(btntxt),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: fontSize,
            color: txtcolor,
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: btncolor,
            minimumSize: Size(70, 70),
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            )),
      ),
    );
  }

  Widget CalculatorbtnIcon(
      Color btncolor, Color iconcolor, Icon icon, double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () => buttonPressed('C'),
        child: icon,
        style: ElevatedButton.styleFrom(
            iconColor: iconcolor,
            iconSize: 25,
            backgroundColor: btncolor,
            minimumSize: Size(70, 70),
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Calculator'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[900],
      ),
      body: isLandscape
          ? SingleChildScrollView(
              // Make it scrollable in landscape mode
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            history,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: getHistoryTextSize(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            output,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getTextSize(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildButtonRows(),
                  ],
                ),
              ),
            )
          : Padding(
              // Fixed layout in portrait mode
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          history,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: getHistoryTextSize(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          output,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getTextSize(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildButtonRows(),
                ],
              ),
            ),
    );
  }

  Widget _buildButtonRows() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Calculatorbtn('AC', Colors.grey[850]!, Colors.orange, 30),
            CalculatorbtnIcon(Colors.grey[850]!, Colors.orange,
                Icon(Icons.backspace_outlined), 30),
            Calculatorbtn('%', Colors.grey[850]!, Colors.orange, 30),
            Calculatorbtn('/', Colors.grey[850]!, Colors.orange, 30),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Calculatorbtn('7', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('8', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('9', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('*', Colors.grey[850]!, Colors.orange, 30),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Calculatorbtn('4', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('5', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('6', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('-', Colors.grey[850]!, Colors.orange, 30),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Calculatorbtn('1', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('2', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('3', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('+', Colors.grey[850]!, Colors.orange, 30),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Calculatorbtn('+/-', Colors.grey[850]!, Colors.orange, 30),
            Calculatorbtn('0', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('.', Colors.grey[850]!, Colors.white, 30),
            Calculatorbtn('=', Colors.orange, Colors.white, 30),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
