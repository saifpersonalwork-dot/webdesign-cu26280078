# Lab Sheet 1: HTML5

Har snippet ko boilerplate (`<!DOCTYPE html>...<body>`) ke andar rakhna hai. Q1 mein poora page diya hai.

**Q1. Basic HTML5 page: heading + paragraph (favourite hobby).**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Hobby</title>
</head>
<body>
  <h1>My Favourite Hobby</h1>
  <p>I love playing cricket. It keeps me fit and teaches me teamwork.</p>
</body>
</html>
```

**Q2. Text formatting tags.**
```html
<p><b>Bold</b> and <strong>strong (important)</strong></p>
<p><i>Italic</i> and <em>emphasised</em></p>
<p><u>Underlined</u> text</p>
<p><del>Strikethrough</del> text</p>
```

**Q3. Saare heading levels + paragraphs.**
```html
<h1>Heading 1</h1><p>Paragraph under h1.</p>
<h2>Heading 2</h2><p>Paragraph under h2.</p>
<h3>Heading 3</h3><p>Paragraph under h3.</p>
<h4>Heading 4</h4><p>Paragraph under h4.</p>
<h5>Heading 5</h5><p>Paragraph under h5.</p>
<h6>Heading 6</h6><p>Paragraph under h6.</p>
```

**Q4. blockquote, q, cite.**
```html
<blockquote>
  The best way to predict the future is to invent it.
  <br><cite>- Alan Kay</cite>
</blockquote>
<p>As Gandhi said, <q>Be the change you wish to see in the world.</q></p>
```

**Q5. Recipe page: hr aur br.**
```html
<h1>Masala Chai</h1>
<hr/>
<h2>Ingredients</h2>
<p>Water, milk, tea leaves, ginger, sugar</p>
<hr/>
<h2>Method</h2>
<p>Boil water with ginger, add tea and milk, strain and serve.</p>
<hr/>
<address>
  Chai Corner<br/>
  12, Main Market<br/>
  Roorkee, Uttarakhand<br/>
  India
</address>
```

**Q6. Unordered list: top 5 movies.**
```html
<h2>Top 5 Movies</h2>
<ul>
  <li>3 Idiots</li>
  <li>Dangal</li>
  <li>Inception</li>
  <li>Interstellar</li>
  <li>The Dark Knight</li>
</ul>
```

**Q7. Ordered list: step-by-step guide.**
```html
<h2>How to Make Tea</h2>
<ol>
  <li>Boil water in a pan.</li>
  <li>Add tea leaves and ginger.</li>
  <li>Pour in milk.</li>
  <li>Strain into a cup and serve.</li>
</ol>
```

**Q8. Description list: glossary.**
```html
<dl>
  <dt>CPU</dt><dd>Central Processing Unit, the brain of the computer.</dd>
  <dt>RAM</dt><dd>Random Access Memory, temporary working memory.</dd>
  <dt>OS</dt><dd>Operating System, software that manages hardware.</dd>
</dl>
```

**Q9. Multi-level nested list: university course structure.**
```html
<ul>
  <li>MCA
    <ul>
      <li>Semester 1
        <ul><li>Programming in C</li><li>Data Structures</li></ul>
      </li>
      <li>Semester 2
        <ul><li>Web Technology</li><li>DBMS</li></ul>
      </li>
    </ul>
  </li>
  <li>BCA
    <ul><li>Semester 1</li><li>Semester 2</li></ul>
  </li>
</ul>
```

**Q10. Ordered list with Roman numerals aur lowercase letters.**
```html
<ol type="I">
  <li>Frontend
    <ol type="a"><li>HTML</li><li>CSS</li><li>JavaScript</li></ol>
  </li>
  <li>Backend
    <ol type="a"><li>PHP</li><li>Python</li></ol>
  </li>
</ol>
```

**Q11. img tag (src aur alt).**
```html
<img src="images/campus.jpg" alt="University campus building">
```

**Q12. Image with width aur height.**
```html
<img src="images/campus.jpg" alt="Campus" width="400" height="250">
```

**Q13. Image click par external site khule.**
```html
<a href="https://www.wikipedia.org" target="_blank" rel="noopener">
  <img src="images/logo.png" alt="Visit Wikipedia" width="150">
</a>
```

**Q14. figure aur figcaption.**
```html
<figure>
  <img src="images/taj.jpg" alt="Taj Mahal at sunrise" width="400">
  <figcaption>Fig 1: The Taj Mahal at sunrise, Agra.</figcaption>
</figure>
```

**Q15. Local folder aur external URL se image.**
```html
<!-- Local folder: images/ -->
<img src="images/photo.jpg" alt="Local image" width="250">

<!-- External URL -->
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png"
     alt="External image" width="250">
```

**Q16. 3x3 student table.**
```html
<table border="1" cellpadding="6">
  <tr><th>Roll No</th><th>Name</th><th>Course</th></tr>
  <tr><td>101</td><td>Amit</td><td>MCA</td></tr>
  <tr><td>102</td><td>Neha</td><td>MCA</td></tr>
</table>
```

**Q17. Product price table: caption + th.**
```html
<table border="1" cellpadding="6">
  <caption>Product Price List</caption>
  <tr><th>Product</th><th>Price (Rs.)</th></tr>
  <tr><td>Notebook</td><td>60</td></tr>
  <tr><td>Pen</td><td>10</td></tr>
  <tr><td>Bag</td><td>650</td></tr>
</table>
```

**Q18. Timetable: colspan.**
```html
<table border="1" cellpadding="6">
  <tr><th>Day</th><th>9-10</th><th>10-11</th><th>11-12</th></tr>
  <tr><td>Mon</td><td>Web Tech</td><td colspan="2">Web Tech Lab</td></tr>
  <tr><td>Tue</td><td>DBMS</td><td>Maths</td><td>DBMS</td></tr>
</table>
```

**Q19. Table: rowspan.**
```html
<table border="1" cellpadding="6">
  <tr><th>Department</th><th>Course</th><th>Seats</th></tr>
  <tr><td rowspan="2">Computer Applications</td><td>MCA</td><td>60</td></tr>
  <tr><td>BCA</td><td>120</td></tr>
  <tr><td rowspan="2">Engineering</td><td>CSE</td><td>180</td></tr>
  <tr><td>ECE</td><td>120</td></tr>
</table>
```

**Q20. Financial report: thead, tbody, tfoot.**
```html
<table border="1" cellpadding="6">
  <thead><tr><th>Month</th><th>Income</th><th>Expense</th></tr></thead>
  <tbody>
    <tr><td>Jan</td><td>50000</td><td>30000</td></tr>
    <tr><td>Feb</td><td>55000</td><td>32000</td></tr>
  </tbody>
  <tfoot><tr><th>Total</th><td>105000</td><td>62000</td></tr></tfoot>
</table>
```

**Q21. Registration form: First Name, Last Name, Email, Submit.**
```html
<form action="#" method="post">
  <label for="fn">First Name:</label>
  <input type="text" id="fn" name="firstname"><br><br>
  <label for="ln">Last Name:</label>
  <input type="text" id="ln" name="lastname"><br><br>
  <label for="em">Email:</label>
  <input type="email" id="em" name="email"><br><br>
  <input type="submit" value="Register">
</form>
```

**Q22. Radio buttons (gender) aur checkboxes (hobbies).**
```html
<form>
  <p>Gender:
    <label><input type="radio" name="gender" value="male"> Male</label>
    <label><input type="radio" name="gender" value="female"> Female</label>
    <label><input type="radio" name="gender" value="other"> Other</label>
  </p>
  <p>Hobbies:
    <label><input type="checkbox" name="hobby" value="reading"> Reading</label>
    <label><input type="checkbox" name="hobby" value="music"> Music</label>
    <label><input type="checkbox" name="hobby" value="sports"> Sports</label>
  </p>
</form>
```

**Q23. City dropdown.**
```html
<label for="city">City:</label>
<select id="city" name="city">
  <option value="">-- Select --</option>
  <option value="roorkee">Roorkee</option>
  <option value="dehradun">Dehradun</option>
  <option value="haridwar">Haridwar</option>
  <option value="delhi">Delhi</option>
</select>
```

**Q24. Feedback form: textarea + file upload.**
```html
<form action="#" method="post" enctype="multipart/form-data">
  <label for="cm">Comments:</label><br>
  <textarea id="cm" name="comments" rows="5" cols="40"></textarea><br><br>
  <label for="fl">Attach file:</label>
  <input type="file" id="fl" name="attachment"><br><br>
  <input type="submit" value="Send Feedback">
</form>
```

**Q25. Survey form: fieldset aur legend.**
```html
<form>
  <fieldset>
    <legend>Personal Information</legend>
    <label>Name: <input type="text" name="name"></label><br>
    <label>Age: <input type="number" name="age"></label>
  </fieldset>
  <fieldset>
    <legend>Course Feedback</legend>
    <p>Rating:
      <label><input type="radio" name="rate" value="1"> 1</label>
      <label><input type="radio" name="rate" value="3"> 3</label>
      <label><input type="radio" name="rate" value="5"> 5</label>
    </p>
    <textarea name="suggestion" rows="3" cols="30"></textarea>
  </fieldset>
  <input type="submit" value="Submit Survey">
</form>
```
