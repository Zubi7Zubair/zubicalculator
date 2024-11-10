import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vault_page.dart';

class ConfirmPinPage extends StatefulWidget {
  final String pin;

  const ConfirmPinPage({super.key, required this.pin});

  @override
  _ConfirmPinPageState createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
  String _confirmPin = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _confirmPin = "";
      } else if (buttonText == "backspace") {
        _confirmPin = _confirmPin.isNotEmpty
            ? _confirmPin.substring(0, _confirmPin.length - 1)
            : "";
      } else if (buttonText == "=" && _confirmPin.length == 6) {
        if (_confirmPin == widget.pin) {
          _storePin(widget.pin);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const VaultPage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('PINs do not match. Please try again.')),
          );
          _confirmPin = "";
        }
      } else if (_confirmPin.length < 6 &&
          buttonText != "=" &&
          buttonText != "AC" &&
          buttonText != "backspace") {
        _confirmPin += buttonText;
      }
    });
  }

  Future<void> _storePin(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('vault_pin', pin);
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height / 10;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Confirm Vault PIN',
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
                        _confirmPin,
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
