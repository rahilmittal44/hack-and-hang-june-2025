if (!self.define) {
  let e,
    s = {};
  const n = (n, c) => (
    (n = new URL(n + ".js", c).href),
    s[n] ||
      new Promise((s) => {
        if ("document" in self) {
          const e = document.createElement("script");
          (e.src = n), (e.onload = s), document.head.appendChild(e);
        } else (e = n), importScripts(n), s();
      }).then(() => {
        let e = s[n];
        if (!e) throw new Error(`Module ${n} didn’t register its module`);
        return e;
      })
  );
  self.define = (c, a) => {
    const i = e || ("document" in self ? document.currentScript.src : "") || location.href;
    if (s[i]) return;
    let t = {};
    const r = (e) => n(e, i),
      o = { module: { uri: i }, exports: t, require: r };
    s[i] = Promise.all(c.map((e) => o[e] || r(e))).then((e) => (a(...e), t));
  };
}
define(["./workbox-3c9d0171"], function (e) {
  "use strict";
  importScripts(),
    self.skipWaiting(),
    e.clientsClaim(),
    e.precacheAndRoute(
      [
        { url: "/_next/static/R89T02rNSukcU8yBYcl0X/_buildManifest.js", revision: "85aecd8a55db42fc901f52386fd2a680" },
        { url: "/_next/static/R89T02rNSukcU8yBYcl0X/_ssgManifest.js", revision: "b6652df95db52feb4daf4eca35380933" },
        { url: "/_next/static/chunks/10-d6fdf293b01e309a.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/2267893a-9fa9564dcac2756a.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/265-8401f7af8516306b.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/510-73dbf83dbabee2ff.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/640.4da2627e460663ef.js", revision: "4da2627e460663ef" },
        { url: "/_next/static/chunks/782-c6517c5837842cb9.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/app/_not-found/page-65bd21e1b7c6db12.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/app/layout-dd78460ed57d0cfb.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/app/page-64cc63cfffb426b2.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/b145b63a-aea33fdc1d2d030c.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/framework-6e06c675866dc992.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/main-app-015dc9581d6b09f7.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/main-d549b6d8041a1d88.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/pages/_app-3fcac1a2c632f1ef.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/pages/_error-d3fe151bf402c134.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/chunks/polyfills-42372ed130431b0a.js", revision: "846118c33b2c0e922d7b3a7676f81f6f" },
        { url: "/_next/static/chunks/webpack-47ed2e71e87658e2.js", revision: "R89T02rNSukcU8yBYcl0X" },
        { url: "/_next/static/css/261e072ee000f777.css", revision: "261e072ee000f777" },
        { url: "/aptos.png", revision: "a98d27fd2ad859671bd172999f95b47c" },
        { url: "/favicon-16x16.png", revision: "7215ee9c7d9dc229d2921a40e899ec5f" },
        { url: "/favicon-simple.svg", revision: "76c235322f3dda1c3a3d0cc5377af6c8" },
        { url: "/favicon.ico", revision: "28bc4a59a6b3c7006b1e6da74191b146" },
        { url: "/favicon.svg", revision: "76534ff2e16e7d3d9184625d43621a78" },
        { url: "/icons/icon-192x192.png", revision: "0350c81b3b6805c7d7f45bfadf258af2" },
        { url: "/icons/icon-384x384.png", revision: "89b0d4e4292ee962f3b2d7f5d5d7f54f" },
        { url: "/icons/icon-512x512.png", revision: "c3dfddb9ec42df70fa0a712e1f4433ba" },
      ],
      { ignoreURLParametersMatching: [/^utm_/, /^fbclid$/] },
    ),
    e.cleanupOutdatedCaches(),
    e.registerRoute(
      "/",
      new e.NetworkFirst({
        cacheName: "start-url",
        plugins: [
          {
            cacheWillUpdate: async ({ response: e }) =>
              e && "opaqueredirect" === e.type
                ? new Response(e.body, { status: 200, statusText: "OK", headers: e.headers })
                : e,
          },
        ],
      }),
      "GET",
    ),
    e.registerRoute(
      /^https:\/\/fonts\.(?:gstatic)\.com\/.*/i,
      new e.CacheFirst({
        cacheName: "google-fonts-webfonts",
        plugins: [new e.ExpirationPlugin({ maxEntries: 4, maxAgeSeconds: 31536e3 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /^https:\/\/fonts\.(?:googleapis)\.com\/.*/i,
      new e.StaleWhileRevalidate({
        cacheName: "google-fonts-stylesheets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 4, maxAgeSeconds: 604800 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:eot|otf|ttc|ttf|woff|woff2|font.css)$/i,
      new e.StaleWhileRevalidate({
        cacheName: "static-font-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 4, maxAgeSeconds: 604800 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:jpg|jpeg|gif|png|svg|ico|webp)$/i,
      new e.StaleWhileRevalidate({
        cacheName: "static-image-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 64, maxAgeSeconds: 2592e3 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\/_next\/static.+\.js$/i,
      new e.CacheFirst({
        cacheName: "next-static-js-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 64, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\/_next\/image\?url=.+$/i,
      new e.StaleWhileRevalidate({
        cacheName: "next-image",
        plugins: [new e.ExpirationPlugin({ maxEntries: 64, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:mp3|wav|ogg)$/i,
      new e.CacheFirst({
        cacheName: "static-audio-assets",
        plugins: [new e.RangeRequestsPlugin(), new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:mp4|webm)$/i,
      new e.CacheFirst({
        cacheName: "static-video-assets",
        plugins: [new e.RangeRequestsPlugin(), new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:js)$/i,
      new e.StaleWhileRevalidate({
        cacheName: "static-js-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 48, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:css|less)$/i,
      new e.StaleWhileRevalidate({
        cacheName: "static-style-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\/_next\/data\/.+\/.+\.json$/i,
      new e.StaleWhileRevalidate({
        cacheName: "next-data",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      /\.(?:json|xml|csv)$/i,
      new e.NetworkFirst({
        cacheName: "static-data-assets",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      ({ sameOrigin: e, url: { pathname: s } }) =>
        !(!e || s.startsWith("/api/auth/callback") || !s.startsWith("/api/")),
      new e.NetworkFirst({
        cacheName: "apis",
        networkTimeoutSeconds: 10,
        plugins: [new e.ExpirationPlugin({ maxEntries: 16, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      ({ request: e, url: { pathname: s }, sameOrigin: n }) =>
        "1" === e.headers.get("RSC") && "1" === e.headers.get("Next-Router-Prefetch") && n && !s.startsWith("/api/"),
      new e.NetworkFirst({
        cacheName: "pages-rsc-prefetch",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      ({ request: e, url: { pathname: s }, sameOrigin: n }) =>
        "1" === e.headers.get("RSC") && n && !s.startsWith("/api/"),
      new e.NetworkFirst({
        cacheName: "pages-rsc",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      ({ url: { pathname: e }, sameOrigin: s }) => s && !e.startsWith("/api/"),
      new e.NetworkFirst({
        cacheName: "pages",
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 86400 })],
      }),
      "GET",
    ),
    e.registerRoute(
      ({ sameOrigin: e }) => !e,
      new e.NetworkFirst({
        cacheName: "cross-origin",
        networkTimeoutSeconds: 10,
        plugins: [new e.ExpirationPlugin({ maxEntries: 32, maxAgeSeconds: 3600 })],
      }),
      "GET",
    );
});
