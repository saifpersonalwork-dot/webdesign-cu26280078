# Lab Sheet 2: Forms + CSS

Har example ek alag `.html` file mein save karo. Jahan `style.css` likha hai wahan CSS ko alag file mein rakho aur `<link rel="stylesheet" href="style.css">` lagao.

**Q1. Saare input types, external CSS ke saath.**
`form1.html`
```html
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Form</title>
<link rel="stylesheet" href="style.css"></head>
<body>
<form class="box">
  <label>Name</label><input type="text" name="name">
  <label>Password</label><input type="password" name="pass">
  <label>Gender</label>
  <div><input type="radio" name="g" value="m"> Male <input type="radio" name="g" value="f"> Female</div>
  <label>Interests</label>
  <div><input type="checkbox"> Coding <input type="checkbox"> Music</div>
  <label>Course</label>
  <select><option>MCA</option><option>BCA</option></select>
  <label>Message</label><textarea rows="4"></textarea>
  <button type="submit">Submit</button>
</form>
</body></html>
```
`style.css`
```css
body { font-family: Arial, sans-serif; background: #f2f4f8; }
.box { width: 340px; margin: 30px auto; padding: 20px; background: #fff; border-radius: 8px; }
label { display: block; margin-top: 12px; font-weight: bold; }
input[type=text], input[type=password], select, textarea { width: 100%; padding: 8px; box-sizing: border-box; }
button { margin-top: 15px; padding: 10px 20px; background: #2a6edb; color: #fff; border: 0; border-radius: 4px; }
```

**Q2. HTML5 validation: required, minlength, maxlength, pattern, email.**
```html
<form>
  <input type="text" name="name" placeholder="Full name" required minlength="3" maxlength="30"><br><br>
  <input type="email" name="email" placeholder="Email" required><br><br>
  <input type="text" name="phone" placeholder="10 digit mobile" pattern="[0-9]{10}" title="Enter 10 digits" required><br><br>
  <input type="password" name="pw" placeholder="Password (min 6)" minlength="6" required><br><br>
  <button type="submit">Register</button>
</form>
```

**Q3. Frameset aur frame (legacy).** `frameset` HTML5 mein obsolete hai, sirf practice ke liye.
`index.html` (isme `<body>` nahi hota)
```html
<html>
<frameset rows="20%,80%">
  <frame src="header.html" name="header">
  <frameset cols="25%,75%">
    <frame src="nav.html" name="nav">
    <frame src="content.html" name="content">
  </frameset>
</frameset>
</html>
```
`header.html`: `<h1>My Site</h1>`
`nav.html`: `<a href="content.html" target="content">Home</a><br><a href="about.html" target="content">About</a>`
`content.html`: `<h2>Welcome</h2><p>Main content.</p>`

**Q4. Flexbox se frame jaisa layout.**
```html
<style>
  body { margin: 0; font-family: Arial; }
  .page { display: flex; flex-direction: column; height: 100vh; }
  header { background: #2a6edb; color: #fff; padding: 15px; }
  .main { display: flex; flex: 1; }
  nav { width: 200px; background: #e8eefc; padding: 15px; }
  main { flex: 1; padding: 15px; }
</style>
<div class="page">
  <header><h2>My Site</h2></header>
  <div class="main">
    <nav><a href="#">Home</a><br><a href="#">About</a></nav>
    <main><h3>Content</h3><p>Main content area.</p></main>
  </div>
</div>
```

**Q5. Login card: box-shadow, border-radius, absolute positioning.**
```html
<style>
  body { background: #eef1f6; font-family: Arial; }
  .card { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
          width: 300px; padding: 25px; background: #fff; border-radius: 12px;
          box-shadow: 0 8px 24px rgba(0,0,0,0.2); }
  .card input { width: 100%; padding: 9px; margin: 8px 0; box-sizing: border-box; }
  .card button { width: 100%; padding: 10px; background: #2a6edb; color: #fff; border: 0; border-radius: 6px; }
</style>
<div class="card">
  <h2>Login</h2>
  <input type="text" placeholder="Username">
  <input type="password" placeholder="Password">
  <button>Sign In</button>
</div>
```

**Q6. CSS Grid se two-column form.**
```html
<style>
  .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px; width: 500px; margin: 20px auto; }
  .grid input, .grid select { width: 100%; padding: 8px; box-sizing: border-box; }
  .full { grid-column: 1 / -1; }
</style>
<form class="grid">
  <input placeholder="First name"> <input placeholder="Last name">
  <input placeholder="Email"> <input placeholder="Phone">
  <select class="full"><option>Select course</option><option>MCA</option></select>
  <button class="full">Submit</button>
</form>
```

**Q7. :focus par border color aur background tint.**
```html
<style>
  input, textarea { padding: 8px; border: 2px solid #ccc; outline: none; width: 300px; margin: 6px 0; }
  input:focus, textarea:focus { border-color: #2a6edb; background: #eaf1ff; }
</style>
<form>
  <input type="text" placeholder="Name"><br>
  <input type="email" placeholder="Email"><br>
  <textarea rows="4" placeholder="Feedback"></textarea>
</form>
```

**Q8. File upload + custom submit button (hover, active, transition).**
```html
<style>
  .btn { padding: 10px 24px; background: #2a6edb; color: #fff; border: 0; border-radius: 5px;
         cursor: pointer; transition: background 0.3s, transform 0.2s; }
  .btn:hover { background: #1b4fa8; }
  .btn:active { transform: scale(0.95); }
</style>
<form>
  <input type="file" name="doc"><br><br>
  <button type="submit" class="btn">Upload</button>
</form>
```

**Q9. Survey: fieldset + legend, padding/margin.**
```html
<style>
  fieldset { padding: 15px 20px; margin: 15px 0; border: 2px solid #2a6edb; border-radius: 6px; }
  legend { padding: 0 10px; font-weight: bold; color: #2a6edb; }
</style>
<form>
  <fieldset><legend>About You</legend>
    <input type="text" placeholder="Name"> <input type="number" placeholder="Age">
  </fieldset>
  <fieldset><legend>Feedback</legend>
    <label><input type="radio" name="r"> Good</label>
    <label><input type="radio" name="r"> Average</label>
  </fieldset>
</form>
```

**Q10. Data entry table: alternating rows aur hover.**
```html
<style>
  .wrap { width: 500px; margin: 20px auto; padding: 15px; border: 1px solid #ccc; border-radius: 8px; }
  table { width: 100%; border-collapse: collapse; }
  th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
  th { background: #2a6edb; color: #fff; }
  tr:nth-child(even) { background: #f2f6ff; }
  tr:hover td { background: #ffe9a8; }
</style>
<form class="wrap">
  <table>
    <tr><th>Item</th><th>Qty</th></tr>
    <tr><td>Pen</td><td><input type="number" value="1"></td></tr>
    <tr><td>Book</td><td><input type="number" value="2"></td></tr>
    <tr><td>Bag</td><td><input type="number" value="1"></td></tr>
  </table>
</form>
```

**Q11. Inline, internal aur external CSS saath, specificity.**
`contact.html`
```html
<link rel="stylesheet" href="ext.css">
<style>
  /* internal */
  input { border: 2px solid green; }
  #email { border: 2px solid blue; }
</style>
<form>
  <input type="text" placeholder="Name"><br>
  <input type="email" id="email" placeholder="Email"><br>
  <input type="text" placeholder="Phone" style="border: 2px solid red;">
</form>
```
`ext.css`: `input { border: 2px solid gray; padding: 8px; margin: 5px; }`
Specificity order: **inline > id (#email) > class > tag**. Barabar specificity par jo baad mein likha ho wo jeetta hai, isliye internal `input` rule external wale ko override karta hai. Neeche wala input red hoga (inline), email blue (id), baaki green.

**Q12. Responsive checkout form (media queries).**
```html
<style>
  .pay { max-width: 450px; margin: 20px auto; }
  .pay input, .pay select { width: 100%; padding: 10px; margin: 6px 0; box-sizing: border-box; }
  .row { display: flex; gap: 10px; }
  .row input { width: 50%; }
  @media (max-width: 480px) {
    .row { flex-direction: column; }
    .row input { width: 100%; }
    .pay { margin: 10px; }
  }
</style>
<form class="pay">
  <input placeholder="Cardholder name">
  <input placeholder="Card number" maxlength="16">
  <div class="row"><input placeholder="MM/YY"><input placeholder="CVV" maxlength="3"></div>
  <button>Pay Now</button>
</form>
```

**Q13. Custom checkbox/radio: ::before, ::after, ~ selector.**
```html
<style>
  .opt input { display: none; }
  .opt label { position: relative; padding-left: 30px; cursor: pointer; display: inline-block; margin: 8px; }
  .opt label::before { content: ""; position: absolute; left: 0; top: 0; width: 18px; height: 18px; border: 2px solid #2a6edb; border-radius: 4px; }
  .opt input[type=radio] ~ label::before { border-radius: 50%; }
  .opt input:checked ~ label::before { background: #2a6edb; }
  .opt input:checked ~ label::after { content: "\2713"; position: absolute; left: 4px; top: -1px; color: #fff; }
</style>
<div class="opt"><input type="checkbox" id="c1"><label for="c1">Coding</label></div>
<div class="opt"><input type="radio" name="r" id="r1"><label for="r1">Option A</label></div>
<div class="opt"><input type="radio" name="r" id="r2"><label for="r2">Option B</label></div>
```

**Q14. Range slider + number input, live unit label.**
```html
<label>Volume: <input type="range" id="rng" min="0" max="100" value="30"> <span id="rv">30</span> %</label><br><br>
<label>Weight: <input type="number" id="num" value="50"> kg</label> <b id="nv">50 kg</b>
<script>
  rng.oninput = () => rv.textContent = rng.value;
  num.oninput = () => nv.textContent = num.value + " kg";
</script>
```

**Q15. Search box jo focus par smoothly expand ho.**
```html
<style>
  .search { width: 150px; padding: 8px 12px; border: 2px solid #aaa; border-radius: 20px;
            transition: width 0.4s ease; outline: none; }
  .search:focus { width: 320px; border-color: #2a6edb; }
</style>
<input type="text" class="search" placeholder="Search...">
```

**Q16. Employee evaluation form: float aur clear.**
```html
<style>
  .form { width: 500px; margin: auto; }
  .f { float: left; width: 48%; margin: 1%; }
  .f input, .f select { width: 100%; padding: 8px; box-sizing: border-box; }
  .clear { clear: both; }
</style>
<form class="form">
  <div class="f"><label>Name</label><input></div>
  <div class="f"><label>Emp ID</label><input></div>
  <div class="f"><label>Department</label><input></div>
  <div class="f"><label>Rating</label><select><option>1</option><option>5</option></select></div>
  <div class="clear"></div>
  <button>Submit</button>
</form>
```

**Q17. Hidden input fields.**
```html
<form action="process.php" method="post">
  <input type="hidden" name="session_id" value="abc123xyz">
  <input type="hidden" name="user_id" value="45">
  <input type="text" name="comment" placeholder="Comment">
  <button>Send</button>
</form>
```
Hidden field user ko screen par nahi dikhta, par browser ke "Inspect" mein dikh jaata hai. Isliye isme sensitive/secret data mat rakho. Asli session ka data server par rakhna chahiye.

**Q18. Responsive Contact Us (Flexbox): ek taraf form, dusri taraf location.**
```html
<style>
  .contact { display: flex; gap: 20px; max-width: 800px; margin: 20px auto; }
  .contact > div { flex: 1; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
  .contact input, .contact textarea { width: 100%; padding: 8px; margin: 6px 0; box-sizing: border-box; }
  @media (max-width: 600px) { .contact { flex-direction: column; } }
</style>
<div class="contact">
  <div>
    <h3>Send a message</h3>
    <input placeholder="Name"><input placeholder="Email"><textarea rows="4" placeholder="Message"></textarea>
    <button>Send</button>
  </div>
  <div>
    <h3>Our Location</h3>
    <p>COER University<br>Roorkee, Uttarakhand<br>Phone: +91 00000 00000</p>
  </div>
</div>
```

**Q19. Typography rules: font-family, line-height, letter-spacing, text-transform.**
```html
<style>
  form { width: 350px; margin: 20px auto; }
  label { font-family: Georgia, serif; line-height: 1.8; letter-spacing: 1px; text-transform: uppercase; font-size: 13px; }
  input::placeholder { font-family: Verdana, sans-serif; letter-spacing: 0.5px; text-transform: capitalize; font-style: italic; }
  input { width: 100%; padding: 8px; margin-bottom: 10px; box-sizing: border-box; }
</style>
<form>
  <label>Full name</label><input placeholder="enter your name">
  <label>Email address</label><input placeholder="enter your email">
</form>
```

**Q20. Multi-step form (display none/block).**
```html
<style>
  .step { display: none; } .step.active { display: block; }
  .step input { padding: 8px; margin: 6px 0; }
</style>
<form>
  <div class="step active"><h3>Step 1: Account</h3><input placeholder="Username"><br><input type="password" placeholder="Password"></div>
  <div class="step"><h3>Step 2: Profile</h3><input placeholder="Full name"><br><input placeholder="City"></div>
  <div class="step"><h3>Step 3: Done</h3><p>Click Finish to complete.</p></div>
  <button type="button" onclick="go(-1)">Back</button>
  <button type="button" onclick="go(1)">Next</button>
</form>
<script>
  let i = 0; const s = document.querySelectorAll('.step');
  function go(d) { s[i].classList.remove('active'); i = Math.max(0, Math.min(s.length - 1, i + d)); s[i].classList.add('active'); }
</script>
```

**Q21. Accessible form: label for + input id.**
```html
<form>
  <label for="uname">Username:</label>
  <input type="text" id="uname" name="uname"><br><br>
  <label for="mail">Email:</label>
  <input type="email" id="mail" name="mail"><br><br>
  <label for="msg">Message:</label>
  <textarea id="msg" name="msg"></textarea>
</form>
```
`for` ki value hamesha input ke `id` ke barabar honi chahiye. Isse label par click karne se input focus ho jaata hai aur screen readers sahi padhte hain.

**Q22. Newsletter widget: floating label (CSS positioning).**
```html
<style>
  .fl { position: relative; width: 300px; margin: 30px; }
  .fl input { width: 100%; padding: 16px 10px 6px; border: 2px solid #ccc; border-radius: 6px; box-sizing: border-box; outline: none; }
  .fl label { position: absolute; left: 12px; top: 14px; color: #888; transition: all 0.2s; pointer-events: none; }
  .fl input:focus + label, .fl input:not(:placeholder-shown) + label { top: 2px; font-size: 11px; color: #2a6edb; }
  .fl input:focus { border-color: #2a6edb; }
</style>
<div class="fl">
  <input type="email" id="nl" placeholder=" ">
  <label for="nl">Your email</label>
</div>
<button>Subscribe</button>
```
