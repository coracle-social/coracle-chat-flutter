import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frb_example_gallery/core/bridge/frb_generated.dart';
import 'package:frb_example_gallery/core/bridge/api/nostr.dart' as nostr_api;
import 'package:frb_example_gallery/core/bridge/nostr/models.dart';

/// Nostr authentication and profile state provider
class NostrProvider extends ChangeNotifier {
  static const String _keypairKey = 'nostr_keypair';
  static const String _profileKey = 'nostr_profile';

  AuthState _authState = AuthState.notAuthenticated;
  UserProfile? _currentProfile;
  bool _isLoading = false;
  String? _error;

  // Getters
  AuthState get authState => _authState;
  UserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  NostrProvider() {
    debugPrint('🚀 NostrProvider initialized');
    _loadStoredProfile();
  }

  /// Load stored profile from SharedPreferences
  Future<void> _loadStoredProfile() async {
    debugPrint('🔄 Loading stored profile...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final keypairJson = prefs.getString(_keypairKey);
      final profileJson = prefs.getString(_profileKey);

      debugPrint('📋 Keypair JSON found: ${keypairJson != null}');
      debugPrint('📋 Profile JSON found: ${profileJson != null}');

      if (keypairJson != null) {
        debugPrint('🔑 Parsing stored keypair...');
        final keypair = KeypairResponse.fromJson(jsonDecode(keypairJson));
        debugPrint('✅ Keypair parsed successfully');
        debugPrint('🔑 Public key: ${keypair.publicKey.isNotEmpty ? keypair.publicKey.substring(0, 10) + '...' : 'empty'}');
        debugPrint('🔑 nsec: ${keypair.nsec.isNotEmpty ? keypair.nsec.substring(0, 10) + '...' : 'empty'}');

        UserProfile? profile;

        if (profileJson != null) {
          debugPrint('👤 Parsing stored profile metadata...');
          final metadata = ProfileMetadata.fromJson(jsonDecode(profileJson));
          debugPrint('✅ Profile metadata parsed');
          debugPrint('👤 Name: ${metadata.name}');
          debugPrint('👤 Display name: ${metadata.displayName}');
          debugPrint('👤 About: ${metadata.about?.substring(0, 20)}...');

          profile = UserProfile(
            keypair: keypair,
            metadata: metadata,
            isLoggedIn: true,
          );
        } else {
          debugPrint('👤 No profile metadata found, creating basic profile');
          profile = UserProfile(
            keypair: keypair,
            metadata: null,
            isLoggedIn: true,
          );
        }

        _currentProfile = profile;
        _authState = AuthState.authenticated;
        debugPrint('✅ Profile loaded and authenticated');
        notifyListeners();
      } else {
        debugPrint('📋 No stored keypair found');
      }
    } catch (e) {
      debugPrint('❌ Error loading stored profile: $e');
    }
  }

  /// Generate a new keypair
  Future<void> generateKeypair() async {
    _setLoading(true);
    try {
      final keypair = await nostr_api.generateKeypair();
      final profile = UserProfile(
        keypair: keypair,
        metadata: null,
        isLoggedIn: false,
      );

      _currentProfile = profile;
      _authState = AuthState.authenticated;
      _error = null;

      // Store keypair
      await _storeKeypair(keypair);

      notifyListeners();
    } catch (e) {
      _error = 'Failed to generate keypair: $e';
      _authState = AuthState.error;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Import keypair from nsec
  Future<void> importKeypair(String nsec) async {
    debugPrint('🔑 Starting keypair import...');
    debugPrint('📝 Input nsec: ${nsec.substring(0, 10)}...');

    _setLoading(true);
    try {
      debugPrint('🔍 Parsing Nostr URI...');
      final uriResponse = await nostr_api.parseNostrUri(uri: nsec);
      debugPrint('✅ URI parsed successfully');
      debugPrint('📋 URI type: ${uriResponse.uriType}');
      debugPrint('📋 URI data length: ${uriResponse.data.length}');
      debugPrint('📋 URI bech32: ${uriResponse.bech32.substring(0, 10)}...');

      if (uriResponse.uriType != 'nsec') {
        throw Exception('Invalid nsec format');
      }

      debugPrint('🔑 Deriving public key from secret key...');
      // Derive the complete keypair from secret key
      final keypair = await nostr_api.derivePublicKey(secretKey: uriResponse.data);
      debugPrint('✅ Keypair created');
      debugPrint('🔑 Secret key length: ${keypair.secretKey.length}');
      debugPrint('🔑 nsec: ${keypair.nsec.isNotEmpty ? keypair.nsec.substring(0, 10) + '...' : 'empty'}');

      debugPrint('👤 Creating user profile...');
      final profile = UserProfile(
        keypair: keypair,
        metadata: null,
        isLoggedIn: false,
      );
      debugPrint('✅ Profile created');

      _currentProfile = profile;
      _authState = AuthState.authenticated;
      _error = null;
      debugPrint('✅ Profile state updated');

      // Store keypair
      debugPrint('💾 Storing keypair...');
      await _storeKeypair(keypair);
      debugPrint('✅ Keypair stored');

      notifyListeners();
      debugPrint('✅ Import completed successfully');
    } catch (e) {
      debugPrint('❌ Import failed: $e');
      _error = 'Failed to import keypair: $e';
      _authState = AuthState.error;
      notifyListeners();
    } finally {
      _setLoading(false);
      debugPrint('🏁 Import process finished');
    }
  }

  /// Sign a message
  Future<SignedMessageResponse?> signMessage(String message) async {
    if (_currentProfile == null) return null;

    try {
      final signedMessage = await nostr_api.signMessage(
        secretKey: _currentProfile!.keypair.secretKey,
        message: message,
      );
      return signedMessage;
    } catch (e) {
      _error = 'Failed to sign message: $e';
      notifyListeners();
      return null;
    }
  }

  /// Create profile metadata
  Future<void> createProfile({
    required String name,
    String? displayName,
    String? about,
    String? picture,
    String? website,
  }) async {
    if (_currentProfile == null) return;

    _setLoading(true);
    try {
      final signedEvent = await nostr_api.createProfileEvent(
        secretKey: _currentProfile!.keypair.secretKey,
        name: name,
        displayName: displayName,
        about: about,
        picture: picture,
        website: website,
      );

      // Parse the metadata from the signed event
      final metadata = await nostr_api.parseProfileMetadata(jsonContent: signedEvent.content);

      final updatedProfile = UserProfile(
        keypair: _currentProfile!.keypair,
        metadata: metadata,
        isLoggedIn: true,
      );

      _currentProfile = updatedProfile;
      _authState = AuthState.authenticated;
      _error = null;

      // Store profile
      await _storeProfile(metadata);

      notifyListeners();
    } catch (e) {
      _error = 'Failed to create profile: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keypairKey);
      await prefs.remove(_profileKey);

      _currentProfile = null;
      _authState = AuthState.notAuthenticated;
      _error = null;

      notifyListeners();
    } catch (e) {
      _error = 'Failed to logout: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Store keypair in SharedPreferences
  Future<void> _storeKeypair(KeypairResponse keypair) async {
    debugPrint('💾 Storing keypair in SharedPreferences...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final keypairJson = jsonEncode(keypair.toJson());
      debugPrint('📋 Keypair JSON length: ${keypairJson.length}');
      await prefs.setString(_keypairKey, keypairJson);
      debugPrint('✅ Keypair stored successfully');
    } catch (e) {
      debugPrint('❌ Failed to store keypair: $e');
      rethrow;
    }
  }

  /// Store profile in SharedPreferences
  Future<void> _storeProfile(ProfileMetadata metadata) async {
    debugPrint('💾 Storing profile metadata in SharedPreferences...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(metadata.toJson());
      debugPrint('📋 Profile JSON length: ${profileJson.length}');
      await prefs.setString(_profileKey, profileJson);
      debugPrint('✅ Profile metadata stored successfully');
    } catch (e) {
      debugPrint('❌ Failed to store profile metadata: $e');
      rethrow;
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _authState = AuthState.loading;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}