use crate::nostr::models::*;
use anyhow::Result;
use serde_json::Value;
use nostr_sdk::prelude::*;
use std::str::FromStr;

/// Parse profile metadata from JSON string using nostr-sdk's Metadata type
pub fn parse_profile_metadata(json_content: &str) -> Result<ProfileMetadata> {
    // First try to parse using nostr-sdk's built-in Metadata type
    let metadata = Metadata::from_json(json_content)?;

    Ok(ProfileMetadata {
        name: metadata.name.unwrap_or_default(),
        display_name: metadata.display_name,
        about: metadata.about,
        picture: metadata.picture.map(|url| url.to_string()),
        website: metadata.website.map(|url| url.to_string()),
        nip05: metadata.nip05,
        lud16: metadata.lud16,
    })
}

/// Alternative: Direct Serde deserialization for more control
pub fn parse_profile_metadata_direct(json_content: &str) -> Result<ProfileMetadata> {
    let metadata: ProfileMetadata = serde_json::from_str(json_content)?;
    Ok(metadata)
}

/// Parse profile metadata with fallback error handling
pub fn parse_profile_metadata_with_fallback(json_content: &str) -> Result<ProfileMetadata> {
    // Try nostr-sdk's Metadata first
    match Metadata::from_json(json_content) {
        Ok(metadata) => {
            Ok(ProfileMetadata {
                name: metadata.name.unwrap_or_default(),
                display_name: metadata.display_name,
                about: metadata.about,
                picture: metadata.picture.map(|url| url.to_string()),
                website: metadata.website.map(|url| url.to_string()),
                nip05: metadata.nip05,
                lud16: metadata.lud16,
            })
        }
        Err(_) => {
            // Fallback to manual parsing for malformed JSON
            let value: Value = serde_json::from_str(json_content)
                .map_err(|e| anyhow::anyhow!("Invalid JSON: {}", e))?;

            let obj = value.as_object()
                .ok_or_else(|| anyhow::anyhow!("Expected JSON object"))?;

            Ok(ProfileMetadata {
                name: obj.get("name")
                    .and_then(|v| v.as_str())
                    .unwrap_or("")
                    .to_string(),
                display_name: obj.get("display_name")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
                about: obj.get("about")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
                picture: obj.get("picture")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
                website: obj.get("website")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
                nip05: obj.get("nip05")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
                lud16: obj.get("lud16")
                    .and_then(|v| v.as_str())
                    .map(|s| s.to_string()),
            })
        }
    }
}

/// Validate Nostr URI format
pub fn validate_nostr_uri(uri: &str) -> bool {
    uri.starts_with("npub1") ||
    uri.starts_with("nsec1") ||
    uri.starts_with("nevent1") ||
    uri.starts_with("naddr1") ||
    uri.starts_with("note1")
}

/// Extract public key from various formats
pub fn extract_public_key(input: &str) -> Result<String> {
    if input.starts_with("npub1") {
        // Already in bech32 format
        Ok(input.to_string())
    } else if input.len() == 64 && input.chars().all(|c| c.is_ascii_hexdigit()) {
        // Hex format - convert to bech32
        let public_key = PublicKey::from_str(input)?;
        Ok(public_key.to_bech32()?)
    } else {
        Err(anyhow::anyhow!("Invalid public key format"))
    }
}

/// Create a simple text note event
pub fn create_text_note(secret_key: &str, content: &str, _tags: Vec<Vec<String>>) -> Result<SignedMessageResponse> {
    let secret_key = SecretKey::from_str(secret_key)?;
    let keypair = Keys::new(secret_key);

    let event = EventBuilder::text_note(content, [])
        .to_event(&keypair)?;

    Ok(SignedMessageResponse {
        id: event.id.to_string(),
        pubkey: event.pubkey.to_string(),
        created_at: event.created_at.as_u64(),
        kind: event.kind.as_u16() as u64,
        tags: event.tags.iter().map(|tag| tag.as_vec().to_vec()).collect(),
        content: event.content.clone(),
        sig: event.sig.to_string(),
    })
}

/// Generate a random keypair for testing
pub fn generate_test_keypair() -> Result<KeypairResponse> {
    crate::nostr::generate_keypair()
}