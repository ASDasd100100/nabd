# موقع شركة نبض لتجارة وتوزيع الأدوية — NABD Pharmaceutical Trading & Distribution

موقع تعريفي احترافي لشركة مصرية تعمل في تجارة وتوزيع الأدوية، بتصميم مستقبلي لعام 2027
بهوية خضراء طبية، وحركات راقية، وتجربة ممتازة على الهاتف والكمبيوتر.

## بنية المشروع

```
├── index.html              الصفحة الرئيسية (نقطة تشغيل الموقع)
├── تشغيل الموقع.bat        تشغيل الموقع بضغطة واحدة (ويندوز)
├── start.ps1               قائمة التشغيل (يُستدعى تلقائياً من ملف .bat)
├── server.js               خادم محلي بسيط بدون أي مكتبات خارجية
├── README.md               هذا الملف
├── robots.txt              إعدادات محركات البحث
├── sitemap.xml             خريطة الموقع
└── assets/
    ├── css/style.css       نظام التصميم الكامل (متغيرات، أقسام، حركة، استجابة)
    ├── js/main.js          التفاعل: الحركة، القائمة، التحقق من النموذج
    └── img/
        ├── logo.svg        شعار نبض (نبض قلب + درع طبي)
        └── favicon.svg     أيقونة الموقع
```

## التشغيل

الموقع ثابت بالكامل ولا يحتاج أي تثبيت أو خطوة بناء.

### الطريقة 1 — ويندوز (الأسهل)

انقر نقرًا مزدوجًا على **`تشغيل الموقع.bat`** ثم اختر:

- **1** — فتح الموقع مباشرة في المتصفح (بدون أي متطلبات).
- **2** — تشغيل خادم محلي وفتح الموقع تلقائيًا (يتطلب Node.js).

### الطريقة 2 — فتح مباشر

انقر نقرًا مزدوجًا على **`index.html`** — سيفتح الموقع فورًا في المتصفح.

### الطريقة 3 — خادم محلي (الأفضل للتجربة الكاملة)

```bash
node server.js 8090
```

ثم افتح: `http://localhost:8090`

> يمكن استخدام خادم آخر إن توفّر، مثل: `python -m http.server 8090`

## النشر

ارفع الملفات كما هي على أي استضافة ثابتة (Netlify / Vercel / Cloudflare Pages /
أي استضافة عادية تدعم HTML):

- **Netlify / Vercel:** اسحب مجلد المشروع وارفعه — لا يحتاج Build Command.
- **استضافة عادية (cPanel):** ارفع الملفات إلى مجلد `public_html`.

### ضبط النطاق في ملفات SEO

بعد تحديد رابط الموقع الفعلي، عدّل النص البديل `https://nabd.example.com/` في:

1. `index.html` → وسم `canonical` ووسوم `og:url` و`og:image:alt` (إن رغبتم).
2. `robots.txt` → سطر `Sitemap`.
3. `sitemap.xml` → عنصر `<loc>`.

**ملاحظة:** تم تحديث نطاق الموقع الافتراضي إلى `https://nabd.eg/` افتراضيًا، ويمكن تعديله بسهولة إذا تغير النطاق مستقبلاً.

## تفعيل إرسال نموذج التواصل (مهم)

النموذج حالياً يقوم بالتحقق الكامل من المدخلات (الاسم، الشركة، الهاتف المصري، البريد
الاختياري، نوع الاستفسار، الرسالة)، وبعد نجاح التحقق يفتح برنامج بريد المستخدم بررسالة
جاهزة إلى `nabd.eg@outlook.com`. **لم يتم ربطه بخدمة إرسال آلية بعد** حتى لا يُدّعى
إرسال فعلي غير موجود.

### الخيار 1 — Formspool / Formspark / Web3Forms (الأسرع، بدون كود خادم)

1. سجّل في الخدمة (مثل [web3forms.com](https://web3forms.com) المجاني) واحصل على مفتاح API.
2. في `assets/js/main.js`، داخل `form.addEventListener("submit", ...)` بعد نجاح التحقق،
   استبدل فتح برنامج البريد بطلب `fetch`:

   ```js
   await fetch("https://api.web3forms.com/submit", {
     method: "POST",
     headers: { "Content-Type": "application/json" },
     body: JSON.stringify({
       access_key: "مفتاح-ال-api-هنا",
       subject: subject,
       from_name: name,
      message: body
     })
   });
   ```

3. احذف سطر `window.location.href = mailtoUrl;` واعرض رسالة نجاح الحقيقية.

### الخيار 2 — خادم خاص (Node.js مثال)

ارفع الملفات على خادم مع خدمة صغيرة ترسل بريدًا عبر SMTP:

```js
// server.js (نموذج توضيحي)
const express = require("express");
const nodemailer = require("nodemailer");
const app = express();
app.use(express.json());
app.use(express.static("."));

app.post("/api/contact", async (req, res) => {
  const { name, company, phone, email, type, message } = req.body;
  // تحقق من الحقول مرة أخرى على الخادم
  const transporter = nodemailer.createTransport({ /* إعدادات SMTP */ });
  await transporter.sendMail({
    from: `"${name}" <${email || "no-reply@nabd.example.com"}>`,
    to: "nabd.eg@outlook.com",
    subject: `استفسار من الموقع — ${type} — ${company}`,
    text: body
  });
  res.json({ ok: true });
});
app.listen(3000);
```

ثم اربط `fetch("/api/contact", ...)` في `main.js`.

### الخيار 3 — Google Forms / Microsoft Forms

إنشاء نموذج في خدمة جوجل/مايكروسوفت ودمجه عبر iframe أو الوجهة الافتراضية للنموذج،
دون الحاجة لأي برمجة.

## إضافة أدوات التحليلات لاحقاً

الموقع جاهز لإضافة Google Analytics 4 أو Meta Pixel دون تعديل التصميم: أضف سكربت
الخدمة قبل وسم `</head>` في `index.html`. لم تتم إضافة أي معرفات وهمية.

## ملاحظات محتوى (مصداقية المعلومات)

- لم يُخترع أي تاريخ تأسيس أو عدد عملاء أو فروع أو شهادات اعتماد.
- قسم «قطاعات التوزيع» معروض بوصفه نطاقاً محتملاً قابلاً للتعديل وفق قاعدة العملاء
  الفعلية.
- صور الموقع من Pexels (رخصة مجانية للاستخدام التجاري، لا تتطلب إسناداً) عبر روابط
  CDN: `https://images.pexels.com/photos/<id>/pexels-photo-<id>.jpeg`
- للحصول على أسرع أداء، يمكن لاحقاً تنزيل الصور وحفظها بصيغة WebP داخل `assets/img/`
  واستبدال الروابط الخارجية.

## بيانات التواصل المعتمدة

- الهاتف: [01025888895](tel:+201025888895)
- البريد: [nabd.eg@outlook.com](mailto:nabd.eg@outlook.com)
- فيسبوك: <https://www.facebook.com/nabd.drugs.distribution>
