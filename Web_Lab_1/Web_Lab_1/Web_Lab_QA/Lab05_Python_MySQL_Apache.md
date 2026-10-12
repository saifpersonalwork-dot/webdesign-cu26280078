# Lab Sheet 5: Apache + Python + MySQL

> Lab Sheet 6 ke questions bilkul isi sheet ke same hain, to isi file ke answers dono ke liye hain.

## Setup (Ubuntu)
```bash
sudo apt update
sudo apt install -y apache2 mariadb-server python3 python3-venv libapache2-mod-wsgi-py3
sudo a2enmod cgi
sudo systemctl restart apache2

# Python packages virtual environment mein (naye Ubuntu mein sidhi pip install allowed nahi hai)
sudo python3 -m venv /var/www/venv
sudo /var/www/venv/bin/pip install pymysql mysql-connector-python sqlalchemy
```
**Database user (pehle ek baar):**
```sql
-- sudo mysql
CREATE DATABASE IF NOT EXISTS python_web_db;
CREATE USER IF NOT EXISTS 'pyuser'@'localhost' IDENTIFIED BY 'pypass123';
GRANT ALL PRIVILEGES ON python_web_db.* TO 'pyuser'@'localhost';
FLUSH PRIVILEGES;
```
**Common file `/usr/lib/cgi-bin/dbconfig.py`:**
```python
DB = dict(host="localhost", user="pyuser", password="pypass123", database="python_web_db")
```
CGI scripts `/usr/lib/cgi-bin/` mein rakho, `sudo chmod +x file.py`, aur URL `http://localhost/cgi-bin/file.py`. Pehli line: `#!/var/www/venv/bin/python`.

Note: Python 3.13+ mein `cgi` module hata diya gaya hai. Neeche CGI scripts `urllib.parse` se form data padhte hain, isliye har Python version par chalte hain. (Purane Python mein `cgi.FieldStorage()` bhi chalta hai.)

---

**Q1. Apache par Python CGI / WSGI configure karo aur Hello World verify karo.**

*CGI:* `/usr/lib/cgi-bin/hello.py`
```python
#!/usr/bin/python3
print("Content-Type: text/html\n")
print("<h1>Hello World from Python CGI</h1>")
```
```bash
sudo chmod +x /usr/lib/cgi-bin/hello.py
curl http://localhost/cgi-bin/hello.py
```
*WSGI (mod_wsgi):* `/var/www/wsgi/hello.py`
```python
def application(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/plain")])
    return [b"Hello World from WSGI"]
```
`/etc/apache2/conf-available/wsgi-lab.conf`
```apache
WSGIScriptAlias /hello /var/www/wsgi/hello.py
<Directory /var/www/wsgi>
    Require all granted
</Directory>
```
```bash
sudo a2enconf wsgi-lab && sudo systemctl reload apache2
curl http://localhost/hello
```

**Q2. Python MySQL connector libraries install karo.**
```bash
sudo /var/www/venv/bin/pip install mysql-connector-python PyMySQL
/var/www/venv/bin/python -c "import pymysql, mysql.connector; print('Both installed')"
```

**Q3. MySQL server ka version query karo.**
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB)
cur = conn.cursor()
cur.execute("SELECT VERSION()")
print("MySQL version:", cur.fetchone()[0])
conn.close()
```

**Q4. `python_web_db` database aur `users` table banao.**
```python
import pymysql
conn = pymysql.connect(host="localhost", user="pyuser", password="pypass123")
cur = conn.cursor()
cur.execute("CREATE DATABASE IF NOT EXISTS python_web_db")
cur.execute("USE python_web_db")
cur.execute("""CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INT
)""")
conn.commit(); conn.close()
print("Database and table ready")
```

**Q5. `executemany()` se multiple records insert karo.**
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
data = [("Amit", "amit@example.com", 22), ("Neha", "neha@example.com", 21), ("Ravi", "ravi@example.com", 23)]
cur.executemany("INSERT INTO users (name, email, age) VALUES (%s, %s, %s)", data)
conn.commit()
print(cur.rowcount, "rows inserted")
conn.close()
```

**Q6. Saare records HTML response string mein.** `/usr/lib/cgi-bin/list.py`
```python
#!/var/www/venv/bin/python
import pymysql, html
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
cur.execute("SELECT id, name, email, age FROM users")
rows = cur.fetchall(); conn.close()

out = "<table border='1' cellpadding='6'><tr><th>ID</th><th>Name</th><th>Email</th><th>Age</th></tr>"
for r in rows:
    out += "<tr>" + "".join(f"<td>{html.escape(str(c))}</td>" for c in r) + "</tr>"
out += "</table>"
print("Content-Type: text/html\n")
print(out)
```

**Q7. CGI se form input lo aur MySQL mein insert karo.**
`/var/www/html/form.html`
```html
<form action="/cgi-bin/add_user.py" method="post">
  Name: <input name="name"><br>
  Email: <input name="email"><br>
  Age: <input name="age" type="number"><br>
  <button>Add</button>
</form>
```
`/usr/lib/cgi-bin/add_user.py`
```python
#!/var/www/venv/bin/python
import os, sys, pymysql
from urllib.parse import parse_qs
from dbconfig import DB

length = int(os.environ.get("CONTENT_LENGTH") or 0)
form = parse_qs(sys.stdin.read(length))
name  = form.get("name",  [""])[0]
email = form.get("email", [""])[0]
age   = form.get("age",   ["0"])[0]

print("Content-Type: text/html\n")
conn = pymysql.connect(**DB); cur = conn.cursor()
cur.execute("INSERT INTO users (name, email, age) VALUES (%s, %s, %s)", (name, email, age))
conn.commit(); conn.close()
print("<h3>User added successfully</h3><a href='/cgi-bin/list.py'>View users</a>")
```

**Q8. User ID se profile update.**
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
user_id, new_email, new_age = 1, "amit.new@example.com", 25
cur.execute("UPDATE users SET email = %s, age = %s WHERE id = %s", (new_email, new_age, user_id))
conn.commit()
print(cur.rowcount, "row(s) updated")
conn.close()
```

**Q9. Record delete + exception handling.**
```python
import pymysql
from dbconfig import DB
try:
    conn = pymysql.connect(**DB); cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE id = %s", (3,))
    conn.commit()
    print("Deleted rows:", cur.rowcount)
except pymysql.MySQLError as e:
    print("Database error:", e)
    conn.rollback()
finally:
    conn.close()
```

**Q10. `.htaccess` se Python scripts execute karo.**
Apache config mein directory ke liye `AllowOverride All` chahiye:
```apache
# /etc/apache2/conf-available/pyweb.conf
<Directory /var/www/html/pyapp>
    AllowOverride All
</Directory>
```
`/var/www/html/pyapp/.htaccess`
```apache
Options +ExecCGI
AddHandler cgi-script .py
DirectoryIndex index.py
```
```bash
sudo a2enconf pyweb && sudo systemctl reload apache2
sudo chmod +x /var/www/html/pyapp/*.py
```
Ab `/var/www/html/pyapp/index.py` (shebang + Content-Type header ke saath) browser mein seedha chalegi.

**Q11. Parameterized query (SQL injection se bachav).**
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
search = "Amit' OR '1'='1"                       # injection ki koshish
cur.execute("SELECT id, name FROM users WHERE name = %s AND age > %s", (search, 18))
print(cur.fetchall())                            # () khali, injection fail
conn.close()
```
`%s` placeholders driver ko data ko value ki tarah treat karne ko kehte hain, SQL ka hissa nahi.

**Q12. Connection pooling.**
```python
from mysql.connector import pooling
from dbconfig import DB

pool = pooling.MySQLConnectionPool(pool_name="webpool", pool_size=5, **DB)

def get_users():
    conn = pool.get_connection()          # pool se connection lo
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM users")
        return cur.fetchall()
    finally:
        conn.close()                      # pool ko wapas return hota hai, band nahi hota

print(get_users())
```
Har request par naya connection banane ke bajaye pool se reuse hota hai, isse zyada concurrency mein speed aur resources bachte hain. (CGI har request par naya process chalata hai, isliye pooling asli faayda WSGI/long-running app mein deti hai.)

**Q13. DB errors aur access timestamps log file mein.**
```python
import logging, pymysql
from datetime import datetime
from dbconfig import DB

logging.basicConfig(filename="/tmp/pyweb.log", level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")
logging.info("Request received at %s", datetime.now())
try:
    conn = pymysql.connect(**{**DB, "password": "wrong"})
except pymysql.MySQLError as e:
    logging.error("DB connection failed: %s", e)
```
```bash
cat /tmp/pyweb.log
```
(Apache chalane par `www-data` ko likhne ki permission wali jagah chuno, jaise `/var/log/pyweb/`.)

**Q14. CSV se bulk insert.**
`users.csv`
```
name,email,age
Sita,sita@example.com,20
Karan,karan@example.com,24
Mona,mona@example.com,22
```
```python
import csv, pymysql
from dbconfig import DB
with open("users.csv", newline="") as f:
    rows = [(r["name"], r["email"], int(r["age"])) for r in csv.DictReader(f)]
conn = pymysql.connect(**DB); cur = conn.cursor()
cur.executemany("INSERT INTO users (name, email, age) VALUES (%s, %s, %s)", rows)
conn.commit()
print(len(rows), "rows bulk inserted")
conn.close()
```

**Q15. SQLAlchemy ORM.**
```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker

engine = create_engine("mysql+pymysql://pyuser:pypass123@localhost/python_web_db")
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(String(100))
    email = Column(String(100))
    age = Column(Integer)

Session = sessionmaker(bind=engine)
s = Session()
s.add(User(name="Tina", email="tina@example.com", age=22))
s.commit()
for u in s.query(User).filter(User.age > 20).all():
    print(u.id, u.name, u.email)
s.close()
```

**Q16. MySQL se JSON response wala endpoint.** `/usr/lib/cgi-bin/api.py`
```python
#!/var/www/venv/bin/python
import json, pymysql
from dbconfig import DB
conn = pymysql.connect(**DB, cursorclass=pymysql.cursors.DictCursor)
cur = conn.cursor(); cur.execute("SELECT id, name, email, age FROM users")
data = cur.fetchall(); conn.close()
print("Content-Type: application/json\n")
print(json.dumps(data))
```
```bash
curl http://localhost/cgi-bin/api.py
```

**Q17. MySQL database ka `.sql` backup.**
```python
import subprocess
from dbconfig import DB
with open("backup.sql", "w") as f:
    subprocess.run(["mysqldump", "-u", DB["user"], f"-p{DB['password']}", DB["database"]], stdout=f, check=True)
print("Backup saved to backup.sql")
```
Programmatic (bina mysqldump):
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
cur.execute("SELECT * FROM users")
with open("backup2.sql", "w") as f:
    cur.execute("SHOW CREATE TABLE users"); f.write(cur.fetchone()[1] + ";\n\n")
    cur.execute("SELECT * FROM users")
    for row in cur.fetchall():
        vals = ", ".join(conn.escape(v) for v in row)
        f.write(f"INSERT INTO users VALUES ({vals});\n")
conn.close()
```

**Q18. User session handling (MySQL backend).**
```sql
CREATE TABLE sessions (sid VARCHAR(64) PRIMARY KEY, username VARCHAR(50), created TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
```
`/usr/lib/cgi-bin/session.py`
```python
#!/var/www/venv/bin/python
import os, uuid, pymysql
from http.cookies import SimpleCookie
from dbconfig import DB

cookie = SimpleCookie(os.environ.get("HTTP_COOKIE", ""))
conn = pymysql.connect(**DB); cur = conn.cursor()
sid = cookie["sid"].value if "sid" in cookie else None

cur.execute("SELECT username FROM sessions WHERE sid = %s", (sid,))
row = cur.fetchone()
if row:
    print("Content-Type: text/html\n"); print("Welcome back, " + row[0])
else:
    sid = uuid.uuid4().hex
    cur.execute("INSERT INTO sessions (sid, username) VALUES (%s, %s)", (sid, "guest"))
    conn.commit()
    print(f"Set-Cookie: sid={sid}; HttpOnly; Path=/")
    print("Content-Type: text/html\n"); print("New session created for guest")
conn.close()
```

**Q19. Form inputs verify aur sanitize karo, phir SQL write.**
```python
import re, html, pymysql
from dbconfig import DB

def clean_user(name, email, age):
    name = html.escape(name.strip())
    if not re.fullmatch(r"[A-Za-z ]{2,50}", name):
        raise ValueError("Invalid name")
    if not re.fullmatch(r"[^@\s]+@[^@\s]+\.[a-z]{2,}", email.strip(), re.I):
        raise ValueError("Invalid email")
    age = int(age)
    if not 1 <= age <= 120:
        raise ValueError("Invalid age")
    return name, email.strip().lower(), age

try:
    vals = clean_user("  Rahul ", "rahul@example.com", "24")
    conn = pymysql.connect(**DB); cur = conn.cursor()
    cur.execute("INSERT INTO users (name, email, age) VALUES (%s, %s, %s)", vals)
    conn.commit(); conn.close(); print("Saved", vals)
except ValueError as e:
    print("Rejected:", e)
```

**Q20. Virtual environment (`venv`) aur Apache deployment.**
```bash
sudo python3 -m venv /var/www/venv
sudo /var/www/venv/bin/pip install pymysql sqlalchemy
```
CGI ke liye: script ki shebang `#!/var/www/venv/bin/python`.
mod_wsgi ke liye `/etc/apache2/conf-available/wsgi-lab.conf`:
```apache
WSGIDaemonProcess pyapp python-home=/var/www/venv python-path=/var/www/wsgi
WSGIProcessGroup pyapp
WSGIScriptAlias /hello /var/www/wsgi/hello.py
```
```bash
sudo systemctl reload apache2
```

**Q21. Analytical summary report (count, average).**
```python
import pymysql
from dbconfig import DB
conn = pymysql.connect(**DB); cur = conn.cursor()
cur.execute("SELECT COUNT(*), AVG(age), MIN(age), MAX(age) FROM users")
cnt, avg, mn, mx = cur.fetchone()
print(f"Total users: {cnt}\nAverage age: {avg:.1f}\nYoungest: {mn}\nOldest: {mx}")
cur.execute("SELECT age, COUNT(*) FROM users GROUP BY age ORDER BY age")
for age, c in cur.fetchall():
    print(f"Age {age}: {c} user(s)")
conn.close()
```
