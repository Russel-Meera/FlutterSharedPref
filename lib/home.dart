import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBMI extends StatefulWidget {
  const MyBMI({super.key});

  @override
  State<MyBMI> createState() => _MyBMIState();
}

class _MyBMIState extends State<MyBMI> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String bmiResult = '';
  String textResult = '';
  String infoResult = '';

  @override
  void initState() {
    loadResult();
    super.initState();
  }

  Future<void> saveResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("bmi", bmiResult);
    prefs.setString("text", textResult);
    prefs.setString("info", infoResult);
  }

  Future<void> loadResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      textResult = prefs.getString("text") ?? '';
      bmiResult = prefs.getString("bmi") ?? '';
      infoResult = prefs.getString("info") ?? '';
    });
  }

  Future<void> removeResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("text");
    await prefs.remove("bmi");
    await prefs.remove("info");
    setState(() {
      textResult = 'No data';
      bmiResult = '0.00';
      infoResult = 'No data';
    });
  }

  void calculate() {
    if (_formKey.currentState!.validate()) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      setState(
        () {
          bmiResult = (weight / (height * height) * 10000).toStringAsFixed(2);
          num result = double.parse(bmiResult);

          if (result <= 18.5) {
            textResult = "Underweight";
            infoResult =
                "You need to gain weight. Try to eat more healthy foods.";
          } else if (result <= 24.5) {
            textResult = "Normal";
            infoResult = "You have a normal weight. Keep it up!";
          } else if (result <= 29.9) {
            textResult = "Overweight";
            infoResult =
                "You need to lose weight. Try to eat less unhealthy foods.";
          } else {
            textResult = "Obese";
            infoResult =
                "You need to lose weight. Try to eat less unhealthy foods.";
          }
        },
      );
      saveResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[600],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // SizedBox(
              //   height: 200,
              //   width: 500,
              //   child: Image.asset('assets/BmiChart.png'),
              // ),
              Card(
                elevation: 10,
                child: Image.asset(
                  'assets/BmiChart.png',
                  height: 210,
                  width: 405,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(bmiResult),
              Text(textResult),
              Text(infoResult),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Centimeter",
                        label: Text("Height"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.height),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Height in centimeter';
                        } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                          return 'Please enter a valid number';
                        } else {
                          double checker = double.parse(value);
                          if (checker < 2.5) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Kilograms",
                        label: Text("Weight"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.scale),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Height in centimeter';
                        } else if (!RegExp(r'^\d+(\.\d{1,2})?$')
                            .hasMatch(value)) {
                          return 'Please enter a valid number';
                        } else {
                          double checker = double.parse(value);
                          if (checker < 2.5) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        calculate();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text(
                        "Calculate",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        removeResult();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
