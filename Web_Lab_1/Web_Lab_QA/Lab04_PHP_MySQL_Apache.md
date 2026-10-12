# Lab Sheet 4: Apache + PHP + MySQL

**Setup (Ubuntu):**
```bash
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-mbstring php-curl mariadb-server
sudo systemctl start apache2 mariadb
```
Project folder: `/var/www/html/lab4` (XAMPP par: `C:\xampp\htdocs\lab4`). Test URL: `http://localhost/lab4/`.

**Common file `db.php`** (baaki scripts mein `require 'db.php';` se use hota hai):
```php
<?php
$dsn = "mysql:host=localhost;dbname=college_db;charset=utf8mb4";
try {
    $pdo = new PDO($dsn, "root", "", [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
```
(Ubuntu mein root ko password dena pad sakta hai, ya naya user banao, Q14 dekho.)

**Q1. Apache configure/verify karo, default page `http://localhost` par load ho.**
```bash
sudo systemctl status apache2          # active (running)
curl -I http://localhost               # HTTP/1.1 200 OK
```
Browser mein `http://localhost` kholo: "Apache2 Default Page" dikhna chahiye. Khud ka test page:
```bash
echo "<h1>Apache works</h1>" | sudo tee /var/www/html/index.html
```
`index.php` aur `index.html` dono hon to Apache ki `DirectoryIndex` setting decide karti hai (Ubuntu mein `index.html` pehle aata hai).

**Q2. php.ini mein `display_errors = On` aur `phpinfo()` se verify.**
```bash
php --ini                                       # php.ini ka path
sudo nano /etc/php/*/apache2/php.ini            # XAMPP: C:\xampp\php\php.ini
```
Badlo: `display_errors = On` aur `error_reporting = E_ALL`. Phir `sudo systemctl restart apache2`.
`info.php`
```php
<?php phpinfo(); ?>
```
`http://localhost/lab4/info.php` mein "display_errors" search karo, value `On` honi chahiye. Test ke baad `info.php` delete kar do, kyunki ye server ki jaankari dikhata hai.

**Q3. MySQL install/connect karo aur `college_db` banao.**
```bash
sudo mysql                       # ya: mysql -u root -p
```
```sql
CREATE DATABASE college_db;
SHOW DATABASES;
USE college_db;
```
(phpMyAdmin mein: New → Database name `college_db` → Create.)

**Q4. PDO se secure connection (success status).**
`connect.php`
```php
<?php
require 'db.php';
echo "Connected successfully to " . $pdo->query("SELECT DATABASE()")->fetchColumn();
```
PDO + exceptions + `charset=utf8mb4` use karna secure aur reliable tarika hai. Credentials code mein chhodne ke bajaye config file ya environment variable mein rakhna behtar hai.

**Q5. `students` table (PHP script se).**
`create_table.php`
```php
<?php
require 'db.php';
$sql = "CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    enrollment_date DATE NOT NULL
)";
$pdo->exec($sql);
echo "Table students ready.";
```

**Q6. Prepared statement se insert.**
`insert.php`
```php
<?php
require 'db.php';
$stmt = $pdo->prepare("INSERT INTO students (name, email, enrollment_date) VALUES (:name, :email, :date)");
$stmt->execute([':name' => 'Amit Kumar', ':email' => 'amit@example.com', ':date' => date('Y-m-d')]);
echo "Inserted ID: " . $pdo->lastInsertId();
```
Prepared statement mein SQL aur data alag jaate hain, isliye SQL injection nahi hota.

**Q7. Saare records styled HTML table mein.**
`view.php`
```php
<?php
require 'db.php';
$rows = $pdo->query("SELECT * FROM students ORDER BY id")->fetchAll();
?>
<style>
 table{border-collapse:collapse;width:80%;margin:20px auto;font-family:Arial}
 th,td{border:1px solid #ccc;padding:8px} th{background:#2a6edb;color:#fff}
 tr:nth-child(even){background:#f2f6ff}
</style>
<table>
 <tr><th>ID</th><th>Name</th><th>Email</th><th>Enrollment Date</th></tr>
 <?php foreach ($rows as $r): ?>
 <tr>
   <td><?= $r['id'] ?></td>
   <td><?= htmlspecialchars($r['name']) ?></td>
   <td><?= htmlspecialchars($r['email']) ?></td>
   <td><?= $r['enrollment_date'] ?></td>
 </tr>
 <?php endforeach; ?>
</table>
```

**Q8. Student ID se email update.**
`update.php`
```php
<?php
require 'db.php';
$stmt = $pdo->prepare("UPDATE students SET email = :email WHERE id = :id");
$stmt->execute([':email' => 'newmail@example.com', ':id' => 1]);
echo $stmt->rowCount() . " row(s) updated.";
```

**Q9. URL parameter (GET) se delete.**
`delete.php` (use: `delete.php?id=3`)
```php
<?php
require 'db.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id) { die("Invalid ID"); }
$stmt = $pdo->prepare("DELETE FROM students WHERE id = ?");
$stmt->execute([$id]);
echo $stmt->rowCount() ? "Deleted." : "No such record.";
```
Real projects mein delete ke liye GET ke bajaye POST + CSRF token use karna chahiye. Sheet ki demo ke liye GET theek hai.

**Q10. Virtual host `collegeweb.local`.**
```bash
sudo mkdir -p /var/www/collegeweb && echo "<h1>College Web</h1>" | sudo tee /var/www/collegeweb/index.html
sudo nano /etc/apache2/sites-available/collegeweb.conf
```
```apache
<VirtualHost *:80>
    ServerName collegeweb.local
    DocumentRoot /var/www/collegeweb
    ErrorLog ${APACHE_LOG_DIR}/collegeweb-error.log
    CustomLog ${APACHE_LOG_DIR}/collegeweb-access.log combined
</VirtualHost>
```
```bash
sudo a2ensite collegeweb.conf
echo "127.0.0.1 collegeweb.local" | sudo tee -a /etc/hosts
sudo apache2ctl configtest && sudo systemctl reload apache2
```
(XAMPP: `C:\xampp\apache\conf\extra\httpd-vhosts.conf` mein same block dalo aur `C:\Windows\System32\drivers\etc\hosts` mein entry add karo.) Browser mein `http://collegeweb.local`.

**Q11. `$_SERVER` se server details.**
`server_info.php`
```php
<?php
echo "Server software: " . $_SERVER['SERVER_SOFTWARE'] . "<br>";
echo "Server name: "     . $_SERVER['SERVER_NAME'] . "<br>";
echo "Server IP: "       . $_SERVER['SERVER_ADDR'] . "<br>";
echo "Document root: "   . $_SERVER['DOCUMENT_ROOT'] . "<br>";
echo "Request method: "  . $_SERVER['REQUEST_METHOD'] . "<br>";
echo "Client IP: "       . $_SERVER['REMOTE_ADDR'] . "<br>";
echo "PHP version: "     . phpversion();
```

**Q12. MySQL records se user authentication.**
```sql
USE college_db;
CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password VARCHAR(255));
```
`login.php`
```php
<?php
require 'db.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
    $stmt->execute([$_POST['username']]);
    $user = $stmt->fetch();
    echo ($user && password_verify($_POST['password'], $user['password'])) ? "Login successful" : "Invalid credentials";
}
?>
<form method="post">
  <input name="username" placeholder="Username" required><br>
  <input type="password" name="password" placeholder="Password" required><br>
  <button>Login</button>
</form>
```
(Users ko `password_hash()` se insert karna hai, Q21 dekho.)

**Q13. File upload: size aur extension validate.**
`upload.php`
```php
<?php
$msg = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['img'])) {
    $f = $_FILES['img'];
    $ext = strtolower(pathinfo($f['name'], PATHINFO_EXTENSION));
    $allowed = ['jpg', 'jpeg', 'png', 'gif'];
    if ($f['error'] !== UPLOAD_ERR_OK)          $msg = "Upload error.";
    elseif (!in_array($ext, $allowed))          $msg = "Only JPG, PNG, GIF allowed.";
    elseif ($f['size'] > 2 * 1024 * 1024)       $msg = "File too large (max 2 MB).";
    else {
        @mkdir("uploads", 0755);
        $new = uniqid("img_") . "." . $ext;
        move_uploaded_file($f['tmp_name'], "uploads/" . $new);
        $msg = "Uploaded as $new";
    }
}
echo $msg;
?>
<form method="post" enctype="multipart/form-data">
  <input type="file" name="img"><button>Upload</button>
</form>
```
Ubuntu par `uploads/` folder ko Apache user likh sake: `sudo chown www-data:www-data uploads`.

**Q14. Restricted MySQL user (SELECT, INSERT, UPDATE).**
```sql
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'StrongPass#123';
GRANT SELECT, INSERT, UPDATE ON college_db.* TO 'webapp'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'webapp'@'localhost';
```
Verify: `mysql -u webapp -p college_db` aur `DELETE FROM students;` chalao, "command denied" aana chahiye. Ab `db.php` mein `root` ki jagah `webapp` use kar sakte ho.

**Q15. Session management.**
`s_login.php`
```php
<?php
session_start();
$_SESSION['user'] = 'amit';
echo "Logged in. <a href='s_page.php'>Go to page</a>";
```
`s_page.php`
```php
<?php
session_start();
echo isset($_SESSION['user']) ? "Welcome, " . htmlspecialchars($_SESSION['user']) . " <a href='s_logout.php'>Logout</a>" : "Please login first.";
```
`s_logout.php`
```php
<?php
session_start(); session_unset(); session_destroy();
echo "Logged out.";
```

**Q16. Cookie: theme color.**
`theme.php`
```php
<?php
if (isset($_POST['theme'])) {
    setcookie('theme', $_POST['theme'], time() + 86400 * 30, "/");
    $_COOKIE['theme'] = $_POST['theme'];
}
$theme = $_COOKIE['theme'] ?? 'white';
?>
<body style="background:<?= htmlspecialchars($theme) ?>">
<form method="post">
  <select name="theme"><option>white</option><option>lightblue</option><option>lightgreen</option></select>
  <button>Save theme</button>
</form>
<p>Current theme: <?= htmlspecialchars($theme) ?></p>
</body>
```

**Q17. Table data ko CSV download.**
`export.php`
```php
<?php
require 'db.php';
header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="students.csv"');
$out = fopen('php://output', 'w');
fputcsv($out, ['ID', 'Name', 'Email', 'Enrollment Date']);
foreach ($pdo->query("SELECT * FROM students") as $row) fputcsv($out, $row);
fclose($out);
```

**Q18. Apache error.log aur access.log.**
```bash
sudo tail -f /var/log/apache2/access.log     # XAMPP: C:\xampp\apache\logs\access.log
sudo tail -f /var/log/apache2/error.log
# doosre terminal se requests bhejo:
for i in {1..10}; do curl -s -o /dev/null http://localhost/; done
curl -s -o /dev/null http://localhost/nopage.php       # 404 error generate
ab -n 100 -c 10 http://localhost/                      # performance test (apache2-utils install karo)
```
access.log mein har request ki entry (IP, time, URL, status code 200/404) aati hai. error.log mein PHP errors aur missing files dikhte hain.

**Q19. Transaction (beginTransaction, commit, rollBack).**
```sql
CREATE TABLE accounts (id INT PRIMARY KEY, balance DECIMAL(10,2));
INSERT INTO accounts VALUES (1, 1000), (2, 500);
```
`transfer.php`
```php
<?php
require 'db.php';
try {
    $pdo->beginTransaction();
    $pdo->prepare("UPDATE accounts SET balance = balance - ? WHERE id = ?")->execute([200, 1]);
    $pdo->prepare("UPDATE accounts SET balance = balance + ? WHERE id = ?")->execute([200, 2]);
    $pdo->commit();
    echo "Transfer successful";
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Failed, rolled back: " . $e->getMessage();
}
```
Dono updates ya to saath mein hote hain ya koi bhi nahi.

**Q20. PHP extensions (mysqli, pdo_mysql, mbstring, curl).**
```bash
php -m | grep -E "mysqli|pdo_mysql|mbstring|curl"
sudo phpenmod mysqli pdo_mysql mbstring curl      # enable
sudo systemctl restart apache2
```
`php.ini` mein (XAMPP): `extension=mysqli`, `extension=pdo_mysql`, `extension=mbstring`, `extension=curl` (semicolon `;` hatao). Script se verify:
```php
<?php
foreach (['mysqli', 'pdo_mysql', 'mbstring', 'curl'] as $e)
    echo $e . ": " . (extension_loaded($e) ? "ENABLED" : "missing") . "<br>";
```

**Q21. `password_hash()` aur `password_verify()`.**
`register.php`
```php
<?php
require 'db.php';
$hash = password_hash("MySecret123", PASSWORD_DEFAULT);
$stmt = $pdo->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
$stmt->execute(['amit', $hash]);
echo "User saved. Hash: " . $hash;
```
`check.php`
```php
<?php
require 'db.php';
$stmt = $pdo->prepare("SELECT password FROM users WHERE username = ?");
$stmt->execute(['amit']);
$hash = $stmt->fetchColumn();
echo password_verify("MySecret123", $hash) ? "Password correct" : "Wrong password";
```
Password kabhi plain text mein store nahi karte. `password_hash` har baar alag salt ke saath hash banata hai.
