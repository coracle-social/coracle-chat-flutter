pub mod api;
mod frb_generated;
pub mod ignore_me; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
pub mod old;
pub mod nostr;

// Re-export simple functions for Flutter Rust Bridge
pub use api::simple::*;
pub use api::nostr::*;
