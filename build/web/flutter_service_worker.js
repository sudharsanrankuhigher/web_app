'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "66e4303cccca28aa0fd1a8ee84c6f13a",
"assets/AssetManifest.bin.json": "8db555c7a85ece75003c877900ef5228",
"assets/AssetManifest.json": "9ca6af5b10bb50f1cc3f055939dd7356",
"assets/assets/fonts/Inter_Bold.ttf": "7ef6f6d68c7fedc103180f2254985e8c",
"assets/assets/fonts/Inter_Medium.ttf": "8540f35bf8acd509b9ce356f1111e983",
"assets/assets/fonts/Inter_Regular.ttf": "37dcabff629c3690303739be2e0b3524",
"assets/assets/fonts/Inter_SemiBold.ttf": "e5532d993e2de30fa92422df0a8849dd",
"assets/assets/images/accepted.svg": "647ccd0938d9c753a7189c2c5e6fc735",
"assets/assets/images/cancelled.svg": "5ca369406edd8571011687a833d55ef7",
"assets/assets/images/city.svg": "c25e9d7ba36625933a72cb4adee82f9c",
"assets/assets/images/client_revenue.svg": "b7f545bfc5f2a0a86fed31a3aaedffc4",
"assets/assets/images/comission.svg": "29deb6be6b71cd85180f58694347c50c",
"assets/assets/images/complete-pending-list.svg": "96d56b83c98cb62499ba8707ef93376e",
"assets/assets/images/dash_board.svg": "442b1aacda1d3b76af4abb03b40f7a55",
"assets/assets/images/filter.jpg": "a55db38ca2b9a73cd6443b9e7ae771be",
"assets/assets/images/filter.svg": "1f1fb633ad27f409f8e0eab551a36154",
"assets/assets/images/influencer_count.svg": "7612698ca125cbf8a5d15f332b3089f0",
"assets/assets/images/influencer_dashboard.svg": "83df85fb0a68a8a90d85aa15489fcba9",
"assets/assets/images/logo.png": "f5a0cf69288d47a5264a6cdbb979acc9",
"assets/assets/images/pay.svg": "5ca851022ead7431c77d1fb3d655baea",
"assets/assets/images/pending.svg": "dccce8551a91e84a82e719cd923e99d3",
"assets/assets/images/plans_dashboard.svg": "9826c353cf3ef17d2382497aacd27a41",
"assets/assets/images/promotes_proj_dashboard.svg": "1efcb70ac2cbf98e07b1f1692f35daf2",
"assets/assets/images/promote_revenue.svg": "d5057ed66a92e338ebc6167c714f6f0c",
"assets/assets/images/promote_vector.svg": "e87ea36dbb55c9428a113b6b50ca9c0e",
"assets/assets/images/rejected.svg": "83d04f2824e7bca852a117a9a8c757ce",
"assets/assets/images/requested.svg": "66c5916143f03a79edb04ca41fab6eb2",
"assets/assets/images/requests_dashboard.svg": "6bd6f5cc11b36f15ced359e1e9938a5c",
"assets/assets/images/service_dashboard.svg": "eaece3dda0110ef133a3625b879906e7",
"assets/assets/images/sub-admin_dashboard.svg": "87f678b9a3b54411a7db34ec6563c837",
"assets/assets/images/support_dashboard.svg": "7d0c08c348272768395ca624f00cce9a",
"assets/assets/images/total_client_project.svg": "701458c3e361763591fa9806df2c58f4",
"assets/assets/images/user.svg": "69cac964530cf3d286e7fa71bfa05b31",
"assets/assets/images/verified.svg": "87bf84be1eb956d03bd26a82a76e07f9",
"assets/assets/json/cities.json": "4d09bd8fd95cccac4efdfa7875c4a7e5",
"assets/FontManifest.json": "64661665bff00837a4bab1205ce3968a",
"assets/fonts/MaterialIcons-Regular.otf": "1877f696fa3d0bb2a3aae264d8c45144",
"assets/NOTICES": "9b2a5170eb44fd4248a9a52d06271830",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "f5a0cf69288d47a5264a6cdbb979acc9",
"favicon2.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "84fb02bef8e615802f8776b264a3e975",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "81d981f146bf04cb7a8f10f4fb8c6334",
"/": "81d981f146bf04cb7a8f10f4fb8c6334",
"main.dart.js": "117530dae1f1b52364411dfa87c4789c",
"manifest.json": "bae248d31e4f8733acb2f353550226d3",
"version.json": "87333eab59e605beb0f0c38d7de4ec79"};
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
