import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:frb_example_gallery/core/state/nostr_provider.dart';
import 'package:frb_example_gallery/core/bridge/frb_generated.dart';
import 'package:frb_example_gallery/core/bridge/nostr/models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _pictureController = TextEditingController();
  final _websiteController = TextEditingController();
  final _nsecController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _aboutController.dispose();
    _pictureController.dispose();
    _websiteController.dispose();
    _nsecController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nostr Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<NostrProvider>(
        builder: (context, nostrProvider, child) {
          if (nostrProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (nostrProvider.error != null) {
            return _buildErrorView(nostrProvider);
          }

          if (nostrProvider.isAuthenticated && nostrProvider.currentProfile != null) {
            return _buildProfileView(nostrProvider);
          }

          return _buildAuthView(nostrProvider);
        },
      ),
    );
  }

  Widget _buildErrorView(NostrProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: ${provider.error}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              provider.clearError();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthView(NostrProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Nostr Authentication',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Generate new keypair
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Generate a new Nostr keypair for this app.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.generateKeypair(),
                    child: const Text('Generate Keypair'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Import existing keypair
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Import Existing Account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Import your existing Nostr account using nsec.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nsecController,
                    decoration: const InputDecoration(
                      labelText: 'nsec (secret key)',
                      border: OutlineInputBorder(),
                      hintText: 'nsec1...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_nsecController.text.isNotEmpty) {
                        provider.importKeypair(_nsecController.text);
                      }
                    },
                    child: const Text('Import Keypair'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(NostrProvider provider) {
    final profile = provider.currentProfile!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Text(
                      profile.metadata?.displayName?.substring(0, 1).toUpperCase() ??
                      profile.metadata?.name.substring(0, 1).toUpperCase() ??
                      'N',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.metadata?.displayName ?? profile.metadata?.name ?? 'Anonymous',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (profile.metadata?.about != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      profile.metadata!.about!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Keypair info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Public key
                  _buildCopyableField(
                    'Public Key (npub)',
                    profile.keypair.npub,
                    'Copy npub',
                  ),

                  const SizedBox(height: 8),

                  // Secret key (hidden by default)
                  _buildSecretKeyField(profile.keypair.nsec),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Profile editing
          if (profile.metadata == null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complete Your Profile',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildProfileForm(provider),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Message signing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Message',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildMessageSigningForm(provider),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Logout button
          ElevatedButton(
            onPressed: () => provider.logout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableField(String label, String value, String copyText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
              IconButton(
                onPressed: () {
                  FlutterClipboard.copy(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecretKeyField(String nsec) {
    bool isVisible = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Secret Key (nsec)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isVisible ? nsec : '•' * 20,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                  ),
                  IconButton(
                    onPressed: () {
                      FlutterClipboard.copy(nsec);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Secret key copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '⚠️ Keep your secret key safe! Never share it with anyone.',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileForm(NostrProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _displayNameController,
            decoration: const InputDecoration(
              labelText: 'Display Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _aboutController,
            decoration: const InputDecoration(
              labelText: 'About',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pictureController,
            decoration: const InputDecoration(
              labelText: 'Profile Picture URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Website',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                provider.createProfile(
                  name: _nameController.text,
                  displayName: _displayNameController.text.isNotEmpty
                      ? _displayNameController.text
                      : null,
                  about: _aboutController.text.isNotEmpty
                      ? _aboutController.text
                      : null,
                  picture: _pictureController.text.isNotEmpty
                      ? _pictureController.text
                      : null,
                  website: _websiteController.text.isNotEmpty
                      ? _websiteController.text
                      : null,
                );
              }
            },
            child: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSigningForm(NostrProvider provider) {
    return Column(
      children: [
        TextField(
          controller: _messageController,
          decoration: const InputDecoration(
            labelText: 'Message to sign',
            border: OutlineInputBorder(),
            hintText: 'Enter a message to sign with your Nostr key...',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            if (_messageController.text.isNotEmpty) {
              final signedMessage = await provider.signMessage(_messageController.text);
              if (signedMessage != null) {
                if (mounted) {
                  _showSignedMessageDialog(signedMessage);
                }
              }
            }
          },
          child: const Text('Sign Message'),
        ),
      ],
    );
  }

  void _showSignedMessageDialog(SignedMessageResponse signedMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signed Message'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCopyableField('Event ID', signedMessage.id, 'Copy ID'),
              const SizedBox(height: 8),
              _buildCopyableField('Signature', signedMessage.sig, 'Copy Signature'),
              const SizedBox(height: 8),
              const Text('Content:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(signedMessage.content),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}