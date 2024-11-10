import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zubicalculator/pages/setup_pin_page.dart';
import 'vault_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  bool hasInput = false;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('vault_pin')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SetPinPage()),
        (route) => false,
      );
    }
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _clearAllCalculations();
      } else if (buttonText == "backspace") {
        _currentInput = _currentInput.isNotEmpty
            ? _currentInput.substring(0, _currentInput.length - 1)
            : "";
        if (_currentInput.isEmpty) {
          hasInput = false;
        }
      } else if (buttonText == "+/-") {
        if (_currentInput.isNotEmpty) {
          if (_currentInput.startsWith("-")) {
            _currentInput = _currentInput.substring(1);
          } else {
            _currentInput = "-$_currentInput";
          }
        }
      } else if (buttonText == "%") {
        if (_currentInput.isNotEmpty) {
          _currentInput = (double.parse(_currentInput) / 100).toString();
        }
      } else if (buttonText == "=") {
        _processEqualButton();
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "x" ||
          buttonText == "/") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operation = buttonText;
          _currentInput = "";
          hasInput = true;
        }
      } else {
        _currentInput += buttonText;
        hasInput = true;
      }

      _output = _currentInput.isEmpty ? "0" : _currentInput;
    });
  }

  void _processEqualButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPin = prefs.getString('vault_pin');
    if (_currentInput == storedPin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VaultPage()),
      );
    } else if (_operation.isNotEmpty && _currentInput.isNotEmpty) {
      _num2 = double.parse(_currentInput);

      switch (_operation) {
        case "+":
          _output = (_num1 + _num2).toString();
          break;
        case "-":
          _output = (_num1 - _num2).toString();
          break;
        case "x":
          _output = (_num1 * _num2).toString();
          break;
        case "/":
          _output = (_num1 / _num2).toString();
          break;
      }

      _currentInput = _output;
      _operation = "";
      _num1 = 0;
      _num2 = 0;
      hasInput = false;
    }
  }

  void _clearAllCalculations() {
    setState(() {
      _currentInput = "";
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operation = "";
      hasInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height / 10;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Zubi Calculator',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontFamily: GoogleFonts.styleScript().fontFamily,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _output,
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildButtonRow(
                    [hasInput ? 'backspace' : 'AC', '+/-', '%', '/'],
                    Colors.grey[850]!,
                    buttonHeight),
                _buildButtonRow(
                    ['7', '8', '9', 'x'], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(
                    ['4', '5', '6', '-'], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(
                    ['1', '2', '3', '+'], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(['0', '.', '='], Colors.orange, buttonHeight,
                    lastRow: true),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> texts, Color color, double buttonHeight,
      {bool lastRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: texts.map((text) {
        bool isZeroButton = text == '0' && lastRow;
        return Expanded(
          flex: isZeroButton ? 2 : 1,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: buttonHeight,
              decoration: BoxDecoration(
                color: text == '/' ||
                        text == 'x' ||
                        text == '-' ||
                        text == '+' ||
                        text == '='
                    ? Colors.orange
                    : color,
                borderRadius: BorderRadius.circular(40),
              ),
              child: text == "backspace"
                  ? GestureDetector(
                      onLongPress: _clearAllCalculations,
                      child: IconButton(
                        icon: const Icon(Icons.backspace, color: Colors.white),
                        onPressed: () => _buttonPressed(text),
                      ),
                    )
                  : TextButton(
                      onPressed: () => _buttonPressed(text),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: Align(
                        alignment: isZeroButton
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
