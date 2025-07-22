import 'package:flutter/material.dart';
import 'package:zaplab_design/zaplab_design.dart';

class ZaplabExamplePage extends StatelessWidget {
  const ZaplabExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zaplab Design Example'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zaplab Design Components
            const Text(
              'Zaplab Design Components',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Example of Zaplab components
            // Note: These are examples - actual component names may vary
            // based on the current version of zaplab_design

            // Button example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buttons:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Primary Button'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: const Text('Secondary Button'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cards:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Example Card',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This is an example card component that demonstrates the design system.',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('Action'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Text input example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Inputs:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Example Input',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Platform info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Platform Support:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '✅ Mobile (Android & iOS)\n'
                    '✅ Desktop (macOS, Linux, Windows)\n'
                    '✅ Web (with full Flutter support)',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}