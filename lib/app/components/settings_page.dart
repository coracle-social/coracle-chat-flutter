import 'package:flutter/material.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:frb_example_gallery/app/components/zap_expandable_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _themeDropdownOpen = false;
  bool _aboutDropdownOpen = false;
  bool _profileDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildThemeSetting(),
                  const SizedBox(height: 16),
                  _buildProfileSetting(),
                  const SizedBox(height: 16),
                  _buildAboutSetting(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Implementation 1: ZapExpandableTile
  Widget _buildThemeSetting() {
    return ZapExpandableTile(
      isExpanded: _themeDropdownOpen,
      onExpandChanged: (expanded) {
        setState(() {
          _themeDropdownOpen = expanded;
          _aboutDropdownOpen = false;
        });
      },
      header: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.palette,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose your preferred theme',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theme Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildZaplabOption('Light Theme', Icons.light_mode, () {}),
          _buildZaplabOption('Dark Theme', Icons.dark_mode, () {}),
          _buildZaplabOption('System Default', Icons.settings_system_daydream, () {}),
        ],
      ),
      backgroundColor: Colors.grey[50]!,
      elevation: _themeDropdownOpen ? 4 : 2,
    );
  }



  // Profile Setting
  Widget _buildProfileSetting() {
    return Column(
      children: [
        _buildZaplabSettingCard(
          'Nostr Profile',
          'Manage your Nostr account and settings',
          Icons.person,
          () {
            setState(() {
              _profileDropdownOpen = !_profileDropdownOpen;
              _themeDropdownOpen = false;
              _aboutDropdownOpen = false;
            });
          },
          isExpanded: _profileDropdownOpen,
        ),
        AnimatedScale(
          scale: _profileDropdownOpen ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _profileDropdownOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nostr Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildZaplabOption('View Profile', Icons.person, () {
                    // Navigate to profile page
                    Navigator.of(context).pushNamed('/profile');
                  }),
                  _buildZaplabOption('Generate New Keypair', Icons.key, () {
                    // This would be handled in the profile page
                    Navigator.of(context).pushNamed('/profile');
                  }),
                  _buildZaplabOption('Import Keypair', Icons.download, () {
                    // This would be handled in the profile page
                    Navigator.of(context).pushNamed('/profile');
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Implementation 3: Scale Animation with Zaplab Styling
  Widget _buildAboutSetting() {
    return Column(
      children: [
        _buildZaplabSettingCard(
          'About',
          'App information and version',
          Icons.info,
          () {
            setState(() {
              _aboutDropdownOpen = !_aboutDropdownOpen;
              _themeDropdownOpen = false;
            });
          },
          isExpanded: _aboutDropdownOpen,
        ),
        AnimatedScale(
          scale: _aboutDropdownOpen ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _aboutDropdownOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildZaplabInfoRow('Version', '1.0.0'),
                  _buildZaplabInfoRow('Build', '2024.1.1'),
                  _buildZaplabInfoRow('Flutter', '3.3.0'),
                  _buildZaplabInfoRow('Rust Bridge', '2.11.1'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZaplabSettingCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap, {
    required bool isExpanded,
  }) {
    return Card(
      elevation: isExpanded ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZaplabOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZaplabSwitch(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // Handle switch change
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildZaplabInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}