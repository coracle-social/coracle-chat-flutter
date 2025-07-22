import 'package:flutter/material.dart';

class ExampleModalContent extends StatelessWidget {
  final String title;
  final String content;

  const ExampleModalContent({
    super.key,
    this.title = 'Example Modal',
    this.content = 'This is an example modal content that demonstrates the reusable modal functionality.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modal header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        // Modal content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('• Back button support (hardware & browser)'),
                const Text('• URL integration'),
                const Text('• GoRouter integration'),
                const Text('• Customizable size and padding'),
                const Text('• Reusable with any content'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close Modal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}