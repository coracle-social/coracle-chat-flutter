import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frb_example_gallery/app/components/simple_example.dart';
import 'package:frb_example_gallery/app/components/zaplab_modal_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Rust Bridge Gallery'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildExampleCard(
                    context,
                    'Simple Functions',
                    'Simple Rust function examples',
                    Icons.auto_fix_high,
                    () {
                      // Navigate to simple functions tab
                      final router = GoRouter.of(context);
                      router.go('/simple');
                    },
                  ),
                  _buildExampleCard(
                    context,
                    'Zaplab Design',
                    'UI components and design system',
                    Icons.design_services,
                    () => context.go('/home/zaplab'),
                  ),
                  _buildExampleCard(
                    context,
                    'Example Modal',
                    'Demonstrates reusable modal functionality',
                    Icons.open_in_new,
                    () => context.go('/home/example-modal'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


}