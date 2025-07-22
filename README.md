# Flutter with Rust Bridge vs React Native

## Nostr Tools vs Welshman

The preexisting rust Nostr tools require far more manual implementation than utilizing Welshman. Nostr-sdk is a higher level library but my implementation of NIP01 signing was still more involved, you also have to handle relays on your own.

**Nostr-sdk is one of the more high level management tools. AND IT DOES NOT COMPILE TO WASM.**

Most of the Nostr based tools use Tokio, an async multi-threaded library that doesn't work for WASM. This means we have to rely on lower level Nostr libraries like nostr, with much less immediate tooling and possible unreliable updates etc. There are also many other common rust crates for native async networking, async-std etc. which would not compile to WASM. We can either reduce functionality to maintain a single non-diverging codebase or attempt our own fills or patches to these functions(time intensive).

**Examples of WASM limitations:**
- An example is relay networking. The pre-built solutions don't compile to WASM so you'd need to implement relay networking in JavaScript and call Rust via wasm_bindgen or proxy via Dart.
- There are also limited cryptography apis available to the web version. There are JS libraries like nostr-tools, but we may have to build custom web solutions or separate some of our signing/relay logic to Dart instead of all logic implemented in Rust.

---

## MLS

I think this is the core advantage to the flutter with rust_bridge approach. This is very difficult and time intensive to reproduce with Typescript in a React Native project. My attempts at using the Whitenoise repo to test MLS have been blocked by a transitive SQLite dependency. It fails to reconcile buildingg for iOS while on a mac(may be caused by an intel mac). Provided that can be fixed, MLS would be a major advantage over much less secure messaging.

### Option: Custom WASM Nostr Core

Build your own Rust → WASM crypto/signing module for Web, use FRB for mobile.

| Platform | Implementation |
|----------|----------------|
| **Mobile** | Rust + FRB |
| **Web** | WASM build of Rust Nostr core via wasm-bindgen |
| **Shared logic** | Define a portable Rust interface (e.g. sign_event, validate_event) |
| **Dart ↔ WASM** | JS interop (package:js) for Web only |

> **Note:** WASM doesn't support everything — avoid native threads, sockets, or file I/O

---

## Performance

### ✅ Pros
- **Native performance** for CPU-intensive tasks by offloading to Rust code
- **Flutter's rendering engine** is highly optimized, leading to smooth UI and animations
- **Rust's zero-cost abstractions** and memory safety can lead to very efficient background processing
- **Reduced JavaScript bridge overhead** compared to React Native

### ❌ Cons
- **Integrating Rust adds complexity**, especially debugging across Dart and Rust boundaries
- **Large build times** when changing rust code, slow to see active changes. Hot reloading is only for the UI changes
- **FFI calls** between Dart and Rust can introduce latency if overused or not carefully designed

---

## Web

### Flutter with Rust Bridge

#### ✅ Pros
- **Flutter Web targets** the same UI codebase; consistent look and feel across platforms
- **Rust compiled to WASM** can be used in web for performance-critical logic

#### ❌ Cons
- **WASM + Dart interop** is still evolving and adds complexity
- **Still some separate web code**
- **Flutter Web is less mature** compared to React Native Web in ecosystem support

---

## Development Experience

### ✅ Pros
- **Single codebase for UI** with performant native extensions
- **Rust tooling** (cargo, crates) is mature and reliable
- **Good IDE support** for Dart and Rust separately

### ❌ Cons
- **Tooling for Flutter + Rust Bridge** requires setup and can be tricky
- **Hot reload for Dart** is fast, but changes in Rust require full rebuilds
- **Cross-language debugging** can be complicated

---

## Real-World Example

When developing my NIP-01 solution, I had many problems with the generated binding files, mostly missing certain states and not knowing that certain functions will not generate if not used in any of the API functions. Errors like this will become less common as I develop more with this setup but it takes a long time to realize these errors exist in the first place.

---

## If we proceed with full web compatability, we would first...

### **Start with the nostr crate (the core):**
- **Pure Rust** - No external dependencies
- **No runtime** - Lightweight and WASM-friendly
- **Fully supports** creating/parsing keys/events/tags
- **You can build your own WebSocket layer** (e.g., using gloo-net or JS interop)

### **Add WebSocket client support using a WASM-compatible library:**
- **gloo-net** - Rust-native networking for WASM
- **web-sys::WebSocket** - Direct WebSocket API access
- **Or handle networking in JS** and use wasm-bindgen/FFI to send into Rust

---

## WASM Compatible Tooling

| Crate | WASM Compatible? | Notes |
|-------|------------------|-------|
| **nostr** | ✅ Mostly | Low-level, minimal deps. No networking or runtime baked in. Good starting point. |
| **nostr-types** | ✅ | Pure data structures and helpers. WASM-safe. |
| **nostr-tools** | ✅ | Focused on event signing, parsing, keys, etc. Similar to JS nostr-tools. |
| **nostr-primitives** | ✅ | Lightweight building blocks; suitable for WASM. |
| **rusted-nostr-tools** | ✅ | Utility functions for keys, events. WASM-compatible, but limited scope. |

---

## Alternative Approach: Hybrid Architecture

### **Or...** Doing all networking and relay connections in Dart/JS

**Letting Rust (via WASM) handle:**
- **Event construction**
- **Key management**
- **Signing**
- **Parsing/validation**
