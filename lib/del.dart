import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _forKey = GlobalKey<FormState>();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  String _result = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _removeData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _result = prefs.getString('result') ?? '';
      _status = prefs.getString('status') ?? '';
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('result', _result);
    await prefs.setString('status', _status);
  }

  Future<void> _removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('result');
    await prefs.remove('status');
    setState(() {
      _result = '0.00';
      _status = 'No Data';
    });
  }

  void _submit() {
    if (_forKey.currentState!.validate()) {
      debugPrint('Success');
      debugPrint('Height:${_height.text}');
      debugPrint('Weight:${_weight.text}');
      debugPrint('Result:$_result');
      final heightValue = double.parse(_height.text);
      final weightValue = double.parse(_weight.text);

      setState(() {
        _result = ((weightValue / heightValue / heightValue) * 10000)
            .toStringAsFixed(2);
        num resultFinal = double.parse(_result);
        if (resultFinal < 18.5) {
          _status = 'Underweight';
        } else if (resultFinal >= 18.5 && resultFinal < 25) {
          _status = 'Normal';
        } else if (resultFinal >= 25 && resultFinal < 30) {
          _status = 'Overweight';
        } else if (resultFinal >= 30) {
          _status = 'Obese';
        }
      });

      _saveData();
    } else {
      debugPrint('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Calculate your BMI"),
            Text(_result),
            Text(_status),
            Padding(
              padding: const EdgeInsets.all(50),
              child: Form(
                key: _forKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _height,
                      decoration: const InputDecoration(
                        label: Text("Height"),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Height in centimeter';
                        } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                          return 'Please enter a valid number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _weight,
                      decoration: const InputDecoration(
                        label: Text("Weight"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Weight in centimeter';
                        } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                          return 'Please enter a valid number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Calculate BMI"),
                    ),
                    ElevatedButton(
                      onPressed: _removeData,
                      child: const Text("Remove Data"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
