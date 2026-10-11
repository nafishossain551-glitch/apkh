// Messaging-only service worker: shows medicine reminders sent by the server
// while the app is closed. It does not cache pages.
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));

self.addEventListener("push", (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch { data = { title: "HealthMind AI", body: event.data ? event.data.text() : "" }; }
  event.waitUntil(
    self.registration.showNotification(data.title || "HealthMind AI", {
      body: data.body || "",
      icon: "/favicon.png",
      badge: "/favicon.png",
      tag: data.tag,
      renotify: true,
      requireInteraction: true,
      data: { url: data.url || "/medicine" },
    }),
  );
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const url = (event.notification.data && event.notification.data.url) || "/medicine";
  event.waitUntil((async () => {
    const all = await self.clients.matchAll({ type: "window", includeUncontrolled: true });
    for (const c of all) { if ("focus" in c) { await c.navigate(url).catch(() => {}); return c.focus(); } }
    return self.clients.openWindow(url);
  })());
});
