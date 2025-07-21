import 'package:flutter/material.dart';
import 'package:frb_example_gallery/core/bridge/api/simple.dart';

class SimpleExamplePageBody extends StatefulWidget {
  const SimpleExamplePageBody({super.key});

  @override
  State<SimpleExamplePageBody> createState() => _SimpleExamplePageBodyState();
}

class _SimpleExamplePageBodyState extends State<SimpleExamplePageBody> {
  String greeting = '';
  int addResult = 0;
  int multiplyResult = 0;
  List<int> numberList = [];
  int fibonacciResult = 0;
  String reversedString = '';
  int charCount = 0;
  bool isPrimeResult = false;

  final TextEditingController _nameController = TextEditingController(text: 'World');
  final TextEditingController _num1Controller = TextEditingController(text: '5');
  final TextEditingController _num2Controller = TextEditingController(text: '3');
  final TextEditingController _fibController = TextEditingController(text: '10');
  final TextEditingController _stringController = TextEditingController(text: 'Hello Rust!');
  final TextEditingController _primeController = TextEditingController(text: '17');

  @override
  void dispose() {
    _nameController.dispose();
    _num1Controller.dispose();
    _num2Controller.dispose();
    _fibController.dispose();
    _stringController.dispose();
    _primeController.dispose();
    super.dispose();
  }

  Future<void> _getGreeting() async {
    try {
      final result = await getGreeting(name: _nameController.text);
      setState(() {
        greeting = result;
      });
    } catch (e) {
      setState(() {
        greeting = 'Error: $e';
      });
    }
  }

  Future<void> _addNumbers() async {
    try {
      final a = int.parse(_num1Controller.text);
      final b = int.parse(_num2Controller.text);
      final result = await addNumbers(a: a, b: b);
      setState(() {
        addResult = result;
      });
    } catch (e) {
      setState(() {
        addResult = -1;
      });
    }
  }

  Future<void> _multiplyNumbers() async {
    try {
      final a = int.parse(_num1Controller.text);
      final b = int.parse(_num2Controller.text);
      final result = await multiplyNumbers(a: a, b: b);
      setState(() {
        multiplyResult = result;
      });
    } catch (e) {
      setState(() {
        multiplyResult = -1;
      });
    }
  }

  Future<void> _getNumberList() async {
    try {
      final count = int.parse(_num1Controller.text);
      final result = await getNumberList(count: count);
      setState(() {
        numberList = result;
      });
    } catch (e) {
      setState(() {
        numberList = [];
      });
    }
  }

  Future<void> _calculateFibonacci() async {
    try {
      final n = int.parse(_fibController.text);
      final result = await fibonacci(n: n);
      setState(() {
        fibonacciResult = result.toInt();
      });
    } catch (e) {
      setState(() {
        fibonacciResult = -1;
      });
    }
  }

  Future<void> _reverseString() async {
    try {
      final result = await reverseString(input: _stringController.text);
      setState(() {
        reversedString = result;
      });
    } catch (e) {
      setState(() {
        reversedString = 'Error: $e';
      });
    }
  }

  Future<void> _countCharacters() async {
    try {
      final result = await countCharacters(input: _stringController.text);
      setState(() {
        charCount = result;
      });
    } catch (e) {
      setState(() {
        charCount = -1;
      });
    }
  }

  Future<void> _checkPrime() async {
    try {
      final n = int.parse(_primeController.text);
      final result = await isPrime(n: n);
      setState(() {
        isPrimeResult = result;
      });
    } catch (e) {
      setState(() {
        isPrimeResult = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simple Rust Functions Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Greeting section
          _buildSection(
            'Greeting',
            [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _getGreeting,
                child: const Text('Get Greeting'),
              ),
              if (greeting.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Result: $greeting'),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Math operations section
          _buildSection(
            'Math Operations',
            [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _num1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Number 1',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _num2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Number 2',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addNumbers,
                      child: const Text('Add'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _multiplyNumbers,
                      child: const Text('Multiply'),
                    ),
                  ),
                ],
              ),
              if (addResult != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Add Result: $addResult'),
                ),
              if (multiplyResult != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Multiply Result: $multiplyResult'),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Number list section
          _buildSection(
            'Number List',
            [
              ElevatedButton(
                onPressed: _getNumberList,
                child: const Text('Generate Number List'),
              ),
              if (numberList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Result: ${numberList.join(', ')}'),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Fibonacci section
          _buildSection(
            'Fibonacci',
            [
              TextField(
                controller: _fibController,
                decoration: const InputDecoration(
                  labelText: 'Enter n for Fibonacci',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _calculateFibonacci,
                child: const Text('Calculate Fibonacci'),
              ),
              if (fibonacciResult != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Result: $fibonacciResult'),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // String operations section
          _buildSection(
            'String Operations',
            [
              TextField(
                controller: _stringController,
                decoration: const InputDecoration(
                  labelText: 'Enter a string',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _reverseString,
                      child: const Text('Reverse'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _countCharacters,
                      child: const Text('Count Chars'),
                    ),
                  ),
                ],
              ),
              if (reversedString.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Reversed: $reversedString'),
                ),
              if (charCount != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Character Count: $charCount'),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Prime check section
          _buildSection(
            'Prime Check',
            [
              TextField(
                controller: _primeController,
                decoration: const InputDecoration(
                  labelText: 'Enter a number to check',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _checkPrime,
                child: const Text('Check if Prime'),
              ),
              if (isPrimeResult)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Result: ${_primeController.text} is prime!'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}