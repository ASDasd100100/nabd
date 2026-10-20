/**
 * خادم محلي بسيط لموقع شركة نبض لتجارة وتوزيع الأدوية
 * يعمل بدون أي مكتبات خارجية (Node.js فقط).
 *
 * الاستخدام:
 *   node server.js [المنفذ]
 * مثال:
 *   node server.js 8090
 */

const http = require("http");
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname);
const PORT = Number(process.argv[2] || 8090);

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "application/javascript; charset=utf-8",
  ".mjs": "application/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".xml": "application/xml; charset=utf-8",
  ".txt": "text/plain; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".ico": "image/x-icon",
  ".woff": "font/woff",
  ".woff2": "font/woff2",
  ".ttf": "font/ttf",
  ".pdf": "application/pdf"
};

function contentType(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  return MIME[ext] || "application/octet-stream";
}

const server = http.createServer(function (req, res) {
  let urlPath;
  try {
    urlPath = decodeURIComponent(req.url.split("?")[0].split("#")[0]);
  } catch (e) {
    res.writeHead(400, { "Content-Type": "text/plain; charset=utf-8" });
    res.end("Bad Request");
    return;
  }

  if (urlPath === "/" || urlPath === "") urlPath = "/index.html";

  let filePath = path.normalize(path.join(ROOT, urlPath));

  if (filePath !== ROOT && !filePath.startsWith(ROOT + path.sep)) {
    res.writeHead(403, { "Content-Type": "text/plain; charset=utf-8" });
    res.end("Forbidden");
    return;
  }

  fs.stat(filePath, function (statErr, stat) {
    if (!statErr && stat.isDirectory()) filePath = path.join(filePath, "index.html");

    fs.readFile(filePath, function (readErr, data) {
      if (readErr) {
        res.writeHead(404, { "Content-Type": "text/html; charset=utf-8" });
        res.end("<h1>404 - الصفحة غير موجودة</h1>");
        return;
      }
      res.writeHead(200, {
        "Content-Type": contentType(filePath),
        "Cache-Control": "no-cache"
      });
      res.end(data);
    });
  });
});

server.listen(PORT, function () {
  console.log("");
  console.log("  ✔ الموقع يعمل الآن على: http://localhost:" + PORT + "/");
  console.log("  لإيقاف الخادم اضغط: Ctrl + C");
  console.log("");
});
