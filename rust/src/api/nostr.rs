use crate::nostr::*;
use anyhow::Result;

/// Generate a new Nostr keypair
pub fn generate_keypair() -> Result<KeypairResponse> {
    crate::nostr::generate_keypair()
}

/// Sign a message with NIP-01
pub fn sign_message(secret_key: String, message: String) -> Result<SignedMessageResponse> {
    crate::nostr::sign_message(&secret_key, &message)
}

/// Verify a signed message
pub fn verify_message(signed_message: SignedMessageResponse) -> Result<bool> {
    crate::nostr::verify_message(&signed_message)
}

/// Create a profile metadata event (kind 0)
pub fn create_profile_event(
    secret_key: String,
    name: String,
    display_name: Option<String>,
    about: Option<String>,
    picture: Option<String>,
    website: Option<String>,
) -> Result<SignedMessageResponse> {
    crate::nostr::create_profile_event(
        &secret_key,
        &name,
        display_name.as_deref(),
        about.as_deref(),
        picture.as_deref(),
        website.as_deref(),
    )
}

/// Parse a Nostr URI (npub, nsec, nevent, etc.)
pub fn parse_nostr_uri(uri: String) -> Result<NostrUriResponse> {
    crate::nostr::parse_nostr_uri(&uri)
}

/// Parse profile metadata from JSON string
pub fn parse_profile_metadata(json_content: String) -> Result<ProfileMetadata> {
    crate::nostr::services::parse_profile_metadata(&json_content)
}

/// Parse profile metadata with fallback error handling
pub fn parse_profile_metadata_with_fallback(json_content: String) -> Result<ProfileMetadata> {
    crate::nostr::services::parse_profile_metadata_with_fallback(&json_content)
}

/// Validate Nostr URI format
pub fn validate_nostr_uri(uri: String) -> bool {
    crate::nostr::services::validate_nostr_uri(&uri)
}

/// Extract public key from various formats
pub fn extract_public_key(input: String) -> Result<String> {
    crate::nostr::services::extract_public_key(&input)
}

/// Create a simple text note event
pub fn create_text_note(secret_key: String, content: String, tags: Vec<Vec<String>>) -> Result<SignedMessageResponse> {
    crate::nostr::services::create_text_note(&secret_key, &content, tags)
}

/// Derive public key from secret key
pub fn derive_public_key(secret_key: String) -> Result<KeypairResponse> {
    crate::nostr::derive_public_key(&secret_key)
}