'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "9b4ebfef3a7c1da26ff81eaeee10979a",
"guide.txt": "c1e5ada5a323f3f21d037c03bf4a79d1",
"version.json": "f089d090d5ca2c751c10ec5f7ebb73b4",
"index.html": "b6bd42be45cabae854e099d7a7476fcc",
"/": "b6bd42be45cabae854e099d7a7476fcc",
"main.dart.js": "d4f6f540d21145531e2269b7c7d7cb7c",
"enable-threads.js": "a909fc26a030387ac54820b91caebd8b",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "ffdf4e7c1718c6492ed5f1b6ec338db7",
"assets/AssetManifest.json": "52ea5c52b9a30d4b98340ef82bbd9ecc",
"assets/NOTICES": "26b6b021fda1d4215b025844a46fe2aa",
"assets/FontManifest.json": "2febebc8da4746198d1201c5642f68a5",
"assets/AssetManifest.bin.json": "c5d021f971fda1738dbc87a8f8244a4a",
"assets/packages/zaplab_design/assets/emoji/joke.png": "cd19eff787a1e90f682306799ffb35ec",
"assets/packages/zaplab_design/assets/emoji/event.png": "ba16f586be301a85bcfa7e97c48d3700",
"assets/packages/zaplab_design/assets/emoji/forum.png": "de5f55c7ae4fe4cabaffb838bcc9ceb0",
"assets/packages/zaplab_design/assets/emoji/blossom.png": "dcb108ec603b71b0a187731a49b8a8b8",
"assets/packages/zaplab_design/assets/emoji/podcast.png": "459595228a1e51bb2410021df7fc0316",
"assets/packages/zaplab_design/assets/emoji/book.png": "76af315b3b39dc2d5130d44b9f5afeb7",
"assets/packages/zaplab_design/assets/emoji/app.png": "06b94553338b8ffc326255e001da786d",
"assets/packages/zaplab_design/assets/emoji/note.png": "2be8b4e99424038b8e5d47d349cf4d80",
"assets/packages/zaplab_design/assets/emoji/wiki.png": "466b47cce998d0825a7da510861ead08",
"assets/packages/zaplab_design/assets/emoji/mail.png": "9f0485dc1f2f2db40498f4062dba434d",
"assets/packages/zaplab_design/assets/emoji/group.png": "e969cacffe8001e757f2d48fbf420c38",
"assets/packages/zaplab_design/assets/emoji/relay.png": "55391c89a72388d6f3af5546060e9f7e",
"assets/packages/zaplab_design/assets/emoji/product.png": "80d74aab058b66a244bbe15abce6beb4",
"assets/packages/zaplab_design/assets/emoji/doc.png": "7f0578e26392a78d9b05f7e689ab6dae",
"assets/packages/zaplab_design/assets/emoji/supporter.png": "036b135fdf533e9dee3296baba881eca",
"assets/packages/zaplab_design/assets/emoji/service.png": "801189b51a1dabcebac8c204199c4f73",
"assets/packages/zaplab_design/assets/emoji/file.png": "93c49408893d35ec6e5da906352abec3",
"assets/packages/zaplab_design/assets/emoji/label.png": "198e99625f306f48041cea24b3b7b5ce",
"assets/packages/zaplab_design/assets/emoji/community.png": "748548ef723c3e0c996f3992ff84fb75",
"assets/packages/zaplab_design/assets/emoji/white_board.png": "8d08efcddfc317709dc49be09bd40136",
"assets/packages/zaplab_design/assets/emoji/unknown.png": "95f98f449653259b61e533792fdb2e1e",
"assets/packages/zaplab_design/assets/emoji/music.png": "486979edb62e4f5a587b8b4f771ebcb0",
"assets/packages/zaplab_design/assets/emoji/highlight.png": "3ed8b4ac7e86ae7170ad01be1b4aebe5",
"assets/packages/zaplab_design/assets/emoji/reply.png": "c7e017abfc597eac04fe7e3413288729",
"assets/packages/zaplab_design/assets/emoji/section.png": "b68bd2fec149d0aef0ace89a2d3592a2",
"assets/packages/zaplab_design/assets/emoji/task.png": "dcd30a6374dbe38153a42557d5fc8e9b",
"assets/packages/zaplab_design/assets/emoji/graph.png": "783eaa16bf3f6dc379bf42479b3ead88",
"assets/packages/zaplab_design/assets/emoji/poll.png": "be8ad6c39e59626ddf49e01bdb4f5d8f",
"assets/packages/zaplab_design/assets/emoji/nostr.png": "3f4f590133ab31d0f1bbe147f7f2cd90",
"assets/packages/zaplab_design/assets/emoji/app_pack.png": "6845c59b2435644fbb925de77bb8eb81",
"assets/packages/zaplab_design/assets/emoji/album.png": "31db3b8240b494aa3b2ae602ee5fecdb",
"assets/packages/zaplab_design/assets/emoji/stack.png": "461d6a1eff0efcb59e533e5c8e786824",
"assets/packages/zaplab_design/assets/emoji/video.png": "3242ca9da13307bc507aa24d65d4802b",
"assets/packages/zaplab_design/assets/emoji/zap.png": "5f57821b9992889157b4a186992975ba",
"assets/packages/zaplab_design/assets/emoji/profile.png": "ffe5bdb6caacfd630e72d39b03330137",
"assets/packages/zaplab_design/assets/emoji/thread.png": "a9bae8768b2c6d3f4a63125779cbd26c",
"assets/packages/zaplab_design/assets/emoji/form.png": "72c2df42f2ee266d0692f2cf79d5633a",
"assets/packages/zaplab_design/assets/emoji/repo.png": "07c13f4c5771826c68df9c6aaa3a4ced",
"assets/packages/zaplab_design/assets/emoji/job.png": "5ff9923ae562c6015434b4539932dc84",
"assets/packages/zaplab_design/assets/emoji/work-out.png": "aa922edaf76fe22acf8b260d509adfd2",
"assets/packages/zaplab_design/assets/emoji/chat.png": "dfdb615b064ebc60b4bdc58a1a23f9ac",
"assets/packages/zaplab_design/assets/emoji/article.png": "c617e2b317de0145cb0537cc6445465c",
"assets/packages/zaplab_design/assets/emoji/story.png": "bdb23ac8fc171b1e84052c9b862508dd",
"assets/packages/zaplab_design/assets/emoji/badge.png": "7e759654f7b7f870a62f85d24f021a54",
"assets/packages/zaplab_design/assets/emoji/emoji_pack.png": "49249a5e8349bfc11ff548db538a9f4b",
"assets/packages/zaplab_design/assets/emoji/welcome.png": "d5854feb720d221d84ef96ffcaf3427c",
"assets/packages/zaplab_design/assets/emoji/live.png": "f06a69a035a8cdfb0563e7a33bf9cf32",
"assets/packages/zaplab_design/assets/fonts/Courier-Prime.ttf": "c94e49765ec47b72f1cec8a8c4ef14c5",
"assets/packages/zaplab_design/assets/fonts/Lora%255Bwght%255D.ttf": "b1ea741562de4905e689bf2b10fb3ba3",
"assets/packages/zaplab_design/assets/fonts/Zaplab-Icons.ttf": "d1e31c84535ce17b93bbd6c55ea08b67",
"assets/packages/zaplab_design/assets/fonts/InterVariable.ttf": "7c80433dfb0d6e565327d9beeb774bac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "43e5a69df85aa28eb32afb6b1ddb9813",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"pkg/rust_lib_bg.wasm": "48a2119e812184177b35894a150c003a",
"pkg/package.json": "040b0248b7ac09709a5aeca4f0c9a203",
"pkg/rust_lib.js": "bc6ebbeb5c81e4680b83b783b7f74bbb",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
