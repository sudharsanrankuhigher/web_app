'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c07081af22c955c1739ad0af66843c50",
"assets/AssetManifest.bin.json": "da832b43a8b27c9c3e6e57c54cbff9a8",
"assets/AssetManifest.json": "9c1a37a5f509351d12fc0de46035687d",
"assets/assets/fonts/Inter_Bold.ttf": "7ef6f6d68c7fedc103180f2254985e8c",
"assets/assets/fonts/Inter_Medium.ttf": "8540f35bf8acd509b9ce356f1111e983",
"assets/assets/fonts/Inter_Regular.ttf": "37dcabff629c3690303739be2e0b3524",
"assets/assets/fonts/Inter_SemiBold.ttf": "e5532d993e2de30fa92422df0a8849dd",
"assets/assets/images/accepted.png": "80ca94cce90ab256a9eeabbd8590507f",
"assets/assets/images/cancelled.png": "72b45a45e954f485b702f39b4d05bc2f",
"assets/assets/images/city.png": "21da63bb5ac03c0123547513c3df359c",
"assets/assets/images/client_revenue.png": "c3ce3e009c8cbaae64a482ec93e2a055",
"assets/assets/images/comission.png": "3b41c7a23563a97eaf5467f89c9f0d6b",
"assets/assets/images/complete-pending-list.png": "870bdf5b594d79b25fdd7b83b38c5aac",
"assets/assets/images/dash_board.png": "50db22572e03ad7a6b881bcf6e13c617",
"assets/assets/images/filter.png": "175aaf11376b81ce279140e09f77d5bd",
"assets/assets/images/influencer_count.png": "7f3d073c1415f9eb650e9599a216a343",
"assets/assets/images/influencer_dashboard.png": "be112921afba0b30c14474d553515e6a",
"assets/assets/images/logo.png": "f5a0cf69288d47a5264a6cdbb979acc9",
"assets/assets/images/pay.png": "e20d132fa05382ab1d90c08878520df7",
"assets/assets/images/pending.png": "826643f06e6f99b4bac0327faf08e29f",
"assets/assets/images/plans_dashboard.png": "f05e66412421bf4297e15196fe7987d0",
"assets/assets/images/promotes_proj_dashboard.png": "b7e9a3f88cf48aa45539a81bc72f54f1",
"assets/assets/images/promote_revenue.png": "d127cc9f30da6a10647dacd51a9df4a8",
"assets/assets/images/promote_vector.png": "1270b5d3fd2dbbf833e81c2cf4d304ac",
"assets/assets/images/rejected.png": "0a35fd91342a4fd3b55c58424d0df880",
"assets/assets/images/requested.png": "8ef63ba70f78abc57240f5e066b6ac71",
"assets/assets/images/requests_dashboard.png": "2d5eab1596185b2ab7e744bf4344c3c2",
"assets/assets/images/service_dashboard.png": "c51d1f4fa8b7ed4fdfbd9e6947f95b20",
"assets/assets/images/sub-admin_dashboard.png": "82291191dfc7dd1806eabfae18d84def",
"assets/assets/images/support_dashboard.png": "95c3f75358aeb4e3d7b37de2a4ee5c7e",
"assets/assets/images/total_client_project.png": "6f24fe9092142e43da9152ce33e35f9d",
"assets/assets/images/user.png": "7d74f8c9466f71e5f546812d042ac2ec",
"assets/assets/images/verified.png": "ce1787d8ecd1dec567d58dfcd41b95de",
"assets/FontManifest.json": "64661665bff00837a4bab1205ce3968a",
"assets/fonts/MaterialIcons-Regular.otf": "b5d2483cec21eef440ab6f9829b259af",
"assets/NOTICES": "8e141b6584cd8df75d6fc3f9cf0685ae",
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
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "fa28f89359f30dc716f871785a6a6361",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "81d981f146bf04cb7a8f10f4fb8c6334",
"/": "81d981f146bf04cb7a8f10f4fb8c6334",
"main.dart.js": "c53ce94a7a5a9b0be5186019d2eecd18",
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
