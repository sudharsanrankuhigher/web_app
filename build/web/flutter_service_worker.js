'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "dfb611d5ebf4be064468c28cd888bb2e",
"assets/AssetManifest.bin.json": "d562569377c5fc54561baa3e740e589e",
"assets/assets/fonts/Inter_Bold.ttf": "7ef6f6d68c7fedc103180f2254985e8c",
"assets/assets/fonts/Inter_Medium.ttf": "8540f35bf8acd509b9ce356f1111e983",
"assets/assets/fonts/Inter_Regular.ttf": "37dcabff629c3690303739be2e0b3524",
"assets/assets/fonts/Inter_SemiBold.ttf": "e5532d993e2de30fa92422df0a8849dd",
"assets/assets/images/accepted.svg": "647ccd0938d9c753a7189c2c5e6fc735",
"assets/assets/images/add_platform.svg": "0c30e6ad635d7173ceb9a822dd03cf1a",
"assets/assets/images/arrow-down.svg": "f5562e54edf2080852af8406192292f8",
"assets/assets/images/arrow-up.svg": "8d19228650a2c83201d888d604ec31fd",
"assets/assets/images/assigned.svg": "902efade8231d0def599464fb758a74c",
"assets/assets/images/cancelled.svg": "5ca369406edd8571011687a833d55ef7",
"assets/assets/images/city.svg": "c25e9d7ba36625933a72cb4adee82f9c",
"assets/assets/images/client_revenue.svg": "b7f545bfc5f2a0a86fed31a3aaedffc4",
"assets/assets/images/comission.svg": "29deb6be6b71cd85180f58694347c50c",
"assets/assets/images/complete-pending-list.svg": "96d56b83c98cb62499ba8707ef93376e",
"assets/assets/images/dash_board.svg": "442b1aacda1d3b76af4abb03b40f7a55",
"assets/assets/images/doller.svg": "5465af2ffe030c76115cf06e1f6e682c",
"assets/assets/images/filter.jpg": "a55db38ca2b9a73cd6443b9e7ae771be",
"assets/assets/images/filter.svg": "1f1fb633ad27f409f8e0eab551a36154",
"assets/assets/images/influencer_count.svg": "7612698ca125cbf8a5d15f332b3089f0",
"assets/assets/images/influencer_dashboard.svg": "83df85fb0a68a8a90d85aa15489fcba9",
"assets/assets/images/logo.png": "f5a0cf69288d47a5264a6cdbb979acc9",
"assets/assets/images/partner_companies.svg": "ff31e5ccc0aa040ce58a82e347b6c9a2",
"assets/assets/images/pay.svg": "5ca851022ead7431c77d1fb3d655baea",
"assets/assets/images/payment_processed.svg": "71e56000ad1965a54fdbc745800c402c",
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
"assets/assets/json/data.json": "f5f8f65fcf137ebab9ff918b910a6186",
"assets/FontManifest.json": "64661665bff00837a4bab1205ce3968a",
"assets/fonts/MaterialIcons-Regular.otf": "4fc95551a3c748d350acb0e19ee64ec8",
"assets/NOTICES": "3072360395141126664c5c182426a6cd",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "f5a0cf69288d47a5264a6cdbb979acc9",
"favicon2.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "7c0a54a0bf3138479d6218c35c109834",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "81d981f146bf04cb7a8f10f4fb8c6334",
"/": "81d981f146bf04cb7a8f10f4fb8c6334",
"main.dart.js": "12fd7e1e4fb34f18e7d1c89d0d8c463f",
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
