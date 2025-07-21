use anyhow::Result;
use nostr_sdk::prelude::*;
use std::str::FromStr;

pub mod models;
pub mod services;

pub use models::*;
pub use services::*;

/// Generate a new Nostr keypair
pub fn generate_keypair() -> Result<KeypairResponse> {
    let keypair = Keys::generate();
    let public_key = keypair.public_key();
    let secret_key = keypair.secret_key()?;

    Ok(KeypairResponse {
        public_key: public_key.to_string(),
        secret_key: secret_key.to_string(),
        npub: public_key.to_bech32()?,
        nsec: secret_key.to_bech32()?,
    })
}

/// Sign a message with NIP-01
pub fn sign_message(secret_key: &str, message: &str) -> Result<SignedMessageResponse> {
    let secret_key = SecretKey::from_str(secret_key)?;
    let keypair = Keys::new(secret_key);

    // Create a text note event (kind 1)
    let event = EventBuilder::text_note(message, [])
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

/// Verify a signed message
pub fn verify_message(signed_message: &SignedMessageResponse) -> Result<bool> {
    let tags: Vec<Tag> = signed_message.tags.iter()
        .filter_map(|tag_vec| Tag::parse(tag_vec).ok())
        .collect();

    let event = Event::new(
        EventId::from_str(&signed_message.id)?,
        PublicKey::from_str(&signed_message.pubkey)?,
        Timestamp::from(signed_message.created_at),
        Kind::from(signed_message.kind as u16),
        tags,
        signed_message.content.clone(),
        Signature::from_str(&signed_message.sig)?,
    );

    Ok(event.verify().is_ok())
}

/// Create a profile metadata event (kind 0) using nostr-sdk's Metadata type
pub fn create_profile_event(
    secret_key: &str,
    name: &str,
    display_name: Option<&str>,
    about: Option<&str>,
    picture: Option<&str>,
    website: Option<&str>,
) -> Result<SignedMessageResponse> {
    let secret_key = SecretKey::from_str(secret_key)?;
    let keypair = Keys::new(secret_key);

    // Use nostr-sdk's Metadata type for better validation and consistency
    let mut metadata = Metadata::new();
    metadata = metadata.name(name);

    if let Some(display_name) = display_name {
        metadata = metadata.display_name(display_name);
    }
    if let Some(about) = about {
        metadata = metadata.about(about);
    }
    if let Some(picture) = picture {
        metadata = metadata.picture(Url::parse(picture)?);
    }
    if let Some(website) = website {
        metadata = metadata.website(Url::parse(website)?);
    }

    let event = EventBuilder::metadata(&metadata)
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

/// Parse a Nostr URI (npub, nsec, nevent, etc.)
pub fn parse_nostr_uri(uri: &str) -> Result<NostrUriResponse> {
    if uri.starts_with("npub1") {
        let public_key = PublicKey::from_bech32(uri)?;
        Ok(NostrUriResponse {
            uri_type: "npub".to_string(),
            data: public_key.to_string(),
            bech32: uri.to_string(),
        })
    } else if uri.starts_with("nsec1") {
        let secret_key = SecretKey::from_bech32(uri)?;
        Ok(NostrUriResponse {
            uri_type: "nsec".to_string(),
            data: secret_key.to_string(),
            bech32: uri.to_string(),
        })
    } else if uri.starts_with("nevent1") {
        // For now, just return the URI as-is
        Ok(NostrUriResponse {
            uri_type: "nevent".to_string(),
            data: uri.to_string(),
            bech32: uri.to_string(),
        })
    } else {
        Err(anyhow::anyhow!("Unsupported Nostr URI format"))
    }
}

/// Derive public key from secret key
pub fn derive_public_key(secret_key: &str) -> Result<KeypairResponse> {
    let secret_key = SecretKey::from_str(secret_key)?;
    let keypair = Keys::new(secret_key.clone());
    let public_key = keypair.public_key();

    Ok(KeypairResponse {
        public_key: public_key.to_string(),
        secret_key: secret_key.to_string(),
        npub: public_key.to_bech32()?,
        nsec: secret_key.to_bech32()?,
    })
}