# Lab Sheet 8: Client Website Project

**Chosen client:** *Crumb & Co.*, ek local artisan bakery (Roorkee). Aap apni pasand ka client (cafe, fitness studio) chun sakte ho, bas naam aur content badal do.

**Project folder:**
```
crumb-co/
  index.html  booking.html  contact.html
  css/style.css   js/main.js
  images/ (hero1.jpg, hero2.jpg, hero3.jpg, ...)
```

**Q1. Project specification aur wireframe.**

*Specification*
| Item | Detail |
|------|--------|
| Client | Crumb & Co., artisan bakery |
| Goal | Online presence, orders/table bookings, customer trust |
| Audience | Local families, students, office workers (18-45), mostly mobile users |
| Pages | Home, Menu, About/Team, Booking, Contact |
| Features | Hero carousel, booking form, testimonials, Google Map, social links |
| Tech | HTML5, CSS3 (Grid + Flexbox), vanilla JavaScript |
| Constraints | Mobile-first, WCAG AA, page load under 3 sec |

*Wireframe (desktop)*
```
+--------------------------------------------------+
| LOGO         Home  Menu  About  Booking  Contact |
+--------------------------------------------------+
|        [  HERO CAROUSEL  <   >  ]                |
|        "Freshly baked every morning"  [Book Now] |
+--------------------------------------------------+
|  [Cakes]      [Breads]      [Cookies]            |   <- offerings
+--------------------------------------------------+
|  Our Team:  (photo) (photo) (photo)              |
+--------------------------------------------------+
|  Testimonials:  "..." *****   "..." ****         |
+--------------------------------------------------+
|  Contact info | Google Map | Social icons        |
+--------------------------------------------------+
```
Mobile par sab sections ek ke neeche ek (single column).

**Q2. Semantic HTML5 structure.** `index.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Crumb &amp; Co. | Artisan Bakery in Roorkee</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <a class="skip" href="#main">Skip to main content</a>
  <header>
    <a href="index.html" class="brand">Crumb &amp; Co.</a>
    <nav aria-label="Main navigation">
      <ul><li><a href="index.html">Home</a></li><li><a href="#menu">Menu</a></li>
          <li><a href="#team">Team</a></li><li><a href="booking.html">Booking</a></li><li><a href="contact.html">Contact</a></li></ul>
    </nav>
  </header>

  <main id="main">
    <section id="hero" aria-label="Featured products"><!-- Q6 carousel --></section>

    <section id="menu"><h2>What We Bake</h2>
      <article><h3>Cakes</h3><p>Custom birthday and wedding cakes.</p></article>
      <article><h3>Breads</h3><p>Sourdough and multigrain, baked at dawn.</p></article>
      <article><h3>Cookies</h3><p>Butter cookies and oat bars.</p></article>
    </section>

    <section id="team"><h2>Meet the Bakers</h2>
      <figure><img src="images/chef1.jpg" alt="Head baker Asha holding fresh bread"><figcaption>Asha, Head Baker</figcaption></figure>
    </section>

    <section id="reviews"><h2>What Customers Say</h2><!-- Q18 --></section>
  </main>

  <footer id="contact">
    <address>Crumb &amp; Co., Civil Lines, Roorkee<br><a href="tel:+910000000000">+91 00000 00000</a></address>
    <!-- Q8 map, Q9 social -->
    <p>&copy; 2026 Crumb &amp; Co.</p>
  </footer>
  <script src="js/main.js" defer></script>
</body>
</html>
```
Semantic tags (`header`, `nav`, `main`, `section`, `article`, `figure`, `footer`) se SEO aur accessibility dono behtar hote hain.

**Q3. Responsive CSS (Grid + Flexbox, mobile-first).** `css/style.css`
```css
/* Mobile-first: base styles chhoti screen ke liye */
*{box-sizing:border-box}
body{margin:0;font-family:"Segoe UI",Arial,sans-serif;line-height:1.6;color:#3b2f2f;background:#fffaf3}
header{display:flex;flex-direction:column;align-items:center;gap:8px;padding:12px;background:#6b3e26}
nav ul{display:flex;flex-wrap:wrap;gap:14px;list-style:none;margin:0;padding:0}
section{padding:24px 16px}
#menu{display:grid;grid-template-columns:1fr;gap:16px}
img{max-width:100%;height:auto}

/* Tablet */
@media (min-width:600px){ #menu{grid-template-columns:repeat(2,1fr)} }
/* Desktop */
@media (min-width:992px){
  header{flex-direction:row;justify-content:space-between;padding:12px 40px}
  #menu{grid-template-columns:repeat(3,1fr)}
  section{padding:48px 40px}
}
```

**Q4. Modern design principles: palette, typography scale, white space.**
```css
:root{
  /* Colour palette (60-30-10): cream, brown, orange */
  --bg:#fffaf3; --brand:#6b3e26; --accent:#e07a1f; --text:#3b2f2f;
  /* Typography scale (ratio ~1.25) */
  --fs-sm:.875rem; --fs-base:1rem; --fs-md:1.25rem; --fs-lg:1.563rem; --fs-xl:1.953rem; --fs-xxl:2.441rem;
  /* Spacing scale */
  --sp-1:.5rem; --sp-2:1rem; --sp-3:1.5rem; --sp-4:3rem;
}
h1{font-size:var(--fs-xxl)} h2{font-size:var(--fs-xl)} h3{font-size:var(--fs-lg)} p{font-size:var(--fs-base)}
h1,h2,h3{font-family:Georgia,serif;color:var(--brand);line-height:1.2}
section{padding:var(--sp-4) var(--sp-2)}
.btn{background:var(--accent);color:#fff;padding:var(--sp-1) var(--sp-3);border-radius:6px;text-decoration:none}
```
Kam colours, consistent spacing, aur ek heading + ek body font rakhne se design saaf aur professional dikhta hai.

**Q5. Accessibility (WCAG): ARIA landmarks, alt text, color contrast.**
```html
<header role="banner"> ... </header>
<nav aria-label="Main navigation"> ... </nav>
<main id="main"> ... </main>
<footer role="contentinfo"> ... </footer>

<img src="images/sourdough.jpg" alt="Golden sourdough loaf on a wooden board">
<img src="images/divider.png" alt="" role="presentation">      <!-- sirf decoration -->

<button aria-label="Next slide">&rsaquo;</button>
<label for="phone">Phone</label><input id="phone" type="tel">
```
```css
a:focus, button:focus, input:focus { outline: 3px solid #e07a1f; outline-offset: 2px; }  /* keyboard focus */
.skip { position: absolute; left: -999px; } .skip:focus { left: 8px; top: 8px; background:#fff; padding:6px; }
```
Contrast: normal text ke liye kam se kam **4.5:1** ratio. Check: WebAIM Contrast Checker. Jaise `#3b2f2f` on `#fffaf3` bahut achha ratio deta hai, jabki white text on `#e07a1f` kamzor ho sakta hai (isliye bade/bold button text par use karo ya darker orange `#b85c0d` lo).

**Q6. Hero carousel (JavaScript + CSS transitions).**
HTML
```html
<section id="hero" aria-label="Featured products">
  <div class="slides">
    <div class="slide active"><img src="images/hero1.jpg" alt="Fresh croissants"><p>Flaky croissants, baked at dawn</p></div>
    <div class="slide"><img src="images/hero2.jpg" alt="Decorated birthday cake"><p>Custom cakes for every occasion</p></div>
    <div class="slide"><img src="images/hero3.jpg" alt="Assorted cookies"><p>Cookies made with real butter</p></div>
  </div>
  <button id="prev" aria-label="Previous slide">&lsaquo;</button>
  <button id="next" aria-label="Next slide">&rsaquo;</button>
</section>
```
CSS
```css
#hero{position:relative;overflow:hidden;padding:0}
.slide{position:absolute;inset:0;opacity:0;transition:opacity .8s ease}
.slide.active{position:relative;opacity:1}
.slide img{width:100%;height:60vh;object-fit:cover}
.slide p{position:absolute;bottom:20px;left:20px;color:#fff;background:rgba(0,0,0,.5);padding:8px 14px}
#hero button{position:absolute;top:50%;transform:translateY(-50%);background:rgba(0,0,0,.5);color:#fff;border:0;font-size:2rem;padding:6px 14px}
#prev{left:10px} #next{right:10px}
```
JS (`js/main.js`)
```javascript
const slides = document.querySelectorAll(".slide");
let cur = 0;
function show(n) {
  slides[cur].classList.remove("active");
  cur = (n + slides.length) % slides.length;
  slides[cur].classList.add("active");
}
document.getElementById("next").onclick = () => show(cur + 1);
document.getElementById("prev").onclick = () => show(cur - 1);
setInterval(() => show(cur + 1), 5000);          // auto slide
```

**Q7. Booking/reservation form + JavaScript validation.** `booking.html`
```html
<form id="bookForm" novalidate>
  <label for="bn">Name</label><input id="bn" required>
  <label for="be">Email</label><input id="be" type="email" required>
  <label for="bp">Phone</label><input id="bp" type="tel" required>
  <label for="bd">Date</label><input id="bd" type="date" required>
  <label for="bg">Guests</label>
  <select id="bg"><option>1</option><option>2</option><option>4</option><option>6</option></select>
  <button class="btn" type="submit">Reserve</button>
  <p id="bmsg" role="alert"></p>
</form>
<script>
document.getElementById("bookForm").addEventListener("submit", e => {
  e.preventDefault();
  const msg = document.getElementById("bmsg");
  const name = bn.value.trim(), mail = be.value, phone = bp.value, date = bd.value;
  if (name.length < 2)                          return msg.textContent = "Please enter your name.";
  if (!/^[^@\s]+@[^@\s]+\.[a-z]{2,}$/i.test(mail)) return msg.textContent = "Enter a valid email.";
  if (!/^[0-9]{10}$/.test(phone))               return msg.textContent = "Phone must be 10 digits.";
  if (!date || new Date(date) < new Date().setHours(0,0,0,0)) return msg.textContent = "Pick a future date.";
  msg.style.color = "green";
  msg.textContent = `Thank you ${name}! Your table for ${bg.value} on ${date} is booked.`;
});
</script>
```

**Q8. Google Maps embed + responsive styling.** `contact.html`
Google Maps mein apna location search karo, **Share → Embed a map** se iframe code copy karo.
```html
<div class="map">
  <iframe src="PASTE_GOOGLE_MAPS_EMBED_URL_HERE"
          title="Crumb & Co. location on Google Maps" loading="lazy" allowfullscreen
          referrerpolicy="no-referrer-when-downgrade"></iframe>
</div>
```
```css
.map{position:relative;width:100%;padding-bottom:56.25%;height:0;overflow:hidden}   /* 16:9 */
.map iframe{position:absolute;inset:0;width:100%;height:100%;border:0}
```

**Q9. Social media links aur share buttons (footer).**
```html
<div class="social" aria-label="Follow us">
  <a href="https://www.instagram.com/yourpage" target="_blank" rel="noopener">Instagram</a>
  <a href="https://www.facebook.com/yourpage" target="_blank" rel="noopener">Facebook</a>
  <a href="https://twitter.com/yourpage" target="_blank" rel="noopener">X</a>
</div>
<p>Share this page:
  <a href="https://www.facebook.com/sharer/sharer.php?u=https://example.com" target="_blank" rel="noopener">Facebook</a> |
  <a href="https://twitter.com/intent/tweet?url=https://example.com&text=Crumb%20%26%20Co." target="_blank" rel="noopener">X</a> |
  <a href="https://wa.me/?text=Check%20out%20Crumb%20%26%20Co.%20https://example.com" target="_blank" rel="noopener">WhatsApp</a>
</p>
```
Live Instagram feed ke liye platform ka official embed code ya widget use hota hai (login/API chahiye). Demo ke liye profile links kaafi hain.

**Q10. Assets optimize (images compress, CSS/JS minify).**
```bash
# Images: kam size mein (Ubuntu)
sudo apt install -y imagemagick optipng jpegoptim webp
mogrify -resize 1600x -quality 80 images/*.jpg
jpegoptim --max=80 images/*.jpg
cwebp -q 80 images/hero1.jpg -o images/hero1.webp      # WebP format

# CSS/JS minify (Node.js se)
npx csso-cli css/style.css -o css/style.min.css
npx terser js/main.js -c -m -o js/main.min.js
```
HTML mein `style.min.css` aur `main.min.js` link karo. Extra tips: `<img loading="lazy">`, `<script defer>`, aur kam fonts. Before/after file size note karo (`ls -lh`).

**Q11. Cross-browser compatibility (Chrome, Firefox, Edge, Safari).**
| Check | Chrome | Firefox | Edge | Safari |
|-------|:-----:|:-------:|:----:|:------:|
| Layout (Grid/Flex) | ok | ok | ok | ok |
| Carousel transitions | ok | ok | ok | ok |
| Form validation / date input | ok | ok | ok | ok |
| Fonts/images load | ok | ok | ok | ok |
Har browser mein site kholkar screenshot lo aur jo kharabi mile use likho. Safari Mac/iPhone par hi milta hai. Na ho to BrowserStack/LambdaTest ka free trial use karo. Kisi CSS feature ki support https://caniuse.com par check karo.

**Q12. Mobile responsiveness (developer tools).**
1. Chrome mein `F12` dabao, phir `Ctrl + Shift + M` (Device Toolbar).
2. Devices chuno: iPhone SE (375px), iPhone 14 (390px), iPad (768px), Laptop (1366px).
3. Check: koi horizontal scroll na ho, text padhne layak ho, buttons tap karne layak bade (~44px), images screen se bahar na jayein, menu toot na jaye.
4. Har device ka screenshot lo. `<meta name="viewport" content="width=device-width, initial-scale=1">` zaroor ho.

**Q13. Design rationale document (outline).**
1. **Overview:** client, goal, audience.
2. **Colour choices:** cream background (warm, appetising), brown (trust, bakery feel), orange accent (call-to-action buttons). Contrast ratios check kiye.
3. **Typography:** Georgia headings (traditional, premium) + Segoe UI/Arial body (readable). Modular scale ~1.25.
4. **Layout:** mobile-first, single column on phone, 3-column grid on desktop. White space se content saans leta hai.
5. **Audience alignment:** locals zyada mobile par aate hain, isliye thumb-friendly buttons, click-to-call phone number, ek-click booking.
6. **Accessibility:** alt text, ARIA landmarks, keyboard focus, 4.5:1 contrast.
7. **Performance & SEO:** optimized images, meta tags, semantic HTML.
8. **Conclusion:** goals kaise meet hue.

**Q14. Presentation (slide outline).**
1. Title: Crumb & Co. Website, your name, course code
2. Client and goals
3. Target audience
4. Wireframes
5. Design choices (colour, fonts)
6. Development phases: HTML, CSS, JS, integration
7. Key features: carousel, booking form, map, testimonials
8. Accessibility and performance
9. Testing results: browsers, devices, Lighthouse scores
10. Challenges and learnings
11. Live demo and Q&A

**Q15. Live demonstration plan (2 to 3 minutes).**
1. `index.html` kholo: hero carousel auto-slide aur arrows dikhao.
2. Menu aur team sections par scroll karo.
3. Booking form mein galat data daalke error dikhao, phir sahi data se success message.
4. Browser ko chhota karke (ya `F12` device mode) responsive layout dikhao.
5. Keyboard se `Tab` dabake accessibility focus dikhao.
6. Contact page par map dikhao.
7. Lighthouse report ka score dikhao.
Pehle se ek baar poora rehearse kar lo.

**Q16. SEO meta tags (har page par).**
```html
<head>
  <title>Crumb &amp; Co. | Artisan Bakery in Roorkee</title>
  <meta name="description" content="Fresh sourdough, custom cakes and cookies baked daily in Roorkee. Book a table online.">
  <meta name="keywords" content="bakery, cakes, bread, Roorkee">
  <meta name="author" content="Your Name">
  <link rel="canonical" href="https://example.com/">

  <!-- Open Graph (social share preview) -->
  <meta property="og:title" content="Crumb &amp; Co. | Artisan Bakery">
  <meta property="og:description" content="Fresh bread and custom cakes baked daily.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://example.com/">
  <meta property="og:image" content="https://example.com/images/hero1.jpg">
  <meta name="twitter:card" content="summary_large_image">
</head>
```
Har page ka `title` aur `description` alag aur unique hona chahiye.

**Q17. Local test environment.**
```bash
cd crumb-co
python3 -m http.server 8000          # phir browser: http://localhost:8000
# ya
npx serve .                          # ya VS Code mein "Live Server" extension
```
Apache par chalane ke liye folder ko `/var/www/html/crumb-co/` mein copy karo aur `http://localhost/crumb-co/` kholo. Ek baar saare links, images aur forms test kar lo.

**Q18. Testimonial grid + interactive rating stars.**
```html
<section id="reviews"><h2>What Customers Say</h2>
  <div class="tgrid">
    <blockquote><p>The sourdough is the best in town!</p><footer>Riya <span class="stars" data-r="5"></span></footer></blockquote>
    <blockquote><p>Lovely birthday cake, on time.</p><footer>Amit <span class="stars" data-r="4"></span></footer></blockquote>
    <blockquote><p>Cozy place and friendly staff.</p><footer>Sana <span class="stars" data-r="5"></span></footer></blockquote>
  </div>
  <h3>Rate us</h3>
  <div id="rate" role="radiogroup" aria-label="Rate your experience"></div>
  <p id="rmsg"></p>
</section>
```
```css
.tgrid{display:grid;gap:16px;grid-template-columns:repeat(auto-fit,minmax(220px,1fr))}
blockquote{background:#fff;padding:16px;border-radius:8px;margin:0;box-shadow:0 2px 6px rgba(0,0,0,.1)}
.star{font-size:2rem;cursor:pointer;color:#ccc;background:none;border:0}
.star.on{color:#f5a623}
```
```javascript
// Static stars
document.querySelectorAll(".stars").forEach(s => {
  const r = +s.dataset.r; s.textContent = "\u2605".repeat(r) + "\u2606".repeat(5 - r);
});
// Interactive rating
const box = document.getElementById("rate");
for (let i = 1; i <= 5; i++) {
  const b = document.createElement("button");
  b.className = "star"; b.textContent = "\u2605"; b.setAttribute("aria-label", i + " star");
  b.onmouseover = () => paint(i);
  b.onmouseout  = () => paint(+box.dataset.val || 0);
  b.onclick = () => { box.dataset.val = i; paint(i); document.getElementById("rmsg").textContent = `You rated us ${i}/5. Thank you!`; };
  box.appendChild(b);
}
function paint(n) { [...box.children].forEach((b, i) => b.classList.toggle("on", i < n)); }
```

**Q19. Clean, commented code (coding standards).**
Checklist:
- Consistent indentation (2 spaces), lowercase tag/attribute names, double quotes.
- Meaningful class/ID names (`.hero-slide`, `#booking-form`), BEM jaise pattern (`card__title`).
- CSS mein sections ke comments: `/* ===== Header ===== */`, variables `:root` mein.
- JavaScript mein `const/let`, chhote functions, har function ke upar ek line ka comment.
- Koi inline styles ya duplicate code nahi.
- Code validate: https://validator.w3.org (HTML), https://jigsaw.w3.org/css-validator (CSS).
Example:
```javascript
/* Show the slide at index n and hide the current one */
function show(n) { ... }
```

**Q20. Final code audit aur accessibility evaluation (Lighthouse).**
1. Chrome mein site kholo, `F12` → **Lighthouse** tab.
2. Categories: Performance, Accessibility, Best Practices, SEO. Mode: Mobile → **Analyze page load**.
3. Score note karo (target: 90+). Jo issues aayein unhe theek karo (missing alt, low contrast, bade images, missing meta description) aur dobara chalao.
4. Extra: WAVE extension (https://wave.webaim.org) aur axe DevTools se accessibility errors dekho. Keyboard se poori site `Tab` dabake navigate karke check karo.
5. Report ka screenshot (before aur after scores) apne submission mein lagao.
CLI se (Node): `npx lighthouse http://localhost:8000 --view`
