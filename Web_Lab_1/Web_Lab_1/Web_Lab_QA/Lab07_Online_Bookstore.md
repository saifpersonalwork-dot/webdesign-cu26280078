# Lab Sheet 7: Online Bookstore (PHP + MySQL)

**Project folder:** `/var/www/html/bookstore/` (XAMPP: `htdocs/bookstore/`). Sab files isi folder mein. URL: `http://localhost/bookstore/`.

Files ka overview:
```
bookstore/
  db.php  header.php  footer.php  style.css  validate.js
  index.php  book.php  register.php  login.php  logout.php
  cart.php  checkout.php  invoice.php  orders.php  wishlist.php  search.php
  admin/ books.php  orders.php  reports.php
  images/ (book covers)
```

**Common file `db.php`** (sab pages mein `require 'db.php';`)
```php
<?php
session_start();
$pdo = new PDO("mysql:host=localhost;dbname=bookstore;charset=utf8mb4", "root", "", [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);
function e($s) { return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }   // output sanitize
function require_login() { if (empty($_SESSION['uid'])) { header("Location: login.php"); exit; } }
function require_admin() { if (($_SESSION['role'] ?? '') !== 'admin') { die("Admins only"); } }
```

---

**Q1. Homepage: featured books, search bar, category navigation, promo banner (HTML + CSS).**
`header.php`
```php
<?php require_once __DIR__ . '/db.php'; ?>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BookNest</title><link rel="stylesheet" href="style.css"></head><body>
<header class="top">
  <a class="logo" href="index.php">BookNest</a>
  <form action="search.php" method="get" class="sbar"><input name="q" placeholder="Search title, author..."><button>Search</button></form>
  <nav>
    <a href="cart.php">Cart (<?= array_sum($_SESSION['cart'] ?? []) ?>)</a>
    <?php if (!empty($_SESSION['uid'])): ?>
      <a href="orders.php">My Orders</a><a href="wishlist.php">Wishlist</a><a href="logout.php">Logout</a>
    <?php else: ?><a href="login.php">Login</a><a href="register.php">Register</a><?php endif; ?>
  </nav>
</header>
<div class="cats"><a href="search.php?cat=Fiction">Fiction</a><a href="search.php?cat=Technology">Technology</a>
<a href="search.php?cat=Science">Science</a><a href="search.php?cat=History">History</a></div>
```
`index.php` (banner + featured books)
```php
<?php include 'header.php'; ?>
<section class="banner"><h1>Monsoon Sale</h1><p>Up to 30% off on bestsellers</p></section>
<h2 class="ttl">Featured Books</h2>
<div class="grid">
<?php foreach ($pdo->query("SELECT * FROM books ORDER BY id DESC LIMIT 8") as $b): ?>
  <div class="card">
    <img src="images/<?= e($b['image']) ?>" alt="<?= e($b['title']) ?>">
    <h3><a href="book.php?id=<?= $b['id'] ?>"><?= e($b['title']) ?></a></h3>
    <p><?= e($b['author']) ?></p><b>Rs. <?= e($b['price']) ?></b>
  </div>
<?php endforeach; ?>
</div>
<?php include 'footer.php'; ?>
```
`footer.php`: `<footer class="foot">&copy; 2026 BookNest</footer></body></html>`

`style.css` (custom CSS, Q19 mein poora dekho)
```css
body{margin:0;font-family:Arial,sans-serif;background:#f7f7fb}
.top{display:flex;gap:20px;align-items:center;padding:12px 24px;background:#1f2a44;color:#fff}
.top a{color:#fff;text-decoration:none;margin-right:12px}.logo{font-size:22px;font-weight:bold}
.sbar{flex:1}.sbar input{width:60%;padding:8px}.sbar button{padding:8px 14px}
.cats{background:#e9ecf6;padding:10px 24px}.cats a{margin-right:18px;text-decoration:none;color:#1f2a44}
.banner{background:linear-gradient(90deg,#ff8a00,#e52e71);color:#fff;text-align:center;padding:40px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:18px;padding:0 24px 24px}
.card{background:#fff;padding:12px;border-radius:8px;box-shadow:0 2px 6px rgba(0,0,0,.12);text-align:center}
.card img{width:100%;height:200px;object-fit:cover}.ttl{padding:0 24px}
.foot{text-align:center;padding:20px;background:#1f2a44;color:#fff;margin-top:30px}
```

**Q2. MySQL schema.**
```sql
CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE books (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  author VARCHAR(100) NOT NULL,
  category VARCHAR(50),
  price DECIMAL(8,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  image VARCHAR(100) DEFAULT 'default.jpg',
  description TEXT
);
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('customer','admin') DEFAULT 'customer'
);
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  address VARCHAR(255),
  status ENUM('Pending','Shipped','Delivered') DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL, book_id INT NOT NULL, qty INT NOT NULL, price DECIMAL(8,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id), FOREIGN KEY (book_id) REFERENCES books(id)
);
CREATE TABLE reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT NOT NULL, user_id INT NOT NULL, rating TINYINT NOT NULL, comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE wishlist (
  user_id INT NOT NULL, book_id INT NOT NULL, PRIMARY KEY (user_id, book_id)
);

INSERT INTO books (title, author, category, price, stock, image) VALUES
('Clean Code','Robert Martin','Technology',550,10,'clean.jpg'),
('The Alchemist','Paulo Coelho','Fiction',299,15,'alchemist.jpg'),
('A Brief History of Time','Stephen Hawking','Science',399,8,'time.jpg'),
('Sapiens','Yuval Harari','History',499,12,'sapiens.jpg');
```

**Q3. Books ko database se grid mein dikhao.** Q1 ka `index.php` yehi karta hai (`SELECT * FROM books` + CSS Grid). Saari books ke liye `LIMIT 8` hata do ya `books.php` mein use karo.

**Q4. Book detail page (GET id).** `book.php`
```php
<?php include 'header.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
$stmt = $pdo->prepare("SELECT * FROM books WHERE id = ?");
$stmt->execute([$id]);
$b = $stmt->fetch();
if (!$b) { die("Book not found"); }
?>
<div style="padding:24px">
  <img src="images/<?= e($b['image']) ?>" width="220" alt="">
  <h2><?= e($b['title']) ?></h2>
  <p>by <?= e($b['author']) ?> | <?= e($b['category']) ?></p>
  <h3>Rs. <?= e($b['price']) ?></h3>
  <p><?= $b['stock'] > 0 ? "In stock: " . (int)$b['stock'] : "<b style='color:red'>Out of stock</b>" ?></p>
  <form method="post" action="cart.php">
    <input type="hidden" name="book_id" value="<?= $b['id'] ?>">
    <input type="number" name="qty" value="1" min="1" max="<?= (int)$b['stock'] ?>">
    <button name="add">Add to Cart</button>
  </form>
  <form method="post" action="wishlist.php"><input type="hidden" name="book_id" value="<?= $b['id'] ?>"><button name="add">Add to Wishlist</button></form>
</div>
<!-- Reviews: Q15 -->
<?php include 'footer.php'; ?>
```

**Q5. Registration + login (password hash, secure session).**
`register.php`
```php
<?php include 'header.php';
$msg = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name']); $email = trim($_POST['email']); $pw = $_POST['password'];
    if (strlen($name) < 2 || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($pw) < 6) {
        $msg = "Invalid input.";
    } else {
        try {
            $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)")
                ->execute([$name, $email, password_hash($pw, PASSWORD_DEFAULT)]);
            header("Location: login.php"); exit;
        } catch (PDOException $ex) { $msg = "Email already registered."; }
    }
}
?>
<form method="post" id="regForm" style="padding:24px"><h2>Register</h2><p style="color:red"><?= e($msg) ?></p>
  <input name="name" placeholder="Name"><br><input name="email" placeholder="Email"><br>
  <input type="password" name="password" placeholder="Password"><br><button>Register</button></form>
<script src="validate.js"></script>
<?php include 'footer.php'; ?>
```
`login.php`
```php
<?php include 'header.php';
$msg = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $st = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $st->execute([$_POST['email']]);
    $u = $st->fetch();
    if ($u && password_verify($_POST['password'], $u['password'])) {
        session_regenerate_id(true);          // session fixation se bachav
        $_SESSION['uid'] = $u['id']; $_SESSION['name'] = $u['name']; $_SESSION['role'] = $u['role'];
        header("Location: index.php"); exit;
    }
    $msg = "Invalid email or password.";
}
?>
<form method="post" id="loginForm" style="padding:24px"><h2>Login</h2><p style="color:red"><?= e($msg) ?></p>
  <input name="email" placeholder="Email"><br><input type="password" name="password" placeholder="Password"><br><button>Login</button></form>
<script src="validate.js"></script>
<?php include 'footer.php'; ?>
```
`logout.php`: `<?php session_start(); session_destroy(); header("Location: index.php");`

Admin banane ke liye: register karke `UPDATE users SET role='admin' WHERE email='you@example.com';`

**Q6. Shopping cart (`$_SESSION['cart']`): add, update quantity, remove.**
`cart.php`
```php
<?php include 'header.php';
$cart = &$_SESSION['cart'];
if (!isset($cart)) $cart = [];

if (isset($_POST['add'])) {                       // add (stock check Q13)
    $id = (int)$_POST['book_id']; $qty = max(1, (int)$_POST['qty']);
    $stock = $pdo->prepare("SELECT stock FROM books WHERE id = ?"); $stock->execute([$id]);
    $avail = (int)$stock->fetchColumn();
    $new = ($cart[$id] ?? 0) + $qty;
    if ($new > $avail) { $new = $avail; echo "<p style='color:red;padding:0 24px'>Only $avail in stock.</p>"; }
    if ($new > 0) $cart[$id] = $new;
}
if (isset($_POST['update'])) {                    // update quantity
    foreach ($_POST['qty'] as $id => $q) { if ((int)$q <= 0) unset($cart[$id]); else $cart[(int)$id] = (int)$q; }
}
if (isset($_GET['remove'])) unset($cart[(int)$_GET['remove']]);   // remove

$total = 0;
?>
<form method="post" style="padding:24px"><h2>Your Cart</h2>
<table border="1" cellpadding="8"><tr><th>Book</th><th>Price</th><th>Qty</th><th>Subtotal</th><th></th></tr>
<?php foreach ($cart as $id => $qty):
    $s = $pdo->prepare("SELECT * FROM books WHERE id = ?"); $s->execute([$id]); $b = $s->fetch();
    $sub = $b['price'] * $qty; $total += $sub; ?>
  <tr><td><?= e($b['title']) ?></td><td><?= $b['price'] ?></td>
      <td><input type="number" name="qty[<?= $id ?>]" value="<?= $qty ?>" min="0" max="<?= $b['stock'] ?>"></td>
      <td><?= $sub ?></td><td><a href="cart.php?remove=<?= $id ?>">Remove</a></td></tr>
<?php endforeach; ?>
</table>
<p><b>Total: Rs. <?= $total ?></b></p>
<button name="update">Update Cart</button> <a href="checkout.php">Proceed to Checkout</a>
</form>
<?php include 'footer.php'; ?>
```

**Q7. Checkout: shipping details + order DB mein record.** `checkout.php`
```php
<?php include 'header.php'; require_login();
$cart = $_SESSION['cart'] ?? [];
if (!$cart) die("Cart is empty");
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $addr = trim($_POST['name']) . ", " . trim($_POST['address']) . ", " . trim($_POST['city']) . " - " . trim($_POST['pin']);
    try {
        $pdo->beginTransaction();
        $total = 0; $items = [];
        foreach ($cart as $id => $qty) {
            $s = $pdo->prepare("SELECT price, stock FROM books WHERE id = ? FOR UPDATE"); $s->execute([$id]); $b = $s->fetch();
            if ($b['stock'] < $qty) throw new Exception("Not enough stock for book #$id");
            $total += $b['price'] * $qty; $items[] = [$id, $qty, $b['price']];
        }
        $pdo->prepare("INSERT INTO orders (user_id, total, address) VALUES (?, ?, ?)")->execute([$_SESSION['uid'], $total, $addr]);
        $oid = $pdo->lastInsertId();
        foreach ($items as [$id, $qty, $price]) {
            $pdo->prepare("INSERT INTO order_items (order_id, book_id, qty, price) VALUES (?, ?, ?, ?)")->execute([$oid, $id, $qty, $price]);
            $pdo->prepare("UPDATE books SET stock = stock - ? WHERE id = ?")->execute([$qty, $id]);
        }
        $pdo->commit();
        unset($_SESSION['cart']);
        header("Location: invoice.php?id=$oid"); exit;
    } catch (Exception $ex) { $pdo->rollBack(); echo "<p style='color:red'>" . e($ex->getMessage()) . "</p>"; }
}
?>
<form method="post" id="checkoutForm" style="padding:24px"><h2>Shipping Details</h2>
  <input name="name" placeholder="Full name"><br><input name="address" placeholder="Address"><br>
  <input name="city" placeholder="City"><br><input name="pin" placeholder="PIN code"><br>
  <button>Place Order</button></form>
<script src="validate.js"></script>
<?php include 'footer.php'; ?>
```

**Q8. Admin dashboard: book add, price update, inventory.** `admin/books.php`
```php
<?php require '../db.php'; require_admin();
if (isset($_POST['add'])) {
    $pdo->prepare("INSERT INTO books (title, author, category, price, stock, image) VALUES (?, ?, ?, ?, ?, ?)")
        ->execute([$_POST['title'], $_POST['author'], $_POST['category'], $_POST['price'], $_POST['stock'], $_POST['image'] ?: 'default.jpg']);
}
if (isset($_POST['update'])) {
    $pdo->prepare("UPDATE books SET price = ?, stock = ? WHERE id = ?")->execute([$_POST['price'], $_POST['stock'], $_POST['id']]);
}
if (isset($_GET['del'])) { $pdo->prepare("DELETE FROM books WHERE id = ?")->execute([(int)$_GET['del']]); }
?>
<h2>Add Book</h2>
<form method="post"><input name="title" placeholder="Title" required><input name="author" placeholder="Author" required>
<input name="category" placeholder="Category"><input name="price" type="number" step="0.01" placeholder="Price" required>
<input name="stock" type="number" placeholder="Stock" required><input name="image" placeholder="image.jpg"><button name="add">Add</button></form>
<h2>Inventory</h2>
<table border="1" cellpadding="6"><tr><th>ID</th><th>Title</th><th>Price</th><th>Stock</th><th>Action</th></tr>
<?php foreach ($pdo->query("SELECT * FROM books") as $b): ?>
<tr><form method="post"><td><?= $b['id'] ?><input type="hidden" name="id" value="<?= $b['id'] ?>"></td>
<td><?= e($b['title']) ?></td>
<td><input name="price" value="<?= $b['price'] ?>" size="6"></td>
<td><input name="stock" value="<?= $b['stock'] ?>" size="4"></td>
<td><button name="update">Save</button> <a href="?del=<?= $b['id'] ?>" onclick="return confirm('Delete?')">Delete</a></td></form></tr>
<?php endforeach; ?></table>
```

**Q9. Admin: orders dekho + status update.** `admin/orders.php`
```php
<?php require '../db.php'; require_admin();
if (isset($_POST['status'])) {
    $pdo->prepare("UPDATE orders SET status = ? WHERE id = ?")->execute([$_POST['status'], $_POST['id']]);
}
$rows = $pdo->query("SELECT o.*, u.name FROM orders o JOIN users u ON u.id = o.user_id ORDER BY o.id DESC")->fetchAll();
?>
<h2>All Orders</h2>
<table border="1" cellpadding="6"><tr><th>#</th><th>Customer</th><th>Total</th><th>Date</th><th>Status</th></tr>
<?php foreach ($rows as $o): ?>
<tr><td><?= $o['id'] ?></td><td><?= e($o['name']) ?></td><td><?= $o['total'] ?></td><td><?= $o['created_at'] ?></td>
<td><form method="post"><input type="hidden" name="id" value="<?= $o['id'] ?>">
<select name="status"><?php foreach (['Pending','Shipped','Delivered'] as $s): ?>
<option <?= $o['status'] === $s ? 'selected' : '' ?>><?= $s ?></option><?php endforeach; ?></select>
<button>Update</button></form></td></tr>
<?php endforeach; ?></table>
```

**Q10. Search aur filter (title, author, category).** `search.php`
```php
<?php include 'header.php';
$q = trim($_GET['q'] ?? ''); $cat = $_GET['cat'] ?? '';
$sql = "SELECT * FROM books WHERE 1=1"; $p = [];
if ($q !== '')   { $sql .= " AND (title LIKE ? OR author LIKE ?)"; $p[] = "%$q%"; $p[] = "%$q%"; }
if ($cat !== '') { $sql .= " AND category = ?"; $p[] = $cat; }
$st = $pdo->prepare($sql); $st->execute($p);
?>
<h2 class="ttl">Results</h2><div class="grid">
<?php foreach ($st as $b): ?>
  <div class="card"><h3><a href="book.php?id=<?= $b['id'] ?>"><?= e($b['title']) ?></a></h3><p><?= e($b['author']) ?></p><b>Rs. <?= $b['price'] ?></b></div>
<?php endforeach; ?></div>
<?php include 'footer.php'; ?>
```

**Q11. Pagination.** Books list (`books.php`)
```php
<?php include 'header.php';
$per = 8;
$page = max(1, (int)($_GET['page'] ?? 1));
$total = (int)$pdo->query("SELECT COUNT(*) FROM books")->fetchColumn();
$pages = ceil($total / $per);
$st = $pdo->prepare("SELECT * FROM books ORDER BY id LIMIT :l OFFSET :o");
$st->bindValue(':l', $per, PDO::PARAM_INT); $st->bindValue(':o', ($page - 1) * $per, PDO::PARAM_INT);
$st->execute();
?>
<div class="grid"><?php foreach ($st as $b): ?>
  <div class="card"><h3><?= e($b['title']) ?></h3><b>Rs. <?= $b['price'] ?></b></div><?php endforeach; ?></div>
<p style="text-align:center">
<?php for ($i = 1; $i <= $pages; $i++): ?>
  <a href="?page=<?= $i ?>" <?= $i == $page ? 'style="font-weight:bold"' : '' ?>><?= $i ?></a>
<?php endfor; ?></p>
<?php include 'footer.php'; ?>
```

**Q12. Customer order history.** `orders.php`
```php
<?php include 'header.php'; require_login();
$st = $pdo->prepare("SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC"); $st->execute([$_SESSION['uid']]);
?>
<div style="padding:24px"><h2>My Orders</h2>
<table border="1" cellpadding="6"><tr><th>Order</th><th>Date</th><th>Total</th><th>Status</th><th></th></tr>
<?php foreach ($st as $o): ?>
<tr><td>#<?= $o['id'] ?></td><td><?= $o['created_at'] ?></td><td>Rs. <?= $o['total'] ?></td><td><?= $o['status'] ?></td>
<td><a href="invoice.php?id=<?= $o['id'] ?>">View</a></td></tr>
<?php endforeach; ?></table></div>
<?php include 'footer.php'; ?>
```

**Q13. Stock check (cart mein available stock se zyada nahi).** Q6 ke `cart.php` mein `add` block yehi karta hai: `$new > $avail` hone par quantity stock tak limit hoti hai aur message dikhta hai. Checkout (Q7) mein dobara `FOR UPDATE` ke saath check hota hai, taaki do users ek saath last copy na kharid sakein. Book page par `max="<?= $b['stock'] ?>"` bhi laga hai.

**Q14. Input sanitization aur prepared statements.**
Poore project mein ye rules follow hue hain:
- Har query mein `prepare()` + `?` ya `:name` placeholders (kahin bhi `"... $_GET[x] ..."` nahi).
- Output par `e()` (`htmlspecialchars`) taaki XSS na ho.
- `filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT)`, `FILTER_VALIDATE_EMAIL`, `(int)` casts.
- Passwords `password_hash`, login par `session_regenerate_id(true)`.
Galat vs sahi:
```php
// Galat: injection ho sakta hai
$pdo->query("SELECT * FROM books WHERE id = " . $_GET['id']);
// Sahi
$st = $pdo->prepare("SELECT * FROM books WHERE id = ?"); $st->execute([(int)$_GET['id']]);
```

**Q15. Review aur rating system.** `book.php` mein "Reviews" comment ki jagah daalo:
```php
<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['review'])) {
    require_login();
    $r = max(1, min(5, (int)$_POST['rating']));
    $pdo->prepare("INSERT INTO reviews (book_id, user_id, rating, comment) VALUES (?, ?, ?, ?)")
        ->execute([$b['id'], $_SESSION['uid'], $r, trim($_POST['comment'])]);
}
$avg = $pdo->prepare("SELECT ROUND(AVG(rating),1) a, COUNT(*) c FROM reviews WHERE book_id = ?"); $avg->execute([$b['id']]); $a = $avg->fetch();
$rv = $pdo->prepare("SELECT r.*, u.name FROM reviews r JOIN users u ON u.id = r.user_id WHERE book_id = ? ORDER BY r.id DESC");
$rv->execute([$b['id']]);
?>
<div style="padding:0 24px"><h3>Reviews (<?= $a['c'] ?>) - Average: <?= $a['a'] ?? '-' ?>/5</h3>
<?php foreach ($rv as $x): ?>
  <p><b><?= e($x['name']) ?></b> <?= str_repeat('&#9733;', $x['rating']) . str_repeat('&#9734;', 5 - $x['rating']) ?><br><?= e($x['comment']) ?></p>
<?php endforeach; ?>
<?php if (!empty($_SESSION['uid'])): ?>
<form method="post"><select name="rating"><option>5</option><option>4</option><option>3</option><option>2</option><option>1</option></select>
<textarea name="comment" placeholder="Your review"></textarea><button name="review">Submit Review</button></form>
<?php endif; ?></div>
```

**Q16. Order ke baad invoice summary.** `invoice.php`
```php
<?php include 'header.php'; require_login();
$id = (int)$_GET['id'];
$o = $pdo->prepare("SELECT * FROM orders WHERE id = ? AND user_id = ?"); $o->execute([$id, $_SESSION['uid']]); $order = $o->fetch();
if (!$order) die("Order not found");
$it = $pdo->prepare("SELECT oi.*, b.title FROM order_items oi JOIN books b ON b.id = oi.book_id WHERE order_id = ?"); $it->execute([$id]);
?>
<div style="padding:24px"><h2>Invoice #<?= $order['id'] ?></h2>
<p>Date: <?= $order['created_at'] ?><br>Ship to: <?= e($order['address']) ?><br>Status: <?= $order['status'] ?></p>
<table border="1" cellpadding="6"><tr><th>Book</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr>
<?php foreach ($it as $i): ?>
<tr><td><?= e($i['title']) ?></td><td><?= $i['qty'] ?></td><td><?= $i['price'] ?></td><td><?= $i['qty'] * $i['price'] ?></td></tr>
<?php endforeach; ?>
<tr><td colspan="3"><b>Grand Total</b></td><td><b>Rs. <?= $order['total'] ?></b></td></tr></table>
<p><button onclick="window.print()">Print Invoice</button></p></div>
<?php include 'footer.php'; ?>
```

**Q17. Wishlist.** `wishlist.php`
```php
<?php include 'header.php'; require_login();
if (isset($_POST['add']))   $pdo->prepare("INSERT IGNORE INTO wishlist (user_id, book_id) VALUES (?, ?)")->execute([$_SESSION['uid'], (int)$_POST['book_id']]);
if (isset($_GET['remove'])) $pdo->prepare("DELETE FROM wishlist WHERE user_id = ? AND book_id = ?")->execute([$_SESSION['uid'], (int)$_GET['remove']]);
$st = $pdo->prepare("SELECT b.* FROM wishlist w JOIN books b ON b.id = w.book_id WHERE w.user_id = ?"); $st->execute([$_SESSION['uid']]);
?>
<div style="padding:24px"><h2>My Wishlist</h2>
<?php foreach ($st as $b): ?>
  <p><a href="book.php?id=<?= $b['id'] ?>"><?= e($b['title']) ?></a> - Rs. <?= $b['price'] ?> <a href="?remove=<?= $b['id'] ?>">Remove</a></p>
<?php endforeach; ?></div>
<?php include 'footer.php'; ?>
```

**Q18. JavaScript client-side validation (register, login, checkout).** `validate.js`
```javascript
function bad(msg) { alert(msg); return false; }
document.addEventListener("DOMContentLoaded", () => {
  const reg = document.getElementById("regForm");
  if (reg) reg.onsubmit = () => {
    if (reg.name.value.trim().length < 2) return bad("Enter a valid name");
    if (!/^[^@\s]+@[^@\s]+\.[a-z]{2,}$/i.test(reg.email.value)) return bad("Enter a valid email");
    if (reg.password.value.length < 6) return bad("Password must be at least 6 characters");
  };
  const login = document.getElementById("loginForm");
  if (login) login.onsubmit = () => {
    if (!login.email.value || !login.password.value) return bad("Email and password required");
  };
  const co = document.getElementById("checkoutForm");
  if (co) co.onsubmit = () => {
    if (!co.name.value.trim() || !co.address.value.trim() || !co.city.value.trim()) return bad("Fill all shipping details");
    if (!/^[0-9]{6}$/.test(co.pin.value)) return bad("PIN code must be 6 digits");
  };
});
```
Client-side validation sirf user ki suvidha ke liye hai. Server par bhi validation zaroori hai (jo upar PHP mein hai).

**Q19. Poori application ko ek external CSS framework se style karo (Bootstrap).**
`header.php` ke `<head>` mein ye line jodo:
```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
```
Phir classes lagao, jaise:
```html
<nav class="navbar navbar-dark bg-dark px-3"> ... </nav>
<div class="container"><div class="row">
  <div class="col-md-3"><div class="card"><img class="card-img-top" src="..."><div class="card-body">
    <h5 class="card-title">Title</h5><a class="btn btn-primary" href="#">View</a></div></div></div>
</div></div>
<table class="table table-striped"> ... </table>
<form> <input class="form-control"> <button class="btn btn-success">Submit</button> </form>
```
Ya poore project mein ek hi `style.css` consistent use karo (jaise Q1 mein). Dono mein se koi ek chalega, mix mat karo.

**Q20. End-to-end user journey test checklist.**
| Step | Kya karna hai | Expected result |
|------|---------------|-----------------|
| 1 | `index.php` kholo | Banner aur featured books dikhein |
| 2 | Search box mein "Clean" likho | Sirf matching book aaye |
| 3 | Book par click, "Add to Cart" | Cart count 1 ho |
| 4 | Stock se zyada qty daalo | Warning aaye aur limit ho jaye |
| 5 | Checkout par jao (bina login) | Login page par redirect |
| 6 | Register, phir Login | Home par wapas, navbar mein Logout dikhe |
| 7 | Shipping details bharke Place Order | Invoice page khule |
| 8 | `orders.php` kholo | Naya order "Pending" dikhe |
| 9 | Admin se status "Shipped" karo | User ko updated status dikhe |
| 10 | DB mein `books.stock` check karo | Order ke hisaab se kam ho gaya ho |
Har step ka screenshot lo.

**Q21. Admin: sales summary aur total revenue.** `admin/reports.php`
```php
<?php require '../db.php'; require_admin();
$sum = $pdo->query("SELECT COUNT(*) orders, COALESCE(SUM(total),0) revenue FROM orders")->fetch();
$top = $pdo->query("SELECT b.title, SUM(oi.qty) sold, SUM(oi.qty * oi.price) amt
                    FROM order_items oi JOIN books b ON b.id = oi.book_id
                    GROUP BY b.id ORDER BY sold DESC LIMIT 5");
$daily = $pdo->query("SELECT DATE(created_at) d, COUNT(*) n, SUM(total) t FROM orders GROUP BY DATE(created_at) ORDER BY d DESC LIMIT 7");
?>
<h2>Sales Report</h2>
<p>Total orders: <b><?= $sum['orders'] ?></b> | Total revenue: <b>Rs. <?= $sum['revenue'] ?></b></p>
<h3>Top selling books</h3>
<table border="1" cellpadding="6"><tr><th>Book</th><th>Sold</th><th>Amount</th></tr>
<?php foreach ($top as $r): ?><tr><td><?= e($r['title']) ?></td><td><?= $r['sold'] ?></td><td><?= $r['amt'] ?></td></tr><?php endforeach; ?></table>
<h3>Last 7 days</h3>
<table border="1" cellpadding="6"><tr><th>Date</th><th>Orders</th><th>Revenue</th></tr>
<?php foreach ($daily as $r): ?><tr><td><?= $r['d'] ?></td><td><?= $r['n'] ?></td><td><?= $r['t'] ?></td></tr><?php endforeach; ?></table>
```
