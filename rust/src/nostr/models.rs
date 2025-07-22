use serde::{Deserialize, Serialize};

/// Response for generated keypair
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KeypairResponse {
    pub public_key: String,
    pub secret_key: String,
    pub npub: String,
    pub nsec: String,
}

/// Response for signed message/event
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SignedMessageResponse {
    pub id: String,
    pub pubkey: String,
    pub created_at: u64,
    pub kind: u64,
    pub tags: Vec<Vec<String>>,
    pub content: String,
    pub sig: String,
}

/// Response for parsed Nostr URI
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NostrUriResponse {
    pub uri_type: String,
    pub data: String,
    pub bech32: String,
}

/// Profile metadata structure
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProfileMetadata {
    pub name: String,
    pub display_name: Option<String>,
    pub about: Option<String>,
    pub picture: Option<String>,
    pub website: Option<String>,
    pub nip05: Option<String>,
    pub lud16: Option<String>,
}

/// User profile with keypair and metadata
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserProfile {
    pub keypair: KeypairResponse,
    pub metadata: Option<ProfileMetadata>,
    pub is_logged_in: bool,
}

/// Authentication state
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum AuthState {
    NotAuthenticated,
    Authenticated(UserProfile),
    Loading,
    Error(String),
}