import 'package:flutter/material.dart';
import 'package:zubicalculator/pages/confirm_pin_page.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  String _pin = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _pin = "";
      } else if (buttonText == "backspace") {
        _pin = _pin.isNotEmpty ? _pin.substring(0, _pin.length - 1) : "";
      } else if (buttonText == "=" && _pin.length == 6) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmPinPage(pin: _pin)),
        );
      } else if (_pin.length < 6 &&
          buttonText != "=" &&
          buttonText != "AC" &&
          buttonText != "backspace") {
        _pin += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height / 10;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Set Vault PIN',
          style: TextStyle(
            color: Colors.orangeAccent,
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
                        _pin,
                        style: const TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildButtonRow(
                    ['AC', 'backspace', ''], Colors.grey[850]!, buttonHeight),
                _buildButtonRow(
                    ['7', '8', '9', ''], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(
                    ['4', '5', '6', ''], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(
                    ['1', '2', '3', ''], Colors.grey[700]!, buttonHeight),
                _buildButtonRow(['0', '', '='], Colors.orange, buttonHeight,
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
                color: text == '=' ? Colors.orange : color,
                borderRadius: BorderRadius.circular(40),
              ),
              child: text.isEmpty
                  ? Container()
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
                        child: text == "backspace"
                            ? const Icon(Icons.backspace, color: Colors.white)
                            : Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
