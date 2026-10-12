# Lab Sheet 3: JavaScript

Har example `.html` file mein save karke browser mein kholo. Console dekhne ke liye `F12`.

**Q1. Do numbers (prompt), arithmetic, console.log aur alert.**
```html
<script>
  let a = parseFloat(prompt("Enter first number:"));
  let b = parseFloat(prompt("Enter second number:"));
  let res = `Sum=${a + b}, Diff=${a - b}, Product=${a * b}, Quotient=${(a / b).toFixed(2)}`;
  console.log(res);
  alert(res);
</script>
```

**Q2. Prime ya composite, div mein output.**
```html
<input type="number" id="n"> <button onclick="check()">Check</button>
<div id="out"></div>
<script>
  function check() {
    let n = parseInt(document.getElementById("n").value), prime = n > 1;
    for (let i = 2; i * i <= n; i++) if (n % i === 0) { prime = false; break; }
    document.getElementById("out").innerText = n < 2 ? n + " is neither prime nor composite" : n + (prime ? " is Prime" : " is Composite");
  }
</script>
```

**Q3. Grade (if-else aur switch).**
```html
<script>
  let marks = parseInt(prompt("Enter marks (0-100):"));
  // if-else
  let g;
  if (marks >= 90) g = "A+"; else if (marks >= 80) g = "A"; else if (marks >= 70) g = "B";
  else if (marks >= 60) g = "C"; else if (marks >= 40) g = "D"; else g = "F";
  // switch
  let remark;
  switch (g) { case "A+": case "A": remark = "Excellent"; break; case "B": case "C": remark = "Good"; break;
               case "D": remark = "Pass"; break; default: remark = "Fail"; }
  document.write(`Grade: ${g} (${remark})`);
</script>
```

**Q4. Fibonacci: for, while, do-while.**
```html
<script>
  let n = 10, out = "";
  // for
  let a = 0, b = 1; out += "for: ";
  for (let i = 0; i < n; i++) { out += a + " "; [a, b] = [b, a + b]; }
  // while
  a = 0; b = 1; let i = 0; out += "<br>while: ";
  while (i < n) { out += a + " "; [a, b] = [b, a + b]; i++; }
  // do-while
  a = 0; b = 1; i = 0; out += "<br>do-while: ";
  do { out += a + " "; [a, b] = [b, a + b]; i++; } while (i < n);
  document.write(out);
</script>
```

**Q5. String reverse aur palindrome.**
```html
<script>
  function check(s) {
    let rev = s.split("").reverse().join("");
    let clean = s.toLowerCase().replace(/[^a-z0-9]/g, "");
    let isPal = clean === clean.split("").reverse().join("");
    return `Reversed: ${rev} | ${isPal ? "Palindrome" : "Not a palindrome"}`;
  }
  document.write(check(prompt("Enter a string:")));
</script>
```

**Q6. Array methods: push, pop, sort, map, filter.**
```html
<script>
  let arr = [5, 3, 8, 1];
  arr.push(10);                       // add end
  arr.pop();                          // remove end
  arr.unshift(0);                     // add start
  arr.shift();                        // remove start
  arr.sort((x, y) => x - y);          // sort ascending
  let doubled = arr.map(x => x * 2);
  let evens = arr.filter(x => x % 2 === 0);
  console.log(arr, doubled, evens);
</script>
```

**Q7. Student object aur `this`.**
```html
<script>
  const student = {
    name: "Amit", roll: 101, marks: [80, 75, 90],
    average() { return this.marks.reduce((s, m) => s + m, 0) / this.marks.length; },
    show() { return `${this.name} (${this.roll}) average: ${this.average().toFixed(2)}`; }
  };
  console.log(student.show());
</script>
```
Method ke andar `this` us object ko point karta hai jisne method call kiya (yahan `student`).

**Q8. Calculator (addEventListener).**
```html
<input id="d" readonly><br>
<div id="keys"></div>
<script>
  const keys = ["7","8","9","/","4","5","6","*","1","2","3","-","0",".","=","+","C"];
  const box = document.getElementById("keys"), d = document.getElementById("d");
  keys.forEach(k => {
    const b = document.createElement("button"); b.textContent = k; box.appendChild(b);
    b.addEventListener("click", () => {
      if (k === "C") d.value = "";
      else if (k === "=") { try { d.value = Function('"use strict";return (' + d.value + ')')(); } catch { d.value = "Error"; } }
      else d.value += k;
    });
  });
</script>
```

**Q9. createElement + appendChild (user input se).**
```html
<input id="t" placeholder="Type text"> <button id="add">Add</button>
<div id="list"></div>
<script>
  document.getElementById("add").addEventListener("click", () => {
    const p = document.createElement("p");
    p.textContent = document.getElementById("t").value;
    document.getElementById("list").appendChild(p);
  });
</script>
```

**Q10. Password aur confirm password match validation.**
```html
<form id="f">
  <input type="password" id="p1" placeholder="Password"><br>
  <input type="password" id="p2" placeholder="Confirm password">
  <span id="msg"></span><br>
  <button>Submit</button>
</form>
<script>
  const p1 = document.getElementById("p1"), p2 = document.getElementById("p2"), msg = document.getElementById("msg");
  p2.addEventListener("input", () => {
    msg.textContent = p1.value === p2.value ? "Match" : "Do not match";
    msg.style.color = p1.value === p2.value ? "green" : "red";
  });
  document.getElementById("f").addEventListener("submit", e => {
    if (p1.value !== p2.value) { e.preventDefault(); alert("Passwords do not match!"); }
  });
</script>
```

**Q11. mouseover / mouseout par background color.**
```html
<div id="box" style="width:200px;height:100px;background:lightblue;">Hover me</div>
<script>
  const box = document.getElementById("box");
  box.addEventListener("mouseover", () => box.style.background = "orange");
  box.addEventListener("mouseout", () => box.style.background = "lightblue");
</script>
```

**Q12. Digital clock (setInterval + Date).**
```html
<h1 id="clock"></h1>
<script>
  function tick() { document.getElementById("clock").textContent = new Date().toLocaleTimeString(); }
  tick(); setInterval(tick, 1000);
</script>
```

**Q13. Closure: private counter.**
```html
<script>
  function createCounter() {
    let count = 0;                      // private variable
    return {
      increment: () => ++count,
      decrement: () => --count,
      value: () => count
    };
  }
  const c = createCounter();
  c.increment(); c.increment(); c.decrement();
  console.log(c.value());               // 1
  console.log(c.count);                 // undefined, bahar se access nahi
</script>
```

**Q14. try...catch...finally (JSON parse).**
```html
<script>
  function parse(str) {
    try { const obj = JSON.parse(str); console.log("Parsed:", obj); }
    catch (e) { console.log("Invalid JSON:", e.message); }
    finally { console.log("Parsing attempt finished"); }
  }
  parse('{"name":"Amit","age":22}');   // valid
  parse('{name: Amit}');               // invalid
</script>
```

**Q15. ES6: arrow function, template literal, destructuring.**
```html
<script>
  const add = (a, b) => a + b;
  const person = { name: "Neha", age: 21, city: "Roorkee" };
  const { name, age } = person;                 // object destructuring
  const [x, y, ...rest] = [1, 2, 3, 4, 5];      // array destructuring
  console.log(`${name} is ${age}. Sum = ${add(x, y)}. Rest = ${rest}`);
</script>
```

**Q16. Image gallery slider (Next/Previous).**
```html
<img id="pic" width="300"><br>
<button id="prev">Previous</button> <button id="next">Next</button>
<script>
  const imgs = ["images/1.jpg", "images/2.jpg", "images/3.jpg"];
  let i = 0; const pic = document.getElementById("pic");
  const show = () => pic.src = imgs[i];
  document.getElementById("next").onclick = () => { i = (i + 1) % imgs.length; show(); };
  document.getElementById("prev").onclick = () => { i = (i - 1 + imgs.length) % imgs.length; show(); };
  show();
</script>
```

**Q17. Paragraph mein vowels count.**
```html
<script>
  function countVowels(text) {
    const m = text.match(/[aeiou]/gi);
    return m ? m.length : 0;
  }
  console.log(countVowels("JavaScript is a wonderful language"));
</script>
```

**Q18. Todo list (add/delete).**
```html
<input id="task" placeholder="New task"> <button id="addBtn">Add</button>
<ul id="todo"></ul>
<script>
  document.getElementById("addBtn").onclick = () => {
    const t = document.getElementById("task");
    if (!t.value.trim()) return;
    const li = document.createElement("li");
    li.textContent = t.value + " ";
    const del = document.createElement("button");
    del.textContent = "Delete";
    del.onclick = () => li.remove();
    li.appendChild(del);
    document.getElementById("todo").appendChild(li);
    t.value = "";
  };
</script>
```

**Q19. keydown/keyup: key code aur character.**
```html
<p>Press any key:</p>
<div id="info"></div>
<script>
  document.addEventListener("keydown", e => {
    document.getElementById("info").innerHTML = `keydown -> key: <b>${e.key}</b>, code: ${e.code}, keyCode: ${e.keyCode}`;
  });
  document.addEventListener("keyup", e => {
    document.getElementById("info").innerHTML += `<br>keyup -> key: <b>${e.key}</b>`;
  });
</script>
```

**Q20. Dynamic table generator (rows aur columns user se).**
```html
Rows: <input type="number" id="r" value="3"> Cols: <input type="number" id="c" value="3">
<button onclick="gen()">Generate</button>
<div id="tbl"></div>
<script>
  function gen() {
    const r = +document.getElementById("r").value, c = +document.getElementById("c").value;
    let h = "<table border='1' cellpadding='6'>";
    for (let i = 1; i <= r; i++) {
      h += "<tr>";
      for (let j = 1; j <= c; j++) h += `<td>R${i}C${j}</td>`;
      h += "</tr>";
    }
    document.getElementById("tbl").innerHTML = h + "</table>";
  }
</script>
```

**Q21. Callback aur setTimeout (asynchronous).**
```html
<script>
  function greet(name, callback) {
    console.log("Hello " + name);
    callback();
  }
  greet("Amit", () => console.log("Callback executed"));

  console.log("Start");
  setTimeout(() => console.log("Runs after 2 seconds"), 2000);
  console.log("End");
  // Output order: Start, End, (2 sec baad) Runs after 2 seconds
</script>
```
`setTimeout` asynchronous hai, isliye baaki code rukta nahi aur callback baad mein chalta hai.
